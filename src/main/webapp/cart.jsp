<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Giỏ Hàng - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/bootstrap/header.jsp" />

<main class="container mt-4 flex-grow-1">
    <h2 class="text-center mb-4">Giỏ Hàng Của Bạn</h2>

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
                    <th style="width: 10%;" class="text-center">Xóa</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${cartItemsList}">
                    <tr>
                        <td>
                            <c:url var="resolvedImageUrl" value="${not empty item.product.imageUrl ? item.product.imageUrl : '/images/placeholder.png'}" />
                            <img src="${fn:escapeXml(resolvedImageUrl)}" alt="${fn:escapeXml(item.product.name)}" class="cart-item-image">
                        </td>
                        <td><c:out value="${item.product.name}"/></td>
                        <td class="text-right">
                            <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                        </td>
                        <td class="text-center">
                            <form action="${pageContext.request.contextPath}/updateCart" method="post" style="display: inline-flex; align-items: center;">
                                <input type="hidden" name="productId" value="${item.product.productId}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stockQuantity}" class="form-control form-control-sm quantity-input" onchange="this.form.submit()">
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
                <tfoot class="font-weight-bold">
                <tr class="total-row">
                    <td colspan="4" class="text-right"><strong>Tổng Cộng:</strong></td>
                    <td class="text-right">
                        <strong><fmt:formatNumber value="${totalCartAmount}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</strong>
                    </td>
                    <td class="text-center"></td>
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
</main>

<jsp:include page="/bootstrap/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>