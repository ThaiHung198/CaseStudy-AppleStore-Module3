<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Đơn Hàng - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Thêm CSS tùy chỉnh nếu cần */
        .summary-item img { width: 50px; margin-right: 10px; }
        .order-summary { background-color: #f8f9fa; padding: 20px; border-radius: 5px; margin-bottom: 20px;}
    </style>
</head>
<body>
<%-- Header Menu (Copy từ các trang khác) --%>
<header class="header-placeholder"> <%-- Bạn có thể bỏ class này nếu không cần style riêng cho header nữa --%>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"> <%-- fixed-top để navbar luôn ở trên cùng --%>
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="fab fa-apple"></i> <%-- ICON APPLE --%>
                AppleStore
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item ${pageContext.request.servletPath eq '/home' ? 'active' : ''}"><a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
                    <c:if test="${not empty allCategories}">
                        <li class="nav-item dropdown ${(pageContext.request.servletPath eq '/products' and not empty param.categoryId) ? 'active' : ''}">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownCategories" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Danh Mục
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdownCategories">
                                <c:forEach var="category" items="${allCategories}">
                                    <a class="dropdown-item ${category.categoryId eq param.categoryId ? 'active' : ''}" href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}"><c:out value="${category.name}"/></a>
                                </c:forEach>
                            </div>
                        </li>
                    </c:if>
                    <li class="nav-item ${pageContext.request.servletPath eq '/contact' ? 'active' : ''}"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item ${pageContext.request.servletPath eq '/viewCart' or pageContext.request.servletPath eq '/cart-view.jsp' ? 'active' : ''}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/viewCart" id="cart-link">
                            <i class="fas fa-shopping-cart"></i> <span class="d-none d-md-inline">Giỏ Hàng</span> (<span id="cart-count">${not empty totalCartItems ? totalCartItems : 0}</span>)
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminLogin">
                            <i class="fas fa-user-shield"></i> <span class="d-none d-md-inline">Admin</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<div style="padding-top: 56px;"></div> <%-- Thêm khoảng đệm nếu dùng navbar fixed-top --%>

<div class="container mt-4">
    <h2 class="text-center mb-4">Thông Tin Thanh Toán và Giao Hàng</h2>

    <c:if test="${not empty requestScope.checkoutErrorMessage}">
        <div class="alert alert-danger">${requestScope.checkoutErrorMessage}</div>
    </c:if>
    <c:if test="${not empty requestScope.checkoutSuccessMessage}"> <%-- Cho trường hợp redirect từ POST qua GET với message --%>
        <div class="alert alert-success">${requestScope.checkoutSuccessMessage}</div>
    </c:if>

    <div class="row">
        <%-- Cột Thông tin khách hàng --%>
        <div class="col-md-7">
            <h4>Thông tin người nhận hàng</h4>
            <hr>
            <form action="${pageContext.request.contextPath}/checkout" method="post">
                <div class="form-group">
                    <label for="customerName">Họ và Tên (*):</label>
                    <input type="text" class="form-control" id="customerName" name="customerName" value="${fn:escapeXml(param.customerName)}" required>
                </div>
                <div class="form-group">
                    <label for="customerEmail">Email:</label>
                    <input type="email" class="form-control" id="customerEmail" name="customerEmail" value="${fn:escapeXml(param.customerEmail)}">
                </div>
                <div class="form-group">
                    <label for="customerPhone">Số Điện Thoại (*):</label>
                    <input type="tel" class="form-control" id="customerPhone" name="customerPhone" value="${fn:escapeXml(param.customerPhone)}" required>
                </div>
                <div class="form-group">
                    <label for="shippingAddress">Địa Chỉ Giao Hàng (*):</label>
                    <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3" required>${fn:escapeXml(param.shippingAddress)}</textarea>
                </div>
                <div class="form-group">
                    <label for="notes">Ghi Chú Đơn Hàng:</label>
                    <textarea class="form-control" id="notes" name="notes" rows="2">${fn:escapeXml(param.notes)}</textarea>
                </div>
                <hr>
                <p>Vui lòng kiểm tra lại thông tin giỏ hàng và thông tin giao hàng trước khi đặt hàng.</p>
                <button type="submit" class="btn btn-primary btn-lg btn-block">Xác Nhận và Đặt Hàng</button>
            </form>
        </div>

        <%-- Cột Tóm tắt giỏ hàng --%>
        <div class="col-md-5">
            <div class="order-summary">
                <h4>Tóm tắt đơn hàng</h4>
                <hr>
                <c:choose>
                    <c:when test="${not empty cartItemsListForCheckout && fn:length(cartItemsListForCheckout) > 0}">
                        <ul class="list-unstyled">
                            <c:forEach var="item" items="${cartItemsListForCheckout}">
                                <li class="media mb-3 summary-item">
                                    <img src="${not empty item.product.imageUrl ? fn:escapeXml(item.product.imageUrl) : pageContext.request.contextPath += '/images/placeholder.png'}"
                                         class="align-self-center mr-3" alt="${fn:escapeXml(item.product.name)}" style="width: 60px;">
                                    <div class="media-body">
                                        <h6 class="mt-0 mb-1"><c:out value="${item.product.name}"/></h6>
                                        <small>Số lượng: ${item.quantity} x <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</small>
                                    </div>
                                    <span class="text-muted">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                                        </span>
                                </li>
                            </c:forEach>
                        </ul>
                        <hr>
                        <h5 class="d-flex justify-content-between">
                            <span>Tổng Cộng:</span>
                            <strong><fmt:formatNumber value="${totalCartAmountForCheckout}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</strong>
                        </h5>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center">Giỏ hàng của bạn đang trống.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-block">Quay lại mua sắm</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<footer class="footer-placeholder mt-5">
    <%-- ... footer ... --%>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- Không cần cart.js ở đây nếu chỉ hiển thị, nhưng cần cho header --%>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>