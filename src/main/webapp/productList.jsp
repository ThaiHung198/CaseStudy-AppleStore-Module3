<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Thêm fmt để định dạng giá --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>${not empty pageTitle ? pageTitle : 'Sản phẩm'} - Apple Store</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Your Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <%-- XÓA KHỐI <style>...</style> Ở ĐÂY. NỘI DUNG ĐÃ/SẼ ĐƯỢC CHUYỂN VÀO css/style.css --%>
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
    <div class="page-header text-center mb-4">
        <h1>${not empty pageTitle ? pageTitle : 'Tất cả sản phẩm'}</h1>
    </div>

    <%-- Thông báo lỗi từ ProductListServlet (ví dụ: categoryId không hợp lệ) --%>
    <c:if test="${not empty requestScope.errorMessage}">
        <p class="alert alert-warning">${requestScope.errorMessage}</p>
    </c:if>
    <c:if test="${not empty requestScope.infoMessage}">
        <p class="alert alert-info">${requestScope.infoMessage}</p>
    </c:if>


    <c:choose>
        <c:when test="${not empty productList}">
            <div class="row"> <%-- Sử dụng row của Bootstrap cho product-grid --%>
                <c:forEach var="product" items="${productList}">
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4"> <%-- Cột Bootstrap --%>
                        <div class="card h-100 product-card"> <%-- Bootstrap Card --%>
                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                                <c:if test="${not empty product.imageUrl}">
                                    <img src="${fn:escapeXml(product.imageUrl)}" class="card-img-top" alt="${fn:escapeXml(product.name)}">
                                </c:if>
                                <c:if test="${empty product.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/images/placeholder.png" class="card-img-top" alt="No image available">
                                </c:if>
                            </a>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="text-dark font-weight-bold">
                                        <c:out value="${product.name}"/>
                                    </a>
                                </h5>
                                <p class="card-text text-danger font-weight-bold">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND
                                </p>
                                <a href="${pageContext.request.contextPath}/addToCart?productId=${product.productId}" class="btn btn-primary mt-auto add-to-cart-btn">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info text-center no-products">
                <c:choose>
                    <c:when test="${not empty requestScope.errorMessage or not empty requestScope.infoMessage}">
                        <%-- Đã có thông báo cụ thể hơn ở trên --%>
                    </c:when>
                    <c:otherwise>
                        Không tìm thấy sản phẩm nào.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/bootstrap/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/cart.js"></script> --%> <%-- Xem xét có cần không --%>
</body>
</html>