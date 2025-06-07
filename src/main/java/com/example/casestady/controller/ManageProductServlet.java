package com.example.casestady.controller;

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.dao.ProductDAO;
import com.example.casestady.model.Category;
import com.example.casestady.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ManageProductServlet", urlPatterns = "/admin/manageProducts")
public class ManageProductServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManageProductServlet.class.getName());
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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        try {
            switch (action) {
                case "add":
                    showAddProductForm(request, response);
                    break;
                case "edit":
                    showEditProductForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "list":
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ManageProductServlet doGet", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            listProducts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ManageProductServlet doPost", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            listProducts(request, response); // Or forward to the specific form with error
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> productList = productDAO.getAllProducts();
        // Để hiển thị tên Category, bạn có thể cần sửa ProductDAO.getAllProducts() để join bảng
        // Hoặc lặp qua productList và gọi categoryDAO.getCategoryById(product.getCategoryId()) cho mỗi product
        // Cách đơn giản hơn là truyền cả list categories vào JSP và dùng JSTL để tìm tên category
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("productList", productList);
        request.setAttribute("categoryListAll", categoryList); // Để hiển thị tên category trong bảng
        request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
    }

    private void loadCategoriesForForm(HttpServletRequest request) {
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryListForForm", categoryList);
    }

    private void showAddProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCategoriesForForm(request);
        request.setAttribute("formAction", "Thêm");
        request.setAttribute("pageTitle", "Thêm sản phẩm mới");
        request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("productName");
        String description = request.getParameter("productDescription");
        String priceStr = request.getParameter("productPrice");
        String categoryIdStr = request.getParameter("categoryId");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        boolean isFeatured = "on".equalsIgnoreCase(request.getParameter("isFeatured")); // Checkbox

        // Basic Validation
        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty() || stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Cần phải có Tên, Giá, Danh mục và Số lượng hàng tồn kho.");
            loadCategoriesForForm(request); // Load categories again for the form
            request.setAttribute("formAction", "Thêm"); // Keep the form in add mode
            request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
            return;
        }

        try {
            BigDecimal price = new BigDecimal(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);

            Product newProduct = new Product();
            newProduct.setName(name.trim());
            newProduct.setDescription(description != null ? description.trim() : "");
            newProduct.setPrice(price);
            newProduct.setCategoryId(categoryId);
            newProduct.setStockQuantity(stockQuantity);
            newProduct.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            newProduct.setisFeatured(isFeatured); // Đảm bảo model Product có setIsFeatured

            int productId = productDAO.addProduct(newProduct);
            if (productId != -1) {
                request.getSession().setAttribute("successMessage", "Sản phẩm được thêm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thêm được sản phẩm. Vui lòng kiểm tra dữ liệu hoặc nhật ký.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng số không hợp lệ cho Giá, ID danh mục hoặc Số lượng hàng tồn kho.");
            loadCategoriesForForm(request);
            request.setAttribute("formAction", "Thêm");
            request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list");
    }

    private void showEditProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list&errorMessage=Missing_product_ID_for_edit");
            return;
        }
        try {
            int productId = Integer.parseInt(idStr);
            Product existingProduct = productDAO.getProductById(productId);
            if (existingProduct != null) {
                loadCategoriesForForm(request);
                request.setAttribute("productToEdit", existingProduct);
                request.setAttribute("formAction", "Cập nhật");
                request.setAttribute("pageTitle", "Sửa sản phẩm");
                request.getRequestDispatcher("/admin/manageProducts.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list&errorMessage=Product_not_found_for_ID_" + productId);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list&errorMessage=Invalid_product_ID_format");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("productId");
        String name = request.getParameter("productName");
        String description = request.getParameter("productDescription");
        String priceStr = request.getParameter("productPrice");
        String categoryIdStr = request.getParameter("categoryId");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        boolean isFeatured = "on".equalsIgnoreCase(request.getParameter("isFeatured"));

        if (idStr == null || idStr.trim().isEmpty() || name == null || name.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() || categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
                stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Mã sản phẩm, Tên, Giá, Danh mục và Số lượng hàng tồn kho là bắt buộc để cập nhật.");
            // Để tốt hơn, bạn nên load lại productToEdit và categories rồi forward lại form edit
            // Tạm thời redirect về list để đơn giản
            response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=edit&id="+idStr+"&validationError=true");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);
            BigDecimal price = new BigDecimal(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);

            Product productToUpdate = new Product();
            productToUpdate.setProductId(productId);
            productToUpdate.setName(name.trim());
            productToUpdate.setDescription(description != null ? description.trim() : "");
            productToUpdate.setPrice(price);
            productToUpdate.setCategoryId(categoryId);
            productToUpdate.setStockQuantity(stockQuantity);
            productToUpdate.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            productToUpdate.setisFeatured(isFeatured);

            boolean success = productDAO.updateProduct(productToUpdate);
            if (success) {
                request.getSession().setAttribute("successMessage", "Sản phẩm được cập nhật thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật sản phẩm.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Định dạng số để cập nhật không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list&errorMessage=Missing_product_ID_for_delete");
            return;
        }
        try {
            int productId = Integer.parseInt(idStr);
            boolean success = productDAO.deleteProduct(productId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Sản phẩm đã được xóa thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không xóa được sản phẩm. Có thể sản phẩm được tham chiếu ở nơi khác hoặc đã xảy ra lỗi.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Định dạng ID sản phẩm không hợp lệ để xóa.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manageProducts?action=list");
    }
}