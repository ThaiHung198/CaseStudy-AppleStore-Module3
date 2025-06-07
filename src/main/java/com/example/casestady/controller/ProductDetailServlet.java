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

@WebServlet(name = "ProductDetailServlet", urlPatterns = "/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProductDetailServlet.class.getName());
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO; // Cần để lấy danh sách category cho menu

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
            String productIdStr = request.getParameter("id");
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm bị thiếu.");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
                return;
            }

            request.setAttribute("product", product);

            // Lấy tên category của sản phẩm này (tùy chọn, nhưng hữu ích)
            Category productCategory = categoryDAO.getCategoryById(product.getCategoryId());
            request.setAttribute("productCategory", productCategory);


            // Lấy tất cả danh mục để hiển thị menu (giống như HomeServlet và ProductListServlet)
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);
            CartUtil.getTotalItemsInCart(request);
            request.getRequestDispatcher("/productDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Định dạng ID sản phẩm không hợp lệ", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng ID sản phẩm không hợp lệ.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi tải chi tiết sản phẩm", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
        }
    }
}