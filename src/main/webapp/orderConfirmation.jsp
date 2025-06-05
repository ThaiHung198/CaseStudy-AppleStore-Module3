<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%-- Header Menu --%>
<header class="header-placeholder">
    <nav class="container">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <%-- Không cần hiển thị allCategories ở đây nếu không muốn, hoặc cần servlet riêng --%>
            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a href="${pageContext.request.contextPath}/viewCart" id="cart-link">
                <i class="fas fa-shopping-cart"></i> Giỏ Hàng (<span id="cart-count">${not empty totalCartItems ? totalCartItems : 0}</span>)</a>
                <%-- totalCartItems sẽ là 0 sau khi checkout thành công --%>
            </li>
            <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
        </ul>
    </nav>
</header>

<div class="container mt-5 text-center">
    <c:choose>
        <c:when test="${not empty sessionScope.lastOrderId}">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Đặt Hàng Thành Công!</h4>
                <p>Cảm ơn bạn đã đặt hàng tại Apple Store. Mã đơn hàng của bạn là: <strong>ORD-${sessionScope.lastOrderId}</strong></p>
                <hr>
                <p class="mb-0">Chúng tôi sẽ xử lý đơn hàng của bạn và sớm liên hệ lại. Bạn có thể theo dõi trạng thái đơn hàng trong email (nếu có) hoặc liên hệ chúng tôi.</p>
            </div>
            <c:remove var="lastOrderId" scope="session"/> <%-- Xóa orderId khỏi session --%>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning" role="alert">
                Không có thông tin đơn hàng.
            </div>
        </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Quay lại Trang Chủ</a>
</div>

<footer class="footer-placeholder mt-5">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script> <%-- cart.js sẽ cập nhật cart-count thành 0 --%>
</body>
</html>