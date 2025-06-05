<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Our Products'} - Apple Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
        .product-card a { text-decoration: none; color: inherit; }
        .product-card a:hover h3 { color: #007bff; /* Hoặc màu khác */ }
            /* Sửa màu chữ cho các mục trong dropdown menu của Bootstrap */
            .dropdown-menu .dropdown-item {
                color: #212529 !important; /* Màu chữ tối, ví dụ màu đen mặc định của Bootstrap text */
            }
            .dropdown-menu .dropdown-item:hover {
                color: #16181b !important; /* Màu chữ khi hover, nếu cần */
                background-color: #f8f9fa; /* Màu nền khi hover */
            }
    </style>
</head>
<body>
<c:if test="${not empty sessionScope.cartMessage}">
    <div class="container mt-3"> <%-- Sử dụng container của Bootstrap để căn lề --%>
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.cartMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">×</span>
            </button>
        </div>
    </div>
    <%-- Quan trọng: Xóa attribute khỏi session sau khi đã hiển thị để nó không hiện lại ở lần tải trang sau --%>
    <c:remove var="cartMessage" scope="session"/>
</c:if>

<header class="header-placeholder">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">AppleStore</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ <span class="sr-only">(current)</span></a>
                    </li>
                    <%-- Menu Danh mục (hiển thị dynamic dựa trên categories) --%>
                    <c:if test="${not empty allCategories}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownCategories" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Danh Mục
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdownCategories">
                                <c:forEach var="category" items="${allCategories}">
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}">
                                        <c:out value="${category.name}"/>
                                    </a>
                                </c:forEach>
                            </div>
                        </li>
                    </c:if>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên Hệ</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <%-- LINK GIỎ HÀNG Ở ĐÂY --%>
                            <a class="nav-link" href="${pageContext.request.contextPath}/viewCart" id="cart-link">
                                <i class="fas fa-shopping-cart"></i> Giỏ Hàng (<span id="cart-count">${not empty totalCartItems ? totalCartItems : 0}</span>)
                            </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>

<div class="container mt-4">
    <div class="page-header text-center mb-4">
        <h1>${not empty pageTitle ? pageTitle : 'Our Products'}</h1>
    </div>

    <c:if test="${not empty requestScope.errorMessage}">
        <p class="alert alert-danger">${requestScope.errorMessage}</p>
    </c:if>

    <c:choose>
        <c:when test="${not empty productList}">
            <div class="product-grid">
                <c:forEach var="product" items="${productList}">

                    <div class="product-card">
                            <%-- THÊM LINK VÀO CHI TIẾT SẢN PHẨM --%>
                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                                    <c:if test="${not empty product.imageUrl}">
                                <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}">
                            </c:if>
                            <c:if test="${empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}/images/placeholder.png" alt="No image available">
                            </c:if>
                            <h3><c:out value="${product.name}"/></h3>
                        </a>
                        <p class="price">${product.price} VND</p>
                                <a href="${pageContext.request.contextPath}/addToCart?productId=${product.productId}" class="btn btn-primary add-to-cart-btn">Thêm vào giỏ</a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="no-products alert alert-info">Không tìm thấy sản phẩm nào trong danh mục này hoặc phù hợp với tiêu chí của bạn.</p>
        </c:otherwise>
    </c:choose>
</div>

<footer class="footer-placeholder mt-5">
    <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/cart.js"></script>
</body>
</html>