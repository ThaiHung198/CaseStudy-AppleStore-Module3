package com.example.casestady.controller;

import com.example.casestady.dao.CategoryDAO;
import com.example.casestady.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageCategoryServlet", urlPatterns = "/manageCategories")
public class ManageCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws SecurityException, ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/adminLogin.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        try {
            switch (action) {
                case "add":
                    showAddCategoryForm(request, response);
                    break;
                case "edit":
                    showEditCategoryForm(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                case "list":
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred:" + e.getMessage());
            // Quay lại danh sách với thông báo lỗi
            listCategories(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/adminLogin.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/manageCategories?action=list"); // Thêm 's'
            return;

        }
        try {
            switch (action){
                case "add":
                    addCategory(request,response);
                    break;
                case "update":
                    updateCategory(request,response);
                    break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/manageCategories?action=list");
                        break;
            }
        }catch (Exception e){
            e.printStackTrace();
            request.setAttribute("errorMessage","An error occurred:"+e.getMessage());
            // Tùy thuộc vào action mà có thể muốn forward đến form tương ứng hoặc danh sách
            listCategories(request,response);
        }
    }
    private void listCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);

        request.getRequestDispatcher("/admin/manageCategories.jsp").forward(request, response);
    }
    private void showAddCategoryForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("formAction", "add");
        request.setAttribute("pageTitle", "Add new Category");
        request.getRequestDispatcher("/admin/manageCategories.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("categoryName");
        String description = request.getParameter("categoryDescription");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Category name cannot be empty.");
            // Hiển thị lại form add với thông báo lỗi
            showAddCategoryForm(request, response);
            return;
        }

        Category newCategory = new Category();
        newCategory.setName(name.trim());
        newCategory.setDescription(description != null ? description.trim() : "");

        int categoryId = categoryDAO.addCategory(newCategory);
        if (categoryId != -1) {
            request.getSession().setAttribute("successMessage", "Category added successfully!");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to add category. It might already exist or an error occurred.");
        }
        response.sendRedirect(request.getContextPath() + "/manageCategories?action=list");
    }

    private void showEditCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manageCategories?action=list&errorMessage=Missing_category_ID_for_edit");
            return;
        }

        try {
            int categoryId = Integer.parseInt(idStr);
            Category existingCategory = categoryDAO.getCategoryById(categoryId);
            if (existingCategory != null) {
                request.setAttribute("categoryToEdit", existingCategory);
                request.setAttribute("formAction", "update"); // Để JSP biết submit form edit sẽ là action "update"
                request.setAttribute("pageTitle", "Edit Category");
                // Forward đến cùng trang JSP, nhưng JSP sẽ hiển thị form edit với dữ liệu đã có
                request.getRequestDispatcher("/admin/manageCategories.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/manageCategories?action=list&errorMessage=Category_not_found_for_ID_" + categoryId);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manageCategories?action=list&errorMessage=Invalid_category_ID_format");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("categoryId"); // Lấy từ hidden input trong form edit
        String name = request.getParameter("categoryName");
        String description = request.getParameter("categoryDescription");

        if (idStr == null || idStr.trim().isEmpty() || name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Category ID and name are required for update.");
            // Cần lấy lại thông tin category để hiển thị lại form edit với lỗi
            // Hoặc đơn giản là redirect về list
            listCategories(request,response); // Đơn giản hóa: quay về list
            // Để tốt hơn, bạn nên forward lại form edit với các giá trị cũ và thông báo lỗi
            return;
        }

        try {
            int categoryId = Integer.parseInt(idStr);
            Category categoryToUpdate = new Category();
            categoryToUpdate.setCategoryId(categoryId);
            categoryToUpdate.setName(name.trim());
            categoryToUpdate.setDescription(description != null ? description.trim() : "");

            boolean success = categoryDAO.updateCategory(categoryToUpdate);
            if (success) {
                request.getSession().setAttribute("successMessage", "Category updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update category.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Category ID for update.");
        }
        response.sendRedirect(request.getContextPath() + "/manageCategories?action=list");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manageCategories?action=list&errorMessage=Missing_category_ID_for_delete");
            return;
        }
        try {
            int categoryId = Integer.parseInt(idStr);
            boolean success = categoryDAO.deleteCategory(categoryId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Category deleted successfully!");
            } else {
                // Có thể do ràng buộc khóa ngoại (còn sản phẩm thuộc danh mục)
                request.getSession().setAttribute("errorMessage", "Failed to delete category. It might be in use or an error occurred.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Category ID format for delete.");
        }
        response.sendRedirect(request.getContextPath() + "/manageCategories?action=list");
    }
}

