<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng Của Bạn - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
    </style>
</head>
<body>
<%-- Copy Header Menu vào đây --%>
<header class="header-placeholder">
    <nav class="container">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <%-- Cần truyền allCategories vào trang này nếu muốn menu động.
                 Hoặc có thể bỏ menu category nếu không cần thiết trên trang giỏ hàng.
                 Nếu bỏ, bạn cần 1 servlet map với /cart-details.jsp để lấy allCategories,
                 hoặc dùng filter. Để đơn giản, tạm thời có thể bỏ qua menu động categories ở đây.
            --%>
            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a href="${pageContext.request.contextPath}/cart-details.jsp" id="cart-link" class="active">
                <i class="fas fa-shopping-cart"></i> Giỏ Hàng (<span id="cart-count">0</span>)</a>
            </li>
            <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
        </ul>
    </nav>
</header>

<div class="container mt-4">
    <h2 class="text-center mb-4">Giỏ Hàng Của Bạn</h2>
    <hr>
    <table class="table table-hover">
        <thead class="thead-light">
        <tr>
            <th style="width: 10%;">Ảnh</th>
            <th style="width: 30%;">Tên Sản Phẩm</th>
            <th style="width: 15%;" class="text-right">Đơn Giá</th>
            <th style="width: 15%;" class="text-center">Số Lượng</th>
            <th style="width: 15%;" class="text-right">Thành Tiền</th>
            <th style="width: 15%;" class="text-center">Hành Động</th>
        </tr>
        </thead>
        <tbody id="dynamic-cart-items-container">
        <%-- JavaScript (renderCartPageItems) sẽ điền vào đây --%>
        </tbody>
        <tfoot class="font-weight-bold">
        <tr>
            <td colspan="4" class="text-right">Tổng Cộng:</td>
            <td id="dynamic-cart-total" class="text-right">0.00 VND</td>
            <td></td>
        </tr>
        </tfoot>
    </table>
    <div class="text-right mt-3">
        <button class="btn btn-danger mr-2" onclick="clearCart()">Xóa Toàn Bộ Giỏ Hàng</button>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary mr-2">Tiếp tục mua sắm</a>
        <button class="btn btn-primary" onclick="proceedToCheckout()">Tiến hành Thanh Toán</button>
    </div>
</div>

<footer class="footer-placeholder mt-5">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>
