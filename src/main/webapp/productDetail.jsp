<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${product.name}"/> - Chi Tiết Sản Phẩm - Apple Store</title>
    link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- (Tùy chọn) Font Awesome cho icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- CSS tùy chỉnh của bạn (nếu có, nên đặt sau Bootstrap để ghi đè) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS cơ bản cho productDetail.jsp */
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header-placeholder { background-color: #333; color: white; padding: 20px; text-align: center; }
        .header-placeholder nav ul { list-style: none; padding: 0; margin: 0; display: flex; justify-content: center; }
        .header-placeholder nav ul li { margin: 0 15px; }
        .header-placeholder nav ul li a { color: white; text-decoration: none; }

        .container { max-width: 900px; margin: 20px auto; background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .product-detail-layout { display: flex; gap: 30px; }
        .product-image-lg { flex: 1; text-align: center; }
        .product-image-lg img { max-width: 100%; max-height: 400px; object-fit: contain; border: 1px solid #eee; border-radius: 4px;}
        .product-info { flex: 1; }
        .product-info h1 { font-size: 2em; margin-top: 0; margin-bottom: 15px; color: #333; }
        .product-info .category-name { font-size: 0.9em; color: #777; margin-bottom: 10px; }
        .product-info .category-name a { color: #007bff; text-decoration: none; }
        .product-info .category-name a:hover { text-decoration: underline; }
        .product-info .price-lg { font-size: 1.8em; color: #e74c3c; font-weight: bold; margin-bottom: 20px; }
        .product-info .description { line-height: 1.6; color: #555; margin-bottom: 20px; }
        .product-info .stock-status { margin-bottom: 20px; font-weight: bold; }
        .product-info .stock-status.in-stock { color: #28a745; }
        .product-info .stock-status.out-of-stock { color: #dc3545; }
        .product-info .add-to-cart-btn-lg { background-color: #007bff; color: white; padding: 12px 25px; border: none; border-radius: 5px; cursor: pointer; font-size: 1.1em; text-decoration: none; display: inline-block; }
        .product-info .add-to-cart-btn-lg:hover { background-color: #0056b3; }
        .breadcrumbs { margin-bottom: 20px; font-size: 0.9em; }
        .breadcrumbs a { text-decoration: none; color: #007bff; }
        .breadcrumbs span { color: #777; }

        .footer-placeholder { background-color: #222; color: white; text-align: center; padding: 20px; margin-top: 30px; }
    </style>
</head>
<body>
<header class="header-placeholder">
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <c:if test="${not empty allCategories}">
                <c:forEach var="category" items="${allCategories}">
                    <li>
                        <a href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}">
                            <c:out value="${category.name}"/>
                        </a>
                    </li>
                </c:forEach>
            </c:if>
            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a href="#" id="cart-link">Giỏ Hàng (<span id="cart-count">0</span>)</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <c:if test="${not empty product}">
        <div class="breadcrumbs">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a> >
            <c:if test="${not empty productCategory}">
                <a href="${pageContext.request.contextPath}/products?categoryId=${productCategory.categoryId}"><c:out value="${productCategory.name}"/></a> >
            </c:if>
            <span><c:out value="${product.name}"/></span>
        </div>

        <div class="product-detail-layout">
            <div class="product-image-lg">
                <c:if test="${not empty product.imageUrl}">
                    <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}">
                </c:if>
                <c:if test="${empty product.imageUrl}">
                    <img src="${pageContext.request.contextPath}/images/placeholder.png" alt="No Image Available"> <%-- Ảnh placeholder nếu không có ảnh sản phẩm --%>
                </c:if>
            </div>
            <div class="product-info">
                <h1><c:out value="${product.name}"/></h1>
                <c:if test="${not empty productCategory}">
                    <p class="category-name">Danh mục: <a href="${pageContext.request.contextPath}/products?categoryId=${productCategory.categoryId}"><c:out value="${productCategory.name}"/></a></p>
                </c:if>
                <p class="price-lg">${product.price} VND</p>
                <div class="description">
                    <p><c:out value="${product.description}" escapeXml="false"/></p> <%-- Cho phép HTML cơ bản trong mô tả nếu cần, cẩn thận XSS --%>
                </div>
                <p class="stock-status ${product.stockQuantity > 0 ? 'in-stock' : 'out-of-stock'}">
                        ${product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng'} (${product.stockQuantity} sản phẩm)
                </p>
                <c:if test="${product.stockQuantity > 0}">
                    <button class="add-to-cart-btn-lg" onclick="addToCart(${product.productId}, '${fn:escapeXml(product.name)}', ${product.price}, '${fn:escapeXml(product.imageUrl)}')">Thêm vào giỏ</button>
                </c:if>
            </div>
        </div>
    </c:if>
    <c:if test="${empty product}">
        <p>Sản phẩm không tìm thấy.</p>
    </c:if>
</div>

<footer class="footer-placeholder">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<!-- Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script> <!-- Hoặc phiên bản Popper cho BS4 -->
<!-- Bootstrap JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- cart.js của bạn (nếu cần) -->
<script src="${pageContext.request.contextPath}/js/cart.js"></script>

</body>
</html>