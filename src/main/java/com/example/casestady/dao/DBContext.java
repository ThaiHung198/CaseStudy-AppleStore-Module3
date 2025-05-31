package com.example.casestady.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
protected Connection connection;

    public DBContext() {
        try{
            String url = "jdbc:mysql://localhost:3306/CaseStady_AppleStore";
            String username = "root";
            String password = "Ha020598";
            // nạp driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            //Tạo kết nối
            connection = DriverManager.getConnection(url, username, password);
        }catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    // (Tùy chọn) Thêm một phương thức để lấy kết nối nếu cần
    public Connection getConnection(){
        return connection;
    }
}
