package com.example.casestady.controller;

import com.example.casestady.dao.OrderDAO;
// import com.example.casestady.dao.CategoryDAO; // Vẫn cần nếu header admin dùng
import com.example.casestady.model.AdminOrderItemView; // Import lớp mới
// import com.example.casestady.model.Category; // Vẫn cần nếu header admin dùng

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ViewOrdersServlet", urlPatterns = "/admin/viewOrders")
public class ViewOrdersServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ViewOrdersServlet.class.getName());
    private OrderDAO orderDAO;
    // private CategoryDAO categoryDAO; // Nếu header admin của bạn cần

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        // categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/adminLogin");
            return;
        }

        try {
            // Lấy danh sách các mục hàng đã đặt
            List<AdminOrderItemView> orderedItems = orderDAO.getAllOrderItemsForAdminView();
            request.setAttribute("orderedItemsList", orderedItems);

            // (Tùy chọn) Lấy danh mục cho header admin nếu có
            // List<Category> allCategories = categoryDAO.getAllCategories();
            // request.setAttribute("allCategoriesForAdminHeader", allCategories);

            request.getRequestDispatcher("/admin/adminViewOrderItems.jsp").forward(request, response); // Đổi tên JSP

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ViewOrdersServlet (loading ordered items)", e);
            request.setAttribute("errorMessage", "An error occurred while loading ordered items: " + e.getMessage());
            request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response); // Hoặc trang lỗi admin
        }
    }

    // doPost có thể không cần thiết cho việc chỉ xem, hoặc dùng để xử lý filter/sort sau này
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Tạm thời
    }
}