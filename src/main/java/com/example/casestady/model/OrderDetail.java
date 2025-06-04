package com.example.casestady.model; // Đảm bảo package đúng

import java.math.BigDecimal;

public class OrderDetail {
    private int orderDetailId;
    private int orderId;        // ID của đơn hàng chứa chi tiết này
    private int productId;      // ID của sản phẩm
    private int quantity;
    private BigDecimal priceAtPurchase; // Giá tại thời điểm mua

    // (Tùy chọn) Bạn có thể thêm các thuộc tính từ Product để hiển thị dễ dàng hơn
    // mà không cần join hoặc query lại, ví dụ: productName, productImageUrl
    // Tuy nhiên, điều này làm dư thừa dữ liệu nếu chỉ dùng để hiển thị.
    // Cách tốt hơn là có một lớp DTO (Data Transfer Object) riêng nếu cần.
    private String productName; // Ví dụ, lấy từ bảng Products khi load OrderDetail
    private String productImageUrl; // Ví dụ

    // Constructors
    public OrderDetail() {
    }

    // Getters and Setters
    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPriceAtPurchase() {
        return priceAtPurchase;
    }

    public void setPriceAtPurchase(BigDecimal priceAtPurchase) {
        this.priceAtPurchase = priceAtPurchase;
    }

    // Getters and Setters cho các thuộc tính tùy chọn (nếu bạn thêm)
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImageUrl() {
        return productImageUrl;
    }

    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }

    @Override
    public String toString() {
        return "OrderDetail{" +
                "orderDetailId=" + orderDetailId +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", priceAtPurchase=" + priceAtPurchase +
                (productName != null ? ", productName='" + productName + '\'' : "") +
                '}';
    }
}