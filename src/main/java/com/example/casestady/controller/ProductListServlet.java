package com.example.casestady.controller; // Đảm bảo package đúng

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.dao.ProductDAO;
import com.example.casestady.model.CartItem;
import com.example.casestady.model.Category;
import com.example.casestady.model.Product;
import com.example.casestady.util.CartUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
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
                    productList = productDAO.getProductsByCategoryId(categoryId); // Thử lấy sản phẩm theo category trước
                    Category currentCategory = categoryDAO.getCategoryById(categoryId);

                    if (currentCategory != null) {
                        // Tìm thấy category
                        pageTitle = "Sản phẩm trong danh mục: " + currentCategory.getName();
                        request.setAttribute("currentCategoryName", currentCategory.getName());
                        if (productList.isEmpty()) {
                            // Category tồn tại nhưng không có sản phẩm nào
                            request.setAttribute("infoMessage", "Hiện không có sản phẩm nào trong danh mục '" + currentCategory.getName() + "'.");
                        }
                    } else {
                        // Không tìm thấy category với ID này
                        pageTitle = "Tất cả sản phẩm"; // Đặt tiêu đề chung
                        request.setAttribute("errorMessage", "Không tìm thấy danh mục với ID " + categoryId + ". Hiển thị tất cả sản phẩm.");
                        productList = productDAO.getAllProducts(); // Hiển thị tất cả sản phẩm
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid categoryId format: " + categoryIdStr, e);
                    pageTitle = "Tất cả sản phẩm";
                    request.setAttribute("errorMessage", "Định dạng ID danh mục không hợp lệ. Hiển thị tất cả sản phẩm.");
                    productList = productDAO.getAllProducts(); // Dự phòng
                }
            } else {
                // Không có categoryId, hiển thị tất cả sản phẩm
                pageTitle = "Tất cả sản phẩm";
                productList = productDAO.getAllProducts();
            }

            request.setAttribute("productList", productList);
            request.setAttribute("pageTitle", pageTitle);

            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            CartUtil.getTotalItemsInCart(request);
            request.getRequestDispatcher("/productList.jsp").forward(request, response);


        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading product list", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred while loading products.");
        }
    }
}