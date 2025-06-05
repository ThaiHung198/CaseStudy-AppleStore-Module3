package com.example.casestady.controller;

import com.example.casestady.dao.OrderDAO;
import com.example.casestady.dao.OrderDetailDAO;
import com.example.casestady.dao.ProductDAO;
import com.example.casestady.dao.CategoryDAO; // Cho header menu
import com.example.casestady.model.CartItem;
import com.example.casestady.model.Category;   // Cho header menu
import com.example.casestady.model.Order;
import com.example.casestady.model.OrderDetail;
import com.example.casestady.model.Product;
import com.example.casestady.util.CartUtil; // Sử dụng CartUtil

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CheckoutServlet", urlPatterns = "/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CheckoutServlet.class.getName());
    private OrderDAO orderDAO;
    private OrderDetailDAO orderDetailDAO;
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO; // Cho header menu

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        orderDetailDAO = new OrderDetailDAO();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Map<Integer, CartItem> cart = CartUtil.getCartFromSession(request); // Dùng util

        if (cart.isEmpty()) {
            // Nếu giỏ hàng trống, có thể redirect về trang giỏ hàng hoặc trang chủ với thông báo
            response.sendRedirect(request.getContextPath() + "/viewCart?message=emptycart");
            return;
        }

        List<CartItem> cartItemsListForCheckout = new ArrayList<>(cart.values());
        BigDecimal totalCartAmountForCheckout = BigDecimal.ZERO;
        for (CartItem item : cartItemsListForCheckout) {
            // Cập nhật lại giá sản phẩm từ DB để đảm bảo giá mới nhất (tùy chọn)
            // Product currentProductInfo = productDAO.getProductById(item.getProduct().getProductId());
            // if(currentProductInfo != null) item.getProduct().setPrice(currentProductInfo.getPrice());
            totalCartAmountForCheckout = totalCartAmountForCheckout.add(item.getSubtotal());
        }

        request.setAttribute("cartItemsListForCheckout", cartItemsListForCheckout);
        request.setAttribute("totalCartAmountForCheckout", totalCartAmountForCheckout);

        // Lấy danh mục cho header và totalCartItems
        CartUtil.getTotalItemsInCart(request); // Cập nhật cart count cho header
        try {
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);
        } catch (Exception e) {
            LOGGER.warning("Could not load categories for checkout page header: " + e.getMessage());
        }

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Map<Integer, CartItem> cart = CartUtil.getCartFromSession(request);

        if (cart.isEmpty()) {
            request.setAttribute("checkoutErrorMessage", "Giỏ hàng của bạn đang trống. Không thể đặt hàng.");
            doGet(request, response); // Hiển thị lại trang checkout với thông báo
            return;
        }

        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String customerPhone = request.getParameter("customerPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String notes = request.getParameter("notes");

        // Validation thông tin khách hàng
        if (customerName == null || customerName.trim().isEmpty() ||
                customerPhone == null || customerPhone.trim().isEmpty() ||
                shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("checkoutErrorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc: Họ tên, Số điện thoại, Địa chỉ giao hàng.");
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("customerName", customerName);
            request.setAttribute("customerEmail", customerEmail);
            request.setAttribute("customerPhone", customerPhone);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("notes", notes);
            doGet(request, response); // Hiển thị lại trang checkout với lỗi
            return;
        }

        // Tính lại tổng tiền từ cart trong session để đảm bảo chính xác
        BigDecimal finalTotalAmount = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            // Nên lấy giá mới nhất từ DB tại thời điểm này để đảm bảo không bị thay đổi giá bất ngờ
            Product currentProduct = productDAO.getProductById(item.getProduct().getProductId());
            if (currentProduct == null || currentProduct.getStockQuantity() < item.getQuantity()) {
                request.setAttribute("checkoutErrorMessage", "Sản phẩm '" + item.getProduct().getName() + "' không đủ số lượng tồn kho hoặc không còn tồn tại.");
                doGet(request, response);
                return;
            }
            item.getProduct().setPrice(currentProduct.getPrice()); // Cập nhật giá mới nhất vào cart item
            finalTotalAmount = finalTotalAmount.add(item.getSubtotal());
        }


        // 1. Tạo Order
        Order order = new Order();
        order.setCustomerName(customerName);
        order.setCustomerEmail(customerEmail);
        order.setCustomerPhone(customerPhone);
        order.setShippingAddress(shippingAddress);
        order.setTotalAmount(finalTotalAmount);
        order.setNotes(notes);
        order.setStatus("Pending"); // Trạng thái ban đầu

        int orderId = orderDAO.addOrder(order);

        if (orderId != -1) {
            // 2. Thêm OrderDetails và cập nhật số lượng sản phẩm
            boolean allDetailsAdded = true;
            for (CartItem item : cart.values()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderId(orderId);
                detail.setProductId(item.getProduct().getProductId());
                detail.setQuantity(item.getQuantity());
                detail.setPriceAtPurchase(item.getProduct().getPrice()); // Giá đã được cập nhật từ DB ở trên

                if (!orderDetailDAO.addOrderDetail(detail)) {
                    allDetailsAdded = false;
                    LOGGER.log(Level.SEVERE, "Failed to add order detail for product ID: " + item.getProduct().getProductId() + " and order ID: " + orderId);
                    // Xử lý lỗi nghiêm trọng: có thể rollback transaction nếu dùng, hoặc xóa order đã tạo
                    break;
                }

                // 3. Cập nhật số lượng tồn kho sản phẩm
                Product productInCart = item.getProduct();
                int newStock = productInCart.getStockQuantity() - item.getQuantity();
                if (!productDAO.updateStockQuantity(productInCart.getProductId(), newStock)) {
                    LOGGER.log(Level.WARNING, "Failed to update stock for product ID: " + productInCart.getProductId());
                    // Cân nhắc xử lý lỗi này, có thể đơn hàng đã được tạo một phần
                }
            }

            if (allDetailsAdded) {
                // 4. Xóa giỏ hàng khỏi session
                session.removeAttribute("cart");
                session.removeAttribute("totalCartItems"); // Xóa cả số lượng item hiển thị

                // 5. Redirect đến trang xác nhận đơn hàng
                session.setAttribute("lastOrderId", orderId); // Lưu orderId để trang xác nhận có thể lấy
                response.sendRedirect(request.getContextPath() + "/orderConfirmation");
                return;
            } else {
                // Xử lý trường hợp không thêm được tất cả order details
                // Đây là trường hợp phức tạp, có thể cần rollback hoặc thông báo lỗi cụ thể
                request.setAttribute("checkoutErrorMessage", "Đã có lỗi nghiêm trọng khi lưu chi tiết đơn hàng. Vui lòng liên hệ hỗ trợ.");
            }

        } else {
            request.setAttribute("checkoutErrorMessage", "Không thể tạo đơn hàng. Vui lòng thử lại.");
        }

        // Nếu có lỗi ở trên mà chưa redirect, hiển thị lại trang checkout
        doGet(request, response);
    }
}