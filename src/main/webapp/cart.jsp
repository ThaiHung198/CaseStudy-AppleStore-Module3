<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Để định dạng số (giá tiền) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .cart-item-image { width: 80px; height: 80px; object-fit: contain; margin-right: 15px; }
        .quantity-input { width: 60px; text-align: center; }
        .table th, .table td { vertical-align: middle; }
        .total-row td { font-weight: bold; font-size: 1.2em; }
    </style>
</head>
<body>
<%-- Header Menu (Copy từ home.jsp hoặc các trang khác) --%>
<header class="header-placeholder">
    <nav class="container">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <c:if test="${not empty allCategories}">
                <c:forEach var="category" items="${allCategories}">
                    <li><a href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}"><c:out value="${category.name}"/></a></li>
                </c:forEach>
            </c:if>
            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a class="nav-link" href="${pageContext.request.contextPath}/viewCart" id="cart-link">
                <i class="fas fa-shopping-cart"></i> Giỏ Hàng (<span id="cart-count">${not empty totalCartItems ? totalCartItems : 0}</span>)
            </a> <%-- JS sẽ cập nhật số này --%>
            </li>
            <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
        </ul>
    </nav>
</header>

<div class="container mt-4">
    <h2 class="text-center mb-4">Giỏ Hàng Của Bạn</h2>

    <%-- Hiển thị thông báo (nếu có, ví dụ từ UpdateCartServlet hoặc RemoveFromCartServlet) --%>
    <c:if test="${not empty sessionScope.cartActionMessage}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.cartActionMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">×</span>
            </button>
        </div>
        <c:remove var="cartActionMessage" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${not empty cartItemsList}">
            <table class="table table-hover">
                <thead class="thead-light">
                <tr>
                    <th style="width: 10%;">Ảnh</th>
                    <th style="width: 35%;">Tên Sản Phẩm</th>
                    <th style="width: 15%;" class="text-right">Đơn Giá</th>
                    <th style="width: 15%;" class="text-center">Số Lượng</th>
                    <th style="width: 15%;" class="text-right">Thành Tiền</th>
                    <th style="width: 10%;">Xóa</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${cartItemsList}">
                    <tr>
                        <td>
                            <img src="${not empty item.product.imageUrl ? fn:escapeXml(item.product.imageUrl) : pageContext.request.contextPath += '/images/placeholder.png'}"
                                 alt="${fn:escapeXml(item.product.name)}" class="cart-item-image">
                        </td>
                        <td><c:out value="${item.product.name}"/></td>
                        <td class="text-right">
                            <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                        </td>
                        <td class="text-center">
                                <%-- Form để cập nhật số lượng --%>
                            <form action="${pageContext.request.contextPath}/updateCart" method="post" style="display: inline-flex; align-items: center;">
                                <input type="hidden" name="productId" value="${item.product.productId}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stockQuantity}" class="form-control form-control-sm quantity-input" onchange="this.form.submit()">
                                    <%-- onchange="this.form.submit()" sẽ tự động submit form khi số lượng thay đổi --%>
                                    <%-- Hoặc có thể thêm nút "Cập nhật" riêng --%>
                            </form>
                        </td>
                        <td class="text-right">
                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                        </td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/removeFromCart?productId=${item.product.productId}" class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?');">
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr class="total-row">
                    <td colspan="4" class="text-right"><strong>Tổng Cộng:</strong></td>
                    <td class="text-right">
                        <strong><fmt:formatNumber value="${totalCartAmount}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</strong>
                    </td>
                    <td></td>
                </tr>
                </tfoot>
            </table>
            <div class="text-right mt-4">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary mr-2">Tiếp tục mua sắm</a>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary">Tiến hành Thanh Toán</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info text-center">Giỏ hàng của bạn đang trống. <a href="${pageContext.request.contextPath}/home">Bắt đầu mua sắm</a>!</div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="footer-placeholder mt-5">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script> <%-- cart.js sẽ cập nhật #cart-count --%>
</body>
</html>