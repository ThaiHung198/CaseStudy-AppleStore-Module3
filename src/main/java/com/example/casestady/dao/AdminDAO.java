package com.example.casestady.dao; // Đảm bảo package đúng

import com.example.casestady.model.Admin; // Import model Admin

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(AdminDAO.class.getName());

    public AdminDAO() {
        super();
    }

    // Helper method để map ResultSet sang đối tượng Admin
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        // Giả sử trong model Admin, tên thuộc tính là userName (N viết hoa)
        // Nếu trong model là username (n viết thường), thì dùng admin.setUserName(...)
        admin.setUserName(rs.getString("username")); // Lấy từ cột 'username' của CSDL
        admin.setPassword(rs.getString("password")); // Lấy password từ CSDL
        admin.setEmail(rs.getString("email"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        return admin;
    }

    /**
     * Lấy thông tin admin bằng username.
     * Phương thức này sẽ trả về đối tượng Admin bao gồm cả password (plain text hoặc hash)
     * để Servlet có thể thực hiện việc so sánh.
     *
     * @param username Tên đăng nhập của admin
     * @return Đối tượng Admin nếu tìm thấy, ngược lại trả về null.
     */
    public Admin getAdminByUsername(String username) { // Đổi tên phương thức để chỉ lấy theo username
        String sql = "SELECT admin_id, username, password, email, created_at FROM Admins WHERE username = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs); // Sử dụng helper method
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy admin theo tên người dùng: " + username, ex);
        }
        return null;
    }


    public static void main(String[] args) {
        AdminDAO dao = new AdminDAO();
        String testUsername = "admin";
        String testPasswordAttempt = "admin123"; // Password người dùng thử nhập

        System.out.println("--- Đang cố gắng lấy quyền quản trị theo tên người dùng: " + testUsername + " ---");
        Admin admin = dao.getAdminByUsername(testUsername); // Gọi phương thức mới

        if (admin != null) {
            System.out.println("Quản trị viên đã tìm thấy: " + admin.getUserName()); // Hoặc admin.getUserName()
            System.out.println("Mật khẩu từ DB : " + admin.getPassword());

            // So sánh password ở đây (giống như Servlet sẽ làm)
            if (admin.getPassword() != null && admin.getPassword().equals(testPasswordAttempt)) {
                System.out.println("Mật khẩu trùng khớp! Đăng nhập thành công.");
            } else {
                System.out.println("Mật khẩu KHÔNG khớp hoặc mật khẩu từ DB là null. Đăng nhập không thành công.");
            }
        } else {
            System.out.println("Quản trị viên có tên người dùng '" + testUsername + "' không tìm thấy. Đăng nhập không thành công.");
        }
    }
}