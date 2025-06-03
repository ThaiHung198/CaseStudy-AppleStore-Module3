<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Our Products'} - Apple Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <%-- Link CSS chung --%>
    <style>
        /* CSS cơ bản cho productList.jsp - bạn có thể tách ra file riêng */
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header-placeholder { background-color: #333; color: white; padding: 20px; text-align: center; }
        .header-placeholder nav ul { list-style: none; padding: 0; margin: 0; display: flex; justify-content: center; }
        .header-placeholder nav ul li { margin: 0 15px; }
        .header-placeholder nav ul li a { color: white; text-decoration: none; }

        .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .page-header h1 { text-align: center; margin-bottom: 30px; font-size: 2.2em; color: #333; }

        .error-message-jsp { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center;}

        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .product-card { background-color: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .product-card img { max-width: 100%; height: 200px; object-fit: contain; margin-bottom: 10px; }
        .product-card h3 { font-size: 1.2em; margin: 10px 0; min-height: 40px; /* Để các card có chiều cao tên sản phẩm tương đối bằng nhau */}
        .product-card .price { color: #e74c3c; font-weight: bold; margin-bottom: 10px; }
        .product-card .add-to-cart-btn { background-color: #007bff; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .product-card .add-to-cart-btn:hover { background-color: #0056b3; }
        .no-products { text-align: center; font-size: 1.2em; color: #777; padding: 30px; }

        .footer-placeholder { background-color: #222; color: white; text-align: center; padding: 20px; margin-top: 30px; }
    </style>
</head>
<body>

<%-- Header (Menu Danh mục - giống home.jsp) --%>
<header class="header-placeholder">
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <c:if test="${not empty allCategories}">
                <c:forEach var="category" items="${allCategories}">
                    <li>
                        <a href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}"
                           class="${category.name eq currentCategoryName ? 'active' : ''}"> <%-- Đánh dấu active category hiện tại nếu có --%>
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
    <div class="page-header">
        <h1>${not empty pageTitle ? pageTitle : 'Our Products'}</h1>
    </div>

    <c:if test="${not empty requestScope.errorMessage}">
        <p class="error-message-jsp">${requestScope.errorMessage}</p>
    </c:if>

    <c:choose>
        <c:when test="${not empty productList}">
            <div class="product-grid">
                <c:forEach var="product" items="${productList}">
                    <div class="product-card">
                        <c:if test="${not empty product.imageUrl}">
                            <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}">
                        </c:if>
                        <h3><c:out value="${product.name}"/></h3>
                        <p class="price">${product.price} VND</p>
                        <button class="add-to-cart-btn" onclick="addToCart(${product.productId}, '${fn:escapeXml(product.name)}', ${product.price}, '${fn:escapeXml(product.imageUrl)}')">Thêm vào giỏ</button>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="no-products">No products found in this category or matching your criteria.</p>
        </c:otherwise>
    </c:choose>
</div>

<footer class="footer-placeholder">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>