package com.example.casestady.controller; // Đảm bảo package đúng

import com.example.casestady.model.CartItem;

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

@WebServlet(name = "RemoveFromCartServlet", urlPatterns = "/removeFromCart")
public class RemoveFromCartServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RemoveFromCartServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Việc xóa thường được thực hiện qua GET khi nhấp link
        HttpSession session = request.getSession(false);
        String cartActionMessage = "";

        if (session == null || session.getAttribute("cart") == null) {
            response.sendRedirect(request.getContextPath() + "/viewCart");
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null) {
            cartActionMessage = "Lỗi: Thiếu ID sản phẩm để xóa.";
        } else {
            try {
                int productId = Integer.parseInt(productIdStr);
                if (cart.containsKey(productId)) {
                    CartItem removedItem = cart.remove(productId); // Xóa và lấy ra item đã xóa
                    cartActionMessage = "Đã xóa '" + removedItem.getProduct().getName() + "' khỏi giỏ hàng.";
                } else {
                    cartActionMessage = "Lỗi: Sản phẩm không tìm thấy trong giỏ hàng để xóa.";
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Định dạng không hợp lệ cho ID của sản phẩm để xóa", e);
                cartActionMessage = "Lỗi: Định dạng ID sản phẩm không hợp lệ.";
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi xóa sản phẩm khỏi giỏ hàng", e);
                cartActionMessage = "Lỗi: Đã có lỗi xảy ra khi xóa sản phẩm.";
            }
        }

        session.setAttribute("cart", cart); // Lưu lại giỏ hàng đã cập nhật
        if (!cartActionMessage.isEmpty()){
            session.setAttribute("cartActionMessage", cartActionMessage);
        }

        response.sendRedirect(request.getContextPath() + "/viewCart");
    }

    // doPost có thể gọi doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}