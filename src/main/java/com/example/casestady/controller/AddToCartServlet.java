package com.example.casestady.controller;

import com.example.casestady.dao.ProductDAO;
import com.example.casestady.model.CartItem;
import com.example.casestady.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "AddToCartServlet", urlPatterns = "/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AddToCartServlet.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chúng ta chủ yếu dùng POST cho việc thay đổi dữ liệu (thêm vào giỏ)
        // doGet có thể redirect về trang chủ hoặc trang sản phẩm nếu truy cập trực tiếp
        handleCartAction(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleCartAction(request, response);
    }

    private void handleCartAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(); // Luôn lấy session, tạo mới nếu chưa có

        // Lấy giỏ hàng từ session
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity"); // Số lượng có thể được truyền từ form chi tiết sản phẩm

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            // Xử lý lỗi: không có productId
            LOGGER.log(Level.WARNING, "Thêm vào giỏ hàng không thành công: thiếu productId.");
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath() + "/home");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantityToAdd = 1; // Mặc định thêm 1 sản phẩm
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                try {
                    quantityToAdd = Integer.parseInt(quantityStr);
                    if (quantityToAdd <= 0) {
                        quantityToAdd = 1; // Đảm bảo số lượng là dương
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Định dạng số lượng không hợp lệ, mặc định là 1: " + quantityStr);
                    quantityToAdd = 1;
                }
            }

            Product product = productDAO.getProductById(productId);

            if (product != null) {
                // Kiểm tra số lượng tồn kho
                if (product.getStockQuantity() <= 0) {
                    session.setAttribute("cartMessage", "Sản phẩm '" + product.getName() + "' đã hết hàng!");
                    response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath() + "/home");
                    return;
                }


                CartItem cartItem;
                if (cart.containsKey(productId)) {
                    // Sản phẩm đã có trong giỏ, tăng số lượng
                    cartItem = cart.get(productId);
                    int newQuantity = cartItem.getQuantity() + quantityToAdd;
                    // Kiểm tra nếu số lượng mới vượt quá tồn kho
                    if (newQuantity > product.getStockQuantity()){
                        newQuantity = product.getStockQuantity(); // Chỉ cho phép thêm tối đa số lượng tồn
                        session.setAttribute("cartMessage", "Số lượng sản phẩm '" + product.getName() + "' trong giỏ đã đạt tối đa tồn kho.");
                    }
                    cartItem.setQuantity(newQuantity);

                } else {
                    // Sản phẩm chưa có trong giỏ, thêm mới
                    // Đảm bảo quantityToAdd không vượt quá tồn kho
                    if (quantityToAdd > product.getStockQuantity()){
                        quantityToAdd = product.getStockQuantity();
                        session.setAttribute("cartMessage", "Số lượng sản phẩm '" + product.getName() + "' muốn thêm vượt quá tồn kho. Đã thêm tối đa có thể.");
                    }
                    cartItem = new CartItem(product, quantityToAdd);
                    cart.put(productId, cartItem);
                }
                if(!session.isNew() && session.getAttribute("cartMessage") == null) { // Chỉ set success nếu không có message lỗi/cảnh báo trước đó
                    session.setAttribute("cartMessage", "Đã thêm '" + product.getName() + "' vào giỏ hàng!");
                }


            } else {
                // Không tìm thấy sản phẩm
                LOGGER.log(Level.WARNING, "Thêm vào giỏ hàng không thành công: Không tìm thấy sản phẩm cho ID " + productId);
                session.setAttribute("cartMessage", "Lỗi: Sản phẩm không tồn tại!");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Thêm vào giỏ hàng không thành công: Định dạng productId không hợp lệ " + productIdStr, e);
            session.setAttribute("cartMessage", "Lỗi: ID sản phẩm không hợp lệ!");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi trong AddToCartServlet", e);
            session.setAttribute("cartMessage", "Lỗi: Đã có lỗi xảy ra, vui lòng thử lại.");
        }

        // Lưu lại giỏ hàng vào session
        session.setAttribute("cart", cart);

        // Chuyển hướng người dùng
        // Có thể redirect về trang trước đó (Referer) hoặc trang giỏ hàng
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            // Mặc định về trang chủ nếu không có Referer
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }


}