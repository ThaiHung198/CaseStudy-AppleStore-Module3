<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apple Store - Trang Chủ</title>
    <%-- Link CSS (Bootstrap và custom) --%>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS của bạn ... (tôi giữ nguyên phần CSS bạn đã cung cấp) */
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header-placeholder { background-color: #333; color: white; padding: 20px; text-align: center; }
        .header-placeholder nav ul { list-style: none; padding: 0; margin: 0; display: flex; justify-content: center; }
        .header-placeholder nav ul li { margin: 0 15px; }
        .header-placeholder nav ul li a { color: white; text-decoration: none; }

        .banner-placeholder { background-color: #e9e9e9; text-align: center; padding: 50px 20px; margin-bottom: 30px; }
        .banner-placeholder h1 { margin: 0; font-size: 2.5em; }

        .container { max-width: 1200px; margin: 0 auto; padding: 0 15px; }
        .section-title { text-align: center; margin-bottom: 30px; font-size: 2em; color: #333; }

        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .product-card { background-color: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .product-card img { max-width: 100%; height: 200px; object-fit: contain; margin-bottom: 10px; }
        .product-card h3 { font-size: 1.2em; margin: 10px 0; }
        .product-card .price { color: #e74c3c; font-weight: bold; margin-bottom: 10px; }
        .product-card .add-to-cart-btn { background-color: #007bff; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .product-card .add-to-cart-btn:hover { background-color: #0056b3; }

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
            <li><a href="${pageContext.request.contextPath}/cart-view" id="cart-link">Giỏ Hàng (<span id="cart-count">0</span>)</a></li> <%-- Sửa href cho giỏ hàng --%>
            <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
        </ul>
    </nav>
</header>

<section class="banner-placeholder">
    <h1>Chào mừng đến với Cửa hàng Apple của chúng tôi</h1>
    <p>Khám phá các sản phẩm và phụ kiện mới nhất của Apple.</p>
</section>

<div class="container">
    <c:if test="${not empty featuredProducts}">
        <section class="featured-products">
            <h2 class="section-title">Sản Phẩm Nổi Bật</h2>
            <div class="product-grid">
                <c:forEach var="product" items="${featuredProducts}">
                    <div class="product-card">
                            <%-- Bọc ảnh và tên sản phẩm trong thẻ <a> để link đến chi tiết --%>
                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" style="text-decoration: none; color: inherit;">
                            <c:if test="${not empty product.imageUrl}">
                                <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}">
                            </c:if>
                            <c:if test="${empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}/images/placeholder.png" alt="No image available">
                            </c:if>
                            <h3><c:out value="${product.name}"/></h3>
                        </a>
                        <p class="price">${product.price} VND</p>
                            <%-- Nút này bây giờ chỉ là tượng trưng, không cần JS phức tạp nếu bạn muốn CSS tĩnh cho giỏ hàng --%>
                        <button class="add-to-cart-btn">Thêm vào giỏ (Tượng trưng)</button>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <%-- Phần newestProducts nếu bạn muốn triển khai sau --%>
    <%--
    <c:if test="${not empty newestProducts}">
        <section class="newest-products">
            <h2 class="section-title">Sản Phẩm Mới</h2>
            ...
        </section>
    </c:if>
    --%>
</div>

<footer class="footer-placeholder">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<%-- Bỏ qua cart.js nếu giỏ hàng chỉ là CSS tĩnh và không có logic JS phức tạp --%>
<%-- <script src="${pageContext.request.contextPath}/js/cart.js"></script> --%>

<%-- Bootstrap JS (nếu bạn sử dụng các component JS của Bootstrap) --%>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>