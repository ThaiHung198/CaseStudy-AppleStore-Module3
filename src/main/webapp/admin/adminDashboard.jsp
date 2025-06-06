<%--
  Created by IntelliJ IDEA.
  User: thaih
  Date: 02/06/2025
  Time: 8:57 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Kiểm tra xem admin đã đăng nhập chưa --%>
<c:if test="${empty sessionScope.adminLoggedIn}">
    <%-- Nếu chưa đăng nhập, chuyển hướng về trang login --%>
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"> <!-- Tùy chọn cho icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS cơ bản */
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px; border-bottom: 1px solid #ccc; }
        .header h1 { margin: 0; }
        .logout-btn { padding: 8px 15px; background-color: #dc3545; color: white; text-decoration: none; border-radius: 4px; }
        .logout-btn:hover { background-color: #c82333; }
        .content { margin-top: 20px; }
    </style>
</head>
<body>
<div class="header">
    <h1>Admin Dashboard</h1>
    <a href="${pageContext.request.contextPath}/home" class="logout-btn">Logout</a>
</div>

<div class="content">
    <p>Welcome, <strong>${sessionScope.adminLoggedIn.userName}</strong>!</p>
    <%-- Hoặc ${sessionScope.adminUsername} nếu bạn chỉ lưu username --%>

    <p>This is the admin dashboard. You can add links to manage categories, products, view customer requests, etc.</p>
    <ul>
        <li><a href="${pageContext.request.contextPath}/admin/manageCategories">Manage Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/manageProducts">Quản lý sản phẩm</a></li>
        <li><a href="${pageContext.request.contextPath}/viewRequests">View Customer Requests</a></li>

    </ul>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>
