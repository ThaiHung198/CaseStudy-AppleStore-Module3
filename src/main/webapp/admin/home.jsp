<%-- File: webapp/admin/home.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Apple Store - Trang Chủ</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Your Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/bootstrap/header.jsp" />

<%-- Thông báo cartMessage (nếu có) --%>
<c:if test="${not empty sessionScope.cartMessage}">
    <div class="container mt-3">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.cartMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
    </div>
    <c:remove var="cartMessage" scope="session"/>
</c:if>

<%-- 1. Banner Carousel --%>
<div id="mainBanner" class="carousel slide mb-4" data-ride="carousel"> <%-- Thêm mb-4 --%>
    <ol class="carousel-indicators">
        <li data-target="#mainBanner" data-slide-to="0" class="active"></li>
        <li data-target="#mainBanner" data-slide-to="1"></li>
        <li data-target="#mainBanner" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="${pageContext.request.contextPath}/images/banner1.png" class="d-block w-100" alt="Sắm táo mới">

        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/images/banner2.png" class="d-block w-100" alt="Trả góp 0%">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/images/banner3.png" class="d-block w-100" alt="Thu cũ tặng tai nghe">
        </div>
    </div>
    <a class="carousel-control-prev" href="#mainBanner" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#mainBanner" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>

<main class="container mt-4 flex-grow-1">
    <%-- 3. Sản phẩm nổi bật --%>
    <c:if test="${not empty featuredProducts}">
        <div class="section-title-container">
            <h2 class="section-title">Sản Phẩm Nổi Bật</h2>
        </div>
        <div class="row">
            <c:forEach var="product" items="${featuredProducts}">
                <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="card h-100 product-card">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                            <c:if test="${not empty product.imageUrl}">
                                <img src="${fn:escapeXml(product.imageUrl)}" class="card-img-top" alt="${fn:escapeXml(product.name)}">
                            </c:if>
                            <c:if test="${empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}/images/placeholder.png" class="card-img-top" alt="No image">
                            </c:if>
                        </a>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="text-dark font-weight-bold"><c:out value="${product.name}"/></a>
                            </h5>
                            <p class="card-text text-danger font-weight-bold">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                            </p>
                            <a href="${pageContext.request.contextPath}/addToCart?productId=${product.productId}" class="btn btn-primary mt-auto add-to-cart-btn">Thêm vào giỏ</a>                        </div>
                    </div>
                </div>
            </c:forEach> <%-- ĐÓNG C:FOREACH CHO FEATUREDPRODUCTS --%>
        </div>
    </c:if> <%-- ĐÓNG C:IF CHO FEATUREDPRODUCTS --%>

    <%-- 4. Các danh mục lần lượt hiện ở dưới --%>
    <c:if test="${not empty allCategories}">
        <c:forEach var="categoryEntry" items="${productsByCategoryForHome}"> <%-- Lặp qua Map Entry --%>
            <c:set var="category" value="${categoryEntry.key}"/>
            <c:set var="productsInThisCategory" value="${categoryEntry.value}"/>
            <c:if test="${not empty productsInThisCategory}">
                <div class="mt-5">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="section-title mb-0" style="border-bottom: none; display: inline; font-size: 1.7rem;">${category.name}</h3>
                    <a href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}" class="btn btn-outline-primary btn-sm">Xem tất cả <i class="fas fa-arrow-right"></i></a>
                </div>
                <div class="row">
                    <c:forEach var="prodInCat" items="${productsInThisCategory}"> <%-- Lặp qua List sản phẩm của category --%>
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card h-100 product-card ${prodInCat.stockQuantity <= 0 ? 'is-out-of-stock' : ''}"> <%-- Thêm is-out-of-stock nếu cần --%>
                                    <%-- LỚP PHỦ HẾT HÀNG --%>
                                <c:if test="${prodInCat.stockQuantity <= 0}">
                                    <div class="out-of-stock-overlay">
                                        <span>Hết hàng</span>
                                    </div>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/product-detail?id=${prodInCat.productId}">
                                    <c:if test="${not empty prodInCat.imageUrl}">
                                        <img src="${fn:escapeXml(prodInCat.imageUrl)}" class="card-img-top" alt="${fn:escapeXml(prodInCat.name)}">
                                    </c:if>
                                    <c:if test="${empty prodInCat.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/placeholder.png" class="card-img-top" alt="No image">
                                    </c:if>
                                </a>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${prodInCat.productId}" class="text-dark font-weight-bold"><c:out value="${prodInCat.name}"/></a>
                                    </h5>
                                    <p class="card-text text-danger font-weight-bold">
                                        <fmt:formatNumber value="${prodInCat.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                                    </p>
                                    <a href="${pageContext.request.contextPath}/addToCart?productId=${prodInCat.productId}" class="btn btn-primary mt-auto">Thêm vào giỏ</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach> <%-- ĐÓNG C:FOREACH CHO PRODINCAT --%>
                </div>
            </c:if> <%-- ĐÓNG C:IF CHO NOT EMPTY PRODUCTSINTHISCATEGORY --%>
            <hr class="my-4">
            </div>
        </c:forEach> <%-- ĐÓNG C:FOREACH CHO CATEGORYENTRY --%>
    </c:if> <%-- ĐÓNG C:IF CHO NOT EMPTY ALLCATEGORIES --%>
</main>

<jsp:include page="/bootstrap/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- Nếu không dùng cart.js client-side phức tạp, có thể bỏ link này --%>
<%-- <script src="${pageContext.request.contextPath}/js/cart.js"></script> --%>
</body>
</html>