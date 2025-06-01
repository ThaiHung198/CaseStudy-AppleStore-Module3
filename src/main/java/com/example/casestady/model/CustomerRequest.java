package com.example.casestady.model;

import java.sql.Timestamp;

public class CustomerRequest {
    private int requestId;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String message;
    private String status;
    private Timestamp receivedAt;

    public CustomerRequest() {
    }

    public CustomerRequest(String customerName, String customerEmail, String customerPhone, String message) {
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.message = message;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(Timestamp receivedAt) {
        this.receivedAt = receivedAt;
    }

    @Override
    public String toString() {
        return "CustomerRequest{" +
                "requestId=" + requestId +
                ", customerName='" + customerName + '\'' +
                ", customerEmail='" + customerEmail + '\'' +
                ", customerPhone='" + customerPhone + '\'' +
                ", message='" + message + '\'' +
                ", status='" + status + '\'' +
                ", receivedAt=" + receivedAt +
                '}';

    }
}
