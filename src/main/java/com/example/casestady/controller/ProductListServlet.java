package com.example.casestady.controller; // Đảm bảo package đúng

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.dao.ProductDAO;
import com.example.casestady.model.Category;
import com.example.casestady.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ProductListServlet", urlPatterns = "/products")
public class ProductListServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProductListServlet.class.getName());
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO; // Cần để lấy tên category nếu muốn hiển thị

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String categoryIdStr = request.getParameter("categoryId");
            List<Product> productList;
            String pageTitle = "All Products"; // Tiêu đề mặc định

            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdStr);
                    productList = productDAO.getProductsByCategoryId(categoryId);
                    Category currentCategory = categoryDAO.getCategoryById(categoryId);
                    if (currentCategory != null) {
                        pageTitle = "Products in: " + currentCategory.getName();
                        request.setAttribute("currentCategoryName", currentCategory.getName());
                    } else {
                        pageTitle = "Products for Category ID: " + categoryId; // Nếu không tìm thấy tên category
                        request.setAttribute("errorMessage", "Category not found for ID: " + categoryId + ". Showing all products.");
                        productList = productDAO.getAllProducts(); // Dự phòng: hiển thị tất cả nếu category ID không hợp lệ
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid categoryId format: " + categoryIdStr, e);
                    request.setAttribute("errorMessage", "Invalid category ID format. Showing all products.");
                    productList = productDAO.getAllProducts(); // Dự phòng
                }
            } else {
                // Không có categoryId, hiển thị tất cả sản phẩm
                productList = productDAO.getAllProducts();
            }

            request.setAttribute("productList", productList);
            request.setAttribute("pageTitle", pageTitle); // Để hiển thị tiêu đề trang động

            // Lấy tất cả danh mục để hiển thị menu (giống như HomeServlet)
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            // Forward đến trang productList.jsp (giả sử nằm ở webapp/productList.jsp)
            request.getRequestDispatcher("/productList.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading product list", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred while loading products.");
        }
    }
}