<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- Kiểm tra session admin --%>
<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Admin Dashboard - Apple Store</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <%-- Link đến CSS chung, bao gồm cả style cho admin --%>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/admin/includes/admin_header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/admin/includes/admin_sidebar.jsp" />

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 admin-main-content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">TRANG QUẢN LÝ</h1>
            </div>

            <p>Welcome, <strong><c:out value="${sessionScope.adminLoggedIn.userName}"/></strong>!</p>
            <p>This is your admin control panel. Use the sidebar to navigate to different management sections.</p>

            <%-- Có thể thêm các widget hoặc thông tin tóm tắt ở đây --%>
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Categories</h5>
                            <p class="card-text">XX</p> <%-- Sẽ lấy từ DB sau --%>
                            <a href="${pageContext.request.contextPath}/admin/manageCategories" class="btn btn-primary">Manage</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Products</h5>
                            <p class="card-text">YY</p> <%-- Sẽ lấy từ DB sau --%>
                            <a href="${pageContext.request.contextPath}/admin/manageProducts" class="btn btn-primary">Manage</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Pending Orders</h5>
                            <p class="card-text">ZZ</p> <%-- Sẽ lấy từ DB sau --%>
                            <a href="${pageContext.request.contextPath}/admin/viewOrders" class="btn btn-primary">View</a>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<%-- Footer có thể không cần thiết cho layout admin có sidebar, hoặc đặt khác --%>
<%-- <jsp:include page="/admin/includes/admin_footer.jsp" /> --%>


<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/admin_custom.js"></script> --%> <%-- Nếu có JS riêng cho admin --%>
</body>
</html>