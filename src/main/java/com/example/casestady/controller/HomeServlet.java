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

// Có thể map với "/" để làm trang chủ mặc định, hoặc "/home"
// Nếu map với "/", cần cấu hình welcome-file trong web.xml là một file không tồn tại
// hoặc một servlet khác để tránh lỗi khi truy cập context root.
// Để đơn giản, chúng ta dùng "/home" trước.
@WebServlet(name = "HomeServlet", urlPatterns = "/home")
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy danh sách sản phẩm nổi bật
            List<Product> featuredProducts = productDAO.getFeaturedProducts();
            request.setAttribute("featuredProducts", featuredProducts);

            // Lấy danh sách tất cả các danh mục để hiển thị menu
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            // (Tùy chọn) Lấy một vài sản phẩm mới nhất hoặc tất cả sản phẩm (có thể cần phân trang sau)
            // Ví dụ: Lấy 8 sản phẩm mới nhất (giả sử ProductDAO có hàm getNewestProducts(limit))
//             List<Product> newestProducts = productDAO.getNewestProducts(8);
//             request.setAttribute("newestProducts", newestProducts);
            // Hoặc lấy tất cả (cẩn thận nếu số lượng lớn)
             List<Product> allProducts = productDAO.getAllProducts();
             request.setAttribute("allProducts", allProducts);


            // Forward đến trang home.jsp (giả sử nằm ở webapp/home.jsp)
            request.getRequestDispatcher("admin/home.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading data for home page", e);
            // Có thể chuyển hướng đến một trang lỗi chung
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred. Please try again later.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Trang chủ thường không xử lý POST, có thể redirect về GET hoặc báo lỗi
        doGet(request, response);
    }
}