package com.example.casestady.dao;

import com.example.casestady.model.Admin;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminDAO extends DBContext {

    public AdminDAO() {
        super();
    }

    public Admin getAdminByUsernameAndPassword(String username, String password) {
        String sql = "SELECT admin_id, username, email, created_at FROM Admins WHERE username = ? AND password = ?";
        try {
            // Đảm bảo connection đã được khởi tạo trong DBContext
            if (connection == null) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo!");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUserName(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                return admin;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi lấy admin", ex);
        }
        return null;
    }

    public static void main(String[] args) {
        AdminDAO dao = new AdminDAO();
        // Giả sử bạn đã chèn một admin có username 'admin' và password 'admin123' vào DB
        Admin admin = dao.getAdminByUsernameAndPassword("admin", "admin123");
        if (admin != null) {
            System.out.println("Đăng nhập thành công: " + admin.getUserName());
        } else {
            System.out.println("Đăng nhập thất bại hoặc có lỗi xảy ra.");
        }
    }
}