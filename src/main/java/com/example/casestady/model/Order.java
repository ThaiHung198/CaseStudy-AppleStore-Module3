package com.example.casestady.model; // Đảm bảo package đúng

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List; // Sẽ dùng để chứa danh sách OrderDetail

public class Order {
    private int orderId;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String shippingAddress;
    private Timestamp orderDate;
    private BigDecimal totalAmount;
    private String status; // Ví dụ: "Pending", "Processing", "Shipped", "Delivered", "Cancelled"
    private String notes;
    // private int userId; // Nếu sau này có chức năng đăng nhập người dùng

    // Danh sách các chi tiết đơn hàng thuộc về đơn hàng này
    // Thuộc tính này không có cột tương ứng trực tiếp trong bảng Orders,
    // nhưng hữu ích khi bạn muốn lấy một Order cùng với tất cả các Detail của nó.
    private List<OrderDetail> orderDetails;

    // Constructors
    public Order() {
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", customerName='" + customerName + '\'' +
                ", customerEmail='" + customerEmail + '\'' +
                ", customerPhone='" + customerPhone + '\'' +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", orderDate=" + orderDate +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                ", orderDetailsCount=" + (orderDetails != null ? orderDetails.size() : 0) +
                '}';
    }
}