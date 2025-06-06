<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Ordered Items - Admin</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/admin/includes/admin_header.jsp" /> <%-- Giả sử header admin đã tách --%>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/admin/includes/admin_sidebar.jsp" /> <%-- Giả sử sidebar admin đã tách --%>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 admin-main-content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Danh sách hóa đơn</h1>
            </div>

            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert alert-danger">${requestScope.errorMessage}</div>
            </c:if>

            <div class="table-responsive">
                <table class="table table-striped table-sm">
                    <thead>
                    <tr>
                        <th>ID Hóa Đơn</th>
                        <th>Ngày Đặt Hàng</th>
                        <th>Tên Sản Phẩm</th>
                        <th class="text-center">Số Lượng</th>
                        <th class="text-right">Giá lúc mua</th>
                        <th class="text-right">Tổng Hóa Đơn</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty orderedItemsList}">
                            <c:forEach var="item" items="${orderedItemsList}">
                                <tr>
                                    <td>ORD-${item.orderId}</td>
                                    <td><fmt:formatDate value="${item.orderDate}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                    <td><c:out value="${item.productName}"/></td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-right"><fmt:formatNumber value="${item.priceAtPurchase}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</td>
                                    <td class="text-right"><fmt:formatNumber value="${item.priceAtPurchase * item.quantity}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center">No ordered items found.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<%-- <jsp:include page="/admin/includes/admin_footer.jsp" /> --%>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>