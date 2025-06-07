package com.example.casestady.controller; // Đảm bảo package đúng

import com.example.casestady.model.CartItem;
import com.example.casestady.dao.CategoryDAO; // Để lấy danh mục cho header menu
import com.example.casestady.model.Category;  // Để lấy danh mục cho header menu
import com.example.casestady.util.CartUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet(name = "ViewCartServlet", urlPatterns = "/viewCart")
public class ViewCartServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ViewCartServlet.class.getName());
    private CategoryDAO categoryDAO; // Để load categories cho menu

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới
        Map<Integer, CartItem> cart = null;
        List<CartItem> cartItemsList = new ArrayList<>(); // Chuyển Map thành List để dễ lặp trong JSTL
        BigDecimal totalCartAmount = BigDecimal.ZERO;
        int totalCartItems = 0;

        if (session != null) {
            cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        }

        if (cart != null && !cart.isEmpty()) {
            for (CartItem item : cart.values()) {
                cartItemsList.add(item);
                totalCartAmount = totalCartAmount.add(item.getSubtotal());
            }
        }

        request.setAttribute("cartItemsList", cartItemsList);
        request.setAttribute("totalCartAmount", totalCartAmount);
        CartUtil.getTotalItemsInCart(request);
        // Lấy danh sách category cho menu header
        try {
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories); // Dùng tên nhất quán với các servlet khác
        } catch (Exception e) {
            LOGGER.warning("Không thể tải danh mục cho tiêu đề trang giỏ hàng: " + e.getMessage());
        }

        // Forward đến trang cart.jsp (giả sử nằm ở webapp/cart.jsp)
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trang xem giỏ hàng thường không xử lý POST, có thể redirect về GET
        doGet(request, response);
    }
}