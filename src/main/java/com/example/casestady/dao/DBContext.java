package com.example.casestady.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    private static final Logger LOGGER_DBCONTEXT = Logger.getLogger(DBContext.class.getName()); // Logger riêng cho DBContext
    protected Connection connection;

    public DBContext() {
        try {
            String url = "jdbc:mysql://localhost:3306/CaseStady_AppleStore";
            String username = "root";
            String password = "Ha020598"; // Đảm bảo mật khẩu này đúng

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, username, password);

            if (connection == null) {
                // Trường hợp hiếm khi getConnection trả về null mà không ném SQLException
                LOGGER_DBCONTEXT.log(Level.SEVERE, "Failed to make connection to database, connection object is null.");
                throw new RuntimeException("Failed to make connection to database, connection object is null.");
            }
            LOGGER_DBCONTEXT.log(Level.INFO, "Database connection established successfully.");

        } catch (ClassNotFoundException ex) {
            LOGGER_DBCONTEXT.log(Level.SEVERE, "MySQL JDBC Driver not found.", ex);
            throw new RuntimeException("MySQL JDBC Driver not found.", ex);
        } catch (SQLException ex) {
            LOGGER_DBCONTEXT.log(Level.SEVERE, "Failed to connect to the database.", ex);
            // In ra chi tiết lỗi SQL (SQLState, ErrorCode) để dễ debug
            LOGGER_DBCONTEXT.log(Level.SEVERE, "SQLState: " + ex.getSQLState());
            LOGGER_DBCONTEXT.log(Level.SEVERE, "Error Code: " + ex.getErrorCode());
            LOGGER_DBCONTEXT.log(Level.SEVERE, "Message: " + ex.getMessage());
            throw new RuntimeException("Failed to connect to the database.", ex);
        }
    }

    public Connection getConnection() {
        // Có thể thêm kiểm tra ở đây nếu muốn, ví dụ: connection.isClosed()
        // và thử kết nối lại nếu cần, nhưng sẽ làm phức tạp logic.
        // Hiện tại, constructor đảm nhiệm việc kết nối.
        return connection;
    }

    // (Tùy chọn) Thêm phương thức để đóng kết nối khi ứng dụng bị undeploy
    // public void closeConnection() {
    //     try {
    //         if (connection != null && !connection.isClosed()) {
    //             connection.close();
    //             LOGGER_DBCONTEXT.log(Level.INFO, "Database connection closed.");
    //         }
    //     } catch (SQLException ex) {
    //         LOGGER_DBCONTEXT.log(Level.SEVERE, "Error closing database connection.", ex);
    //     }
    // }
}