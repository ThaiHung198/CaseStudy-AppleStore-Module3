package com.example.casestady.dao;

import com.example.casestady.model.CustomerRequest;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CustomerRequestDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(CustomerRequestDAO.class.getName());

    public CustomerRequestDAO() {
        super();
    }

    private CustomerRequest mapResultSetToCustomerRequest(ResultSet rs) throws SQLException {
        CustomerRequest request = new CustomerRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setCustomerName(rs.getString("customer_name"));
        request.setCustomerEmail(rs.getString("customer_email"));
        request.setCustomerPhone(rs.getString("customer_phone"));
        request.setMessage(rs.getString("message"));
        request.setStatus(rs.getString("status"));
        request.setReceivedAt(rs.getTimestamp("received_at")); // Đọc java.sql.Timestamp
        return request;
    }

    public int addCustomerRequest(CustomerRequest request) {
        String sql;
        boolean hasStatus = request.getStatus() != null && !request.getStatus().isEmpty();
        if (hasStatus) {
            sql = "INSERT INTO customerrequests   (customer_name, customer_email, customer_phone, message, status) VALUES (?, ?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO customerrequests  (customer_name, customer_email, customer_phone, message) VALUES (?, ?, ?, ?)";
        }
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is not initialized or closed.");
                return -1;
            }
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, request.getCustomerName());
            ps.setString(2, request.getCustomerEmail());
            ps.setString(3, request.getCustomerPhone());
            ps.setString(4, request.getMessage());
            if (hasStatus) {
                ps.setString(5, request.getStatus());
            }
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Error when adding customer request", ex);
        }
        return -1;
    }

    public List<CustomerRequest> getAllCustomerRequests() {
        List<CustomerRequest> requests = new ArrayList<>();
        // Mới nhất lên đầu
        String sql = "SELECT * FROM customerrequests ORDER BY received_at DESC";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return requests;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(mapResultSetToCustomerRequest(rs));

            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy tất cả yêu cầu của khách hàng", ex);
        }
        return requests;
    }

    public CustomerRequest getCustomerRequestById(int requestId) {
        String sql = "SELECT * FROM customerrequests WHERE request_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCustomerRequest(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy yêu cầu của khách hàng theo ID", ex);
        }
        return null;
    }

    public boolean updateRequestStatus(int requestId, String newStatus) {
        String sql = "UPDATE customerrequests SET status = ? WHERE request_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi cập nhật trạng thái yêu cầu của khách hàng", ex);
        }
        return false;
    }

    public boolean deleteCustomerRequest(int requestId) {
        String sql = "DELETE FROM customerrequests  WHERE request_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "DaKết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1,requestId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }catch (SQLException ex){
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi xóa yêu cầu của khách hàng", ex);
        }
        return false;
    }

    public static void main(String[] args) {
        CustomerRequestDAO dao = new CustomerRequestDAO();
        System.out.println("---Tesst add Customer Request(Status sẽ do CSDL đặt mặc định)---");
        CustomerRequest newRequest1 = new CustomerRequest();
        newRequest1.setCustomerName("Nguyễn Thái Hưng");
        newRequest1.setCustomerEmail("hung@Gmail.com");
        newRequest1.setCustomerPhone("0989-999-999");
        newRequest1.setMessage("Yêu cầu ship hỏa tốc");
        int newRequestId1 = dao.addCustomerRequest(newRequest1);
        if (newRequestId1 != -1) {
            System.out.println("New request 1 added with ID: " + newRequestId1);
            CustomerRequest r1 = dao.getCustomerRequestById(newRequestId1);
            if (r1 != null)
                System.out.println("Request 1 Status: " + r1.getStatus() + ",Received at: " + r1.getReceivedAt());
        } else {
            System.out.println("Không thể thêm yêu cầu mới");
        }
        System.out.println("\n--- Test Add Customer Request (Với Status cụ thể)---");
        CustomerRequest newRequest2 = new CustomerRequest();
        newRequest2.setCustomerName("Ngô Gia Khánh");
        newRequest2.setCustomerEmail("khanh@gmail.com");
        newRequest2.setMessage("Có hàng 2T full option");
        newRequest2.setStatus("Hỏa tốc");

        int newRequestId2 = dao.addCustomerRequest(newRequest2);
        if (newRequestId2 != -1) {
            System.out.println("Yêu cầu mới 2 được thêm vào với ID: " + newRequestId2);
            CustomerRequest r2 = dao.getCustomerRequestById(newRequestId2);
            if (r2 != null)
                System.out.println("Yêu cầu 2 trạng thái: " + r2.getStatus() + ",Đã nhận được vào lúc: " + r2.getReceivedAt());
            System.out.println("\n--- Test Update Request Status for Request 2 ---");
            boolean updated = dao.updateRequestStatus(newRequestId2, "Replied");
            if (updated) {
                System.out.println("Trạng thái yêu cầu 2 đã được cập nhật thành công.");
                CustomerRequest updatedRequestCheck = dao.getCustomerRequestById(newRequestId2);
                if (updatedRequestCheck != null)
                    System.out.println("Trạng thái mới cho Yêu cầu 2:" + updatedRequestCheck.getStatus());
            } else {
                System.out.println("Không cập nhật được trạng thái yêu cầu 2.");
            }
        } else {
            System.out.println("Không thể thêm yêu cầu mới 2.");
        }
        System.out.println("\n--- Test Get All Customer Requests ---");
        List<CustomerRequest> allRequests = dao.getAllCustomerRequests();
        if (allRequests.isEmpty()) {
            System.out.println("Không tìm thấy yêu cầu của khách hàng.");
        } else {
            System.out.println("Tổng số yêu cầu: " + allRequests.size());
            for (CustomerRequest req : allRequests) {
                System.out.println(req.toString()); // Sử dụng toString() để in đầy đủ
            }
        }

        // Dọn dẹp các request đã tạo để test
        if (newRequestId1 != -1) {
            System.out.println("\n--- Đang xóa yêu cầu kiểm tra 1 (ID: " + newRequestId1 + ") ---");
            dao.deleteCustomerRequest(newRequestId1);
        }
        if (newRequestId2 != -1) {
            System.out.println("--- Đang xóa yêu cầu kiểm tra 2 (ID: " + newRequestId2 + ") ---");
            dao.deleteCustomerRequest(newRequestId2);
        }

    }
}
