package com.example.casestady.controller;

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.model.Category;
import com.example.casestady.util.CartUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "OrderConfirmationServlet", urlPatterns = "/orderConfirmation")
public class OrderConfirmationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderConfirmationServlet.class.getName());
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cập nhật cart count (sẽ là 0 nếu giỏ hàng đã bị xóa bởi CheckoutServlet)
        CartUtil.getTotalItemsInCart(request);

        try {
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);
        } catch (Exception e) {
            LOGGER.warning("Could not load categories for order confirmation page header: " + e.getMessage());
        }

        request.getRequestDispatcher("/orderConfirmation.jsp").forward(request, response);
    }
}