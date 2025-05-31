package com.example.casestady.dao;

import com.example.casestady.model.Category;

import java.beans.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CategoryDAO  extends DBContext{
    public CategoryDAO() {
        super();
    }
    // Lấy tất cả danh mục
    public List<Category> getAllCategories(){
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id,name,description,created_at,updated_at FROM Categories ORDER BY name ASC";
        try {
            if (connection == null || connection.isClosed()){
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return categories; //Trả về danh sách rỗng
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setUpdatedAt(rs.getTimestamp("updated_at"));
                categories.add(category);
            }
        }catch (SQLException ex){
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE,"Lỗi SQL khi lấy tất cả danh mục",ex);
        }
        return categories;
    }
    public Category getCategoryById(int categoryId){
        String sql ="SELECT category_id,name,description,created_at,updated_at FROM Categories WHERE category_id = ?";
        try{
            if (connection == null || connection.isClosed()){
                System.err.println("Lỗi: Kết nối CSDL chưa  chưa được khởi tạo hoặc đã đóng!");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1,categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()){
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setUpdatedAt(rs.getTimestamp("updated_at"));
                return category;
            }
        }catch (SQLException ex){
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE,"Lỗi SQL khi lấy danh mục theo ID", ex);
        }
        return null;
    }
    // Thêm một danh mục mới
    // Trả về ID của danh mục mới được tạo, hoặc -1 nếu thất bại
    public int addCategory(Category category){
        String sql = "INSERT INTO Categories (name,description) VALUES (?,?)";
        try {
            if (connection == null || connection.isClosed()){
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return -1;
            }
            // Sử dụng Statement.RETURN_GENERATED_KEYS để lấy ID tự tăng
            PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);            ps.setString(1,category.getName());
            ps.setString(2,category.getDescription());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0){
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Trả về ID được tạo
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE,"Lỗi SQL khi thêm danh mục mới",ex);
        }
        return -1;// thêm thất bại
    }
    public boolean updateCategory(Category category){
        String sql = "UPDATE Categories SET name = ?,description = ? WHERE category_id = ?";
        try {
            if (connection == null || connection.isClosed()){
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setInt(3,category.getCategoryId());

            int affectedRows = ps.executeUpdate();
            return affectedRows >0;
        }catch (SQLException ex){
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi cập nhật danh mục", ex);
        }
        return false;
    }
    public boolean deleteCategory(int categoryId){
        String sql = "DELETE FROM Categories WHERE category_id = ? ";
        try {
            if (connection == null || connection.isClosed()){
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1,categoryId);
            int affectedRows = ps.executeUpdate();
            return affectedRows >0;
        } catch (SQLException ex){
            // Cần xử lý trường hợp không xóa được do ràng buộc khóa ngoại (ví dụ: còn sản phẩm thuộc danh mục này)
            // Lỗi SQLIntegrityConstraintViolationException
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi xóa danh mục. Có thể do ràng buộc khóa ngoại.", ex);
        }
        return false;
    }

    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();

        // 1. Test getAllCategories
        System.out.println("---Danh sách tất cả danh mục---");
        List<Category> categories = dao.getAllCategories();
        if (categories.isEmpty()){
            System.out.println("Không có danh mục nào");
        }else {
            for (Category cat : categories) {
                System.out.println("ID: "+ cat.getCategoryId() + " | Tên: " + cat.getName() + ", Mô tả : " + cat.getDescription());
            }
        }
        System.out.println("\n---Test Thêm Danh Mục Mới---");
        Category newCat = new Category();
        newCat.setName("Danh mục test" + System.currentTimeMillis()); // Tên duy nhất để test
        newCat.setDescription("Mô tả cho danh mục test.");
        int newCatId = dao.addCategory(newCat);
        if (newCatId != -1){
            System.out.println("Đã thêm danh mục mới với ID:" + newCatId + "và tên: " + newCat.getName());
            // 2. Test getCategoryById
            System.out.println("\n--- Test lấy danh mục vừa thêm---");
            Category fetchedCat = dao.getCategoryById(newCatId);
            if(fetchedCat !=null){
                System.out.println("Lấy được danh mục: " + fetchedCat.getName());
            }else {
                System.out.println("Không tìm thấy danh mục với ID: " + newCatId);
            }
            // 3. Test updateCategory
            System.out.println("\n--- Test Cập Nhật Danh Mục---");
            fetchedCat.setName(fetchedCat.getName() + "(Đã cập nhật)");
            fetchedCat.setDescription("Mô tả đã được cập nhật.");
            boolean updated = dao.updateCategory(fetchedCat);
            if (updated){
                System.out.println("Cập nhật danh mục ID " + fetchedCat.getCategoryId() +"Thành Công." );
                Category updatedCatCheck = dao.getCategoryById(fetchedCat.getCategoryId());
                System.out.println("Tên mới: "+" "+updatedCatCheck.getName());
            }else {
                System.out.println("Cập nhật danh mục thất bại.");
            }
            // 4. Test deleteCategory
            System.out.println("\n---Test Xóa Danh Mục---");
            boolean deleted = dao.deleteCategory(newCatId);
            if (deleted){
                System.out.println("Đã xóa danh mục với ID: " + newCatId );
                Category deletedCatCheck = dao.getCategoryById(newCatId);
                if (deletedCatCheck == null){
                    System.out.println("Xác nhận: Danh mục không còn tồn tại.");
                }else {
                    System.out.println("Lỗi: Danh mục vẫn còn tồn tại sau khi xóa.");
                }
            }else {
                System.out.println("Xóa danh mục thất bại (Có thể do rằng buộc khóa ngoại hoặc lỗi khác).");
            }
        }else {
            System.out.println("Thêm danh mục mới thất bại.");
        }
        System.out.println("\n--- Test lấy lại tất cả danh mục sau khi thao tác---");
        categories = dao.getAllCategories();
        if (categories.isEmpty()){
            System.out.println("Không có danh mục nào.");
        }else {
            for (Category cat : categories){
                System.out.println("ID: "+ cat.getCategoryId() + ",Tên: " + cat.getName() + ",Mô tả: " + cat.getDescription());
            }
        }
    }
}
