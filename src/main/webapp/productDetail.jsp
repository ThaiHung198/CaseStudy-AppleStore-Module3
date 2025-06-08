<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Thêm fmt để định dạng giá --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title><c:out value="${product.name}"/> - Chi Tiết Sản Phẩm - Apple Store</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Your Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <%-- XÓA KHỐI <style>...</style> Ở ĐÂY. NỘI DUNG ĐÃ/SẼ ĐƯỢC CHUYỂN VÀO css/style.css --%>
    <%-- (Lưu ý: CSS cho .product-detail-layout, .product-image-lg, .product-info, .breadcrumbs đã có trong style.css từ gợi ý trước) --%>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/bootstrap/header.jsp" />

<%-- Thông báo cartMessage (nếu có từ AddToCartServlet) --%>
<c:if test="${not empty sessionScope.cartMessage}">
    <div class="container mt-3">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.cartMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
    </div>
    <c:remove var="cartMessage" scope="session"/>
</c:if>

<main class="container mt-4 flex-grow-1">
    <c:if test="${not empty product}">
        <div class="breadcrumbs">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a> >
            <c:if test="${not empty productCategory}">
                <a href="${pageContext.request.contextPath}/products?categoryId=${productCategory.categoryId}"><c:out value="${productCategory.name}"/></a> >
            </c:if>
            <span><c:out value="${product.name}"/></span>
        </div>

        <div class="row product-detail-layout"> <%-- Sử dụng row của Bootstrap --%>
            <div class="col-md-6 product-image-lg"> <%-- Cột cho ảnh --%>
                <c:if test="${not empty product.imageUrl}">
                    <img src="${fn:escapeXml(product.imageUrl)}" class="img-fluid rounded" alt="${fn:escapeXml(product.name)}"> <%-- Thêm class img-fluid --%>
                </c:if>
                <c:if test="${empty product.imageUrl}">
                    <img src="${pageContext.request.contextPath}/images/placeholder.png" class="img-fluid rounded" alt="No Image Available">
                </c:if>
            </div>
            <div class="col-md-6 product-info"> <%-- Cột cho thông tin --%>
                <h1><c:out value="${product.name}"/></h1>
                <c:if test="${not empty productCategory}">
                    <p class="category-name">Danh mục:
                        <a href="${pageContext.request.contextPath}/products?categoryId=${productCategory.categoryId}">
                            <c:out value="${productCategory.name}"/>
                        </a>
                    </p>
                </c:if>
                <p class="price-lg">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                </p>
                <div class="description mb-3">
                        <%-- Sử dụng thẻ p cho từng đoạn nếu mô tả có nhiều đoạn --%>
                    <p><c:out value="${product.description}" escapeXml="false"/></p>
                </div>
                <p class="stock-status ${product.stockQuantity > 0 ? 'in-stock text-success' : 'out-of-stock text-danger'}">
                        ${product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                    <c:if test="${product.stockQuantity > 0}">
                        (${product.stockQuantity} sản phẩm)
                    </c:if>
                </p>
                <c:if test="${product.stockQuantity > 0}">
                    <form action="${pageContext.request.contextPath}/addToCart" method="post" class="mt-3">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <div class="form-row align-items-center">
                            <div class="col-auto">
                                <label for="quantity-${product.productId}" class="mr-2">Số lượng:</label>
                                <input type="number" name="quantity" id="quantity-${product.productId}" class="form-control form-control-sm d-inline-block" value="1" min="1" max="${product.stockQuantity}" style="width: 70px;">
                            </div>
                                <a href="${pageContext.request.contextPath}/addToCart?productId=${product.productId}" class="btn btn-primary mt-auto add-to-cart-btn">Thêm vào giỏ</a>                            </div>
                    </form>
                </c:if>
            </div>
        </div>
    </c:if>
    <c:if test="${empty product}">
        <div class="alert alert-warning text-center">Sản phẩm không tìm thấy.</div>
    </c:if>
</main>

<jsp:include page="/bootstrap/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/cart.js"></script> --%> <%-- Bỏ nếu không dùng cart.js client-side --%>
</body>
</html>