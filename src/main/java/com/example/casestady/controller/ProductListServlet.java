package com.example.casestady.controller;

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.dao.ProductDAO;
import com.example.casestady.model.Category;
import com.example.casestady.model.Product;
import com.example.casestady.util.CartUtil; // Import CartUtil

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ProductListServlet", urlPatterns = "/products")
public class ProductListServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProductListServlet.class.getName());
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
        try {
            request.setCharacterEncoding("UTF-8");

            String categoryIdStr = request.getParameter("categoryId");
            String searchKeyword = request.getParameter("searchKeyword");
            String priceRangeStr = request.getParameter("priceRange");

            // KHAI BÁO CÁC BIẾN Ở ĐÂY
            List<Product> productList; // Khai báo productList
            String pageTitle = "";      // Khai báo pageTitle
            String currentCategoryName = null; // Khai báo currentCategoryName

            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid categoryId format: " + categoryIdStr, e);
                    // Không set categoryId nếu không parse được
                }
            }

            BigDecimal minPrice = null;
            BigDecimal maxPrice = null;

            if (priceRangeStr != null && !priceRangeStr.isEmpty()) {
                request.setAttribute("selectedPriceRange", priceRangeStr);
                String[] prices = priceRangeStr.split("-");
                try {
                    if (prices.length > 0 && !prices[0].isEmpty()) {
                        minPrice = new BigDecimal(prices[0]);
                    }
                    if (prices.length > 1 && !prices[1].isEmpty()) {
                        maxPrice = new BigDecimal(prices[1]);
                    } else if (prices.length == 1 && priceRangeStr.endsWith("-")) {
                        // minPrice đã được set, maxPrice là null
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid price range format: " + priceRangeStr);
                    // Giữ minPrice, maxPrice là null nếu format sai
                }
            }

            // Gọi hàm DAO để lấy sản phẩm dựa trên các filter
            productList = productDAO.searchAndFilterProducts(searchKeyword, minPrice, maxPrice, categoryId);

            // Xử lý pageTitle dựa trên các filter đã áp dụng
            StringBuilder titleBuilder = new StringBuilder();
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                titleBuilder.append("Kết quả cho '").append(searchKeyword.trim()).append("'");
                request.setAttribute("searchKeyword", searchKeyword.trim());
            }

            if (categoryId != null) {
                Category fetchedCategory = categoryDAO.getCategoryById(categoryId); // Đổi tên biến để tránh nhầm lẫn
                if (fetchedCategory != null) {
                    titleBuilder.append(titleBuilder.length() > 0 ? " trong " : "Sản phẩm trong ");
                    titleBuilder.append(fetchedCategory.getName());
                    currentCategoryName = fetchedCategory.getName(); // Gán giá trị cho currentCategoryName
                } else if (searchKeyword == null || searchKeyword.trim().isEmpty()) {
                    // Chỉ báo lỗi category không tìm thấy nếu không phải là đang tìm kiếm
                    request.setAttribute("errorMessage", "Không tìm thấy danh mục với ID " + categoryId + ".");
                }
            }

            if (priceRangeStr != null && !priceRangeStr.isEmpty()) {
                titleBuilder.append(titleBuilder.length() > 0 ? " | Giá: " : "Lọc giá: ");
                // Tạo text cho khoảng giá
                String priceRangeText = priceRangeStr.replace("-", " đến ");
                if(priceRangeStr.endsWith("-") && minPrice != null){
                    priceRangeText = "từ " + minPrice.toPlainString();
                } else if (minPrice != null && maxPrice == null && !priceRangeStr.endsWith("-")){
                    priceRangeText = "dưới " + minPrice.toPlainString(); // Logic này có thể cần xem lại tùy theo option bạn định nghĩa
                } else if (minPrice == null && maxPrice != null){
                    priceRangeText = "dưới " + maxPrice.toPlainString();
                }
                titleBuilder.append(priceRangeText);
            }

            if (titleBuilder.length() == 0) {
                pageTitle = "Tất cả sản phẩm";
            } else {
                pageTitle = titleBuilder.toString();
            }

            if (productList.isEmpty()) {
                // Chỉ hiển thị thông báo này nếu không có errorMessage (ví dụ categoryId không hợp lệ)
                if (request.getAttribute("errorMessage") == null) {
                    request.setAttribute("infoMessage", "Không tìm thấy sản phẩm nào phù hợp với tiêu chí của bạn.");
                }
            }

            request.setAttribute("productList", productList);
            request.setAttribute("pageTitle", pageTitle);
            if (currentCategoryName != null) {
                request.setAttribute("currentCategoryName", currentCategoryName);
            }

            // Lấy tất cả danh mục để hiển thị menu
            List<Category> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            // Tính và đặt totalCartItems cho header
            CartUtil.getTotalItemsInCart(request);

            request.getRequestDispatcher("/productList.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading product list or search results", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra khi tải danh sách sản phẩm.");
        }
    }
    // doPost có thể được bỏ trống hoặc gọi doGet nếu bạn muốn xử lý POST giống GET
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Hoặc xử lý cụ thể nếu form tìm kiếm dùng POST
    }
}