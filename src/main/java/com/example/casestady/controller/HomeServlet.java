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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

            Map<Category, List<Product>> productsByCategoryForHome = new HashMap<>();
            int productsPerCategoryLimit = 4; // Giới hạn số sản phẩm hiển thị cho mỗi category

            if (allCategories != null) {
                for (Category category : allCategories) {
                    // Lấy sản phẩm theo categoryId, bạn cần một hàm trong ProductDAO
                    // có thể nhận thêm tham số limit hoặc bạn tự giới hạn trong JSP
                    List<Product> catProducts = productDAO.getProductsByCategoryId(category.getCategoryId()); // Sửa category.getId() thành category.getCategoryId()

                    // Nếu muốn giới hạn ở đây thay vì JSP:
                    List<Product> limitedCatProducts = new ArrayList<>();
                    if (catProducts != null) {
                        for (int i = 0; i < catProducts.size() && i < productsPerCategoryLimit; i++) {
                            limitedCatProducts.add(catProducts.get(i));
                        }
                    }
                    productsByCategoryForHome.put(category, limitedCatProducts);
                }
            }
            request.setAttribute("productsByCategoryForHome", productsByCategoryForHome);

            request.setAttribute("productsByCategoryForHome", productsByCategoryForHome);

            // Hoặc lấy tất cả (cẩn thận nếu số lượng lớn)
                    List<Product> allProducts = productDAO.getAllProducts();
                    request.setAttribute("allProducts", allProducts);

                    CartUtil.getTotalItemsInCart(request);
                    request.getRequestDispatcher("admin/home.jsp").forward(request, response);

                } catch(Exception e){
                    LOGGER.log(Level.SEVERE, "Error loading data for home page", e);
                    // Có thể chuyển hướng đến một trang lỗi chung
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred. Please try again later.");
                }
            }

            @Override
            protected void doPost (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                request.setCharacterEncoding("UTF-8");
                response.setContentType("text/html; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");

                // Trang chủ thường không xử lý POST, có thể redirect về GET hoặc báo lỗi
                doGet(request, response);
            }
        }