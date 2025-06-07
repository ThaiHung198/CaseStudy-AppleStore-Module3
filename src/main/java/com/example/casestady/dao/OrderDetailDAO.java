package com.example.casestady.dao;

import com.example.casestady.model.OrderDetail;
import com.example.casestady.model.Product;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDetailDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(OrderDetailDAO.class.getName());
    private ProductDAO productDAO; // Để lấy thông tin sản phẩm (tên, ảnh)

    public OrderDetailDAO() {
        super();
        productDAO = new ProductDAO(); // Khởi tạo ProductDAO
    }


    private OrderDetail mapResultSetToOrderDetail(ResultSet rs) throws SQLException {
        OrderDetail detail = new OrderDetail();
        detail.setOrderDetailId(rs.getInt("order_detail_id"));
        detail.setOrderId(rs.getInt("order_id"));
        detail.setProductId(rs.getInt("product_id"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));

        Product product = productDAO.getProductById(detail.getProductId());
        if (product != null) {
            detail.setProductName(product.getName());
            detail.setProductImageUrl(product.getImageUrl());
        }
        return detail;
    }


    /**
     * Thêm một chi tiết đơn hàng vào CSDL.
     * @param orderDetail Đối tượng OrderDetail chứa thông tin (orderId, productId, quantity, priceAtPurchase).
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql); // Không cần RETURN_GENERATED_KEYS nếu không lấy lại order_detail_id ngay
            ps.setInt(1, orderDetail.getOrderId());
            ps.setInt(2, orderDetail.getProductId());
            ps.setInt(3, orderDetail.getQuantity());
            ps.setBigDecimal(4, orderDetail.getPriceAtPurchase());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi thêm chi tiết đơn hàng", ex);
        }
        return false;
    }

    /**
     * Lấy tất cả các chi tiết của một đơn hàng cụ thể.
     * @param orderId ID của đơn hàng.
     * @return Danh sách các đối tượng OrderDetail.
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE order_id = ?";

        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return details;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                details.add(mapResultSetToOrderDetail(rs)); // mapResultSetToOrderDetail sẽ xử lý việc lấy thêm thông tin Product
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi lấy thông tin chi tiết đơn hàng cho ID đơn hàng: " + orderId, ex);
        }
        return details;
    }

}