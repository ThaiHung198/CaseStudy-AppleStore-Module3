package com.example.casestady.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AdminOrderItemView {
    private int orderId;
    private Timestamp orderDate;
    private String productName;
    private int quantity;
    private BigDecimal priceAtPurchase;
    // Bạn có thể thêm các trường khác từ Order nếu muốn, ví dụ: customerName, status của Order
    // private String customerName;
    // private String orderStatus;

    public AdminOrderItemView() {
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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
}