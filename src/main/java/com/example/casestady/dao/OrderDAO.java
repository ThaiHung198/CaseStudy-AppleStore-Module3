package com.example.casestady.dao;

import com.example.casestady.model.Order;
import com.example.casestady.model.OrderDetail;
import com.example.casestady.model.AdminOrderItemView;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    private OrderDetailDAO orderDetailDAO; // Để load chi tiết đơn hàng

    public OrderDAO() {
        super();
        orderDetailDAO = new OrderDetailDAO(); // Khởi tạo OrderDetailDAO
    }

    // Helper method to map ResultSet to Order object
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setCustomerName(rs.getString("customer_name"));
        order.setCustomerEmail(rs.getString("customer_email"));
        order.setCustomerPhone(rs.getString("customer_phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setNotes(rs.getString("notes"));
        // userId sẽ được thêm sau nếu có
        return order;
    }

    /**
     * Thêm một đơn hàng mới vào CSDL và trả về ID của đơn hàng đó.
     *
     * @param order Đối tượng Order chứa thông tin đơn hàng (ngoại trừ orderId và orderDate)
     * @return order_id của đơn hàng mới được tạo, hoặc -1 nếu thất bại.
     */
    public int addOrder(Order order) {
        // order_date và status sẽ có giá trị DEFAULT từ CSDL
        String sql = "INSERT INTO Orders (customer_name, customer_email, customer_phone, shipping_address, total_amount, notes, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        if (order.getStatus() == null || order.getStatus().isEmpty()) {
            // Nếu không cung cấp status, CSDL sẽ dùng default 'Pending'
            sql = "INSERT INTO Orders (customer_name, customer_email, customer_phone, shipping_address, total_amount, notes) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        }

        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return -1;
            }
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, order.getCustomerName());
            ps.setString(2, order.getCustomerEmail());
            ps.setString(3, order.getCustomerPhone());
            ps.setString(4, order.getShippingAddress());
            ps.setBigDecimal(5, order.getTotalAmount());
            ps.setString(6, order.getNotes());
            if (order.getStatus() != null && !order.getStatus().isEmpty()) {
                ps.setString(7, order.getStatus());
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Trả về order_id được tạo
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi thêm đơn hàng", ex);
        }
        return -1; // Thêm thất bại
    }

    /**
     * Lấy tất cả đơn hàng, sắp xếp theo ngày đặt hàng mới nhất trước.
     *
     * @return Danh sách các đối tượng Order.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY order_date DESC";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return orders;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Tải các chi tiết đơn hàng cho mỗi đơn hàng
                List<OrderDetail> details = orderDetailDAO.getOrderDetailsByOrderId(order.getOrderId());
                order.setOrderDetails(details);
                orders.add(order);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy tất cả các đơn hàng", ex);
        }
        return orders;
    }

    /**
     * Lấy một đơn hàng cụ thể bằng order_id.
     *
     * @param orderId ID của đơn hàng.
     * @return Đối tượng Order nếu tìm thấy, bao gồm cả chi tiết đơn hàng, ngược lại null.
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE order_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                List<OrderDetail> details = orderDetailDAO.getOrderDetailsByOrderId(order.getOrderId());
                order.setOrderDetails(details);
                return order;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy thứ tự theo ID: " + orderId, ex);
        }
        return null;
    }

    /**
     * Cập nhật trạng thái của một đơn hàng.
     *
     * @param orderId   ID của đơn hàng cần cập nhật.
     * @param newStatus Trạng thái mới.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        // CSDL sẽ tự động cập nhật updated_at nếu bảng Orders có cột đó với ON UPDATE CURRENT_TIMESTAMP
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi cập nhật trạng thái đơn hàng cho ID đơn hàng: " + orderId, ex);
        }
        return false;
    }

    public List<AdminOrderItemView> getAllOrderItemsForAdminView() {
        List<AdminOrderItemView> orderItems = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_date, p.name AS product_name, od.quantity, od.price_at_purchase " +
                "FROM Orders o " +
                "JOIN OrderDetails od ON o.order_id = od.order_id " +
                "JOIN Products p ON od.product_id = p.product_id " +
                "ORDER BY o.order_date DESC, o.order_id DESC, p.name ASC";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return orderItems;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminOrderItemView item = new AdminOrderItemView();
                item.setOrderId(rs.getInt("order_id"));
                item.setOrderDate(rs.getTimestamp("order_date"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
                // Set các trường tùy chọn khác nếu bạn thêm vào AdminOrderItemView và câu SQL
                orderItems.add(item);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy tất cả các mục đơn hàng cho chế độ xem quản trị", ex);
        }
        return orderItems;
    }
}