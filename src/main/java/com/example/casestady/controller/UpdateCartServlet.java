package com.example.casestady.controller; // Đảm bảo package đúng

import com.example.casestady.model.CartItem;
import com.example.casestady.model.Product; // Cần để kiểm tra stock
import com.example.casestady.dao.ProductDAO;  // Cần để kiểm tra stock

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UpdateCartServlet", urlPatterns = "/updateCart")
public class UpdateCartServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UpdateCartServlet.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session, không tạo mới
        String cartActionMessage = "";

        if (session == null || session.getAttribute("cart") == null) {
            // Không có giỏ hàng hoặc session không tồn tại, không có gì để làm
            response.sendRedirect(request.getContextPath() + "/viewCart"); // Redirect về trang giỏ hàng (sẽ báo rỗng)
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            cartActionMessage = "Lỗi: Thiếu thông tin sản phẩm hoặc số lượng để cập nhật.";
        } else {
            try {
                int productId = Integer.parseInt(productIdStr);
                int newQuantity = Integer.parseInt(quantityStr);

                if (cart.containsKey(productId)) {
                    CartItem item = cart.get(productId);
                    Product product = productDAO.getProductById(productId); // Lấy thông tin sản phẩm để check stock

                    if (product == null) {
                        cartActionMessage = "Lỗi: Sản phẩm không còn tồn tại.";
                        cart.remove(productId); // Xóa khỏi giỏ nếu sản phẩm không còn
                    } else if (newQuantity <= 0) {
                        // Nếu số lượng mới là 0 hoặc âm, xóa sản phẩm khỏi giỏ
                        cart.remove(productId);
                        cartActionMessage = "Đã xóa '" + item.getProduct().getName() + "' khỏi giỏ hàng.";
                    } else if (newQuantity > product.getStockQuantity()) {
                        // Nếu số lượng mới vượt quá tồn kho
                        item.setQuantity(product.getStockQuantity()); // Đặt số lượng bằng tồn kho
                        cartActionMessage = "Số lượng cho '" + item.getProduct().getName() + "' đã được cập nhật thành " + product.getStockQuantity() + " (tối đa tồn kho).";
                    }
                    else {
                        // Cập nhật số lượng
                        item.setQuantity(newQuantity);
                        cartActionMessage = "Đã cập nhật số lượng cho '" + item.getProduct().getName() + "'.";
                    }
                } else {
                    cartActionMessage = "Lỗi: Sản phẩm không tìm thấy trong giỏ hàng để cập nhật.";
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid format for productId or quantity", e);
                cartActionMessage = "Lỗi: Định dạng ID sản phẩm hoặc số lượng không hợp lệ.";
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error updating cart", e);
                cartActionMessage = "Lỗi: Đã có lỗi xảy ra khi cập nhật giỏ hàng.";
            }
        }

        session.setAttribute("cart", cart); // Lưu lại giỏ hàng đã cập nhật
        if (!cartActionMessage.isEmpty()) {
            session.setAttribute("cartActionMessage", cartActionMessage);
        }

        // Redirect trở lại trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/viewCart");
    }

    // doGet có thể không cần thiết hoặc chỉ redirect về giỏ hàng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/viewCart");
    }
}