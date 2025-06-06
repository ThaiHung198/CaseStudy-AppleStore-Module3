<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Lấy servlet path để xác định mục menu active --%>
<c:set var="currentAdminPage" value="${pageContext.request.servletPath}"/>

<nav id="adminSidebar" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="sidebar-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${fn:endsWith(currentAdminPage, '/admin/adminDashboard.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i> Trang tổng quan
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:endsWith(currentAdminPage, '/manageCategories') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manageCategories">
                    <i class="fas fa-sitemap"></i> Quản lý danh mục
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:endsWith(currentAdminPage, '/manageProducts') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/manageProducts">
                    <i class="fas fa-boxes"></i> Quản lý sản phẩm
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:endsWith(currentAdminPage, '/adminViewOrders') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/viewOrders"> <%-- Sẽ tạo servlet này sau --%>
                    <i class="fas fa-file-invoice-dollar"></i> Quản lý đơn hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:endsWith(currentAdminPage, '/adminViewRequests') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/viewRequests"> <%-- Sẽ tạo servlet này sau --%>
                    <i class="fas fa-envelope-open-text"></i> Yêu cầu của khách hàng
                </a>
            </li>
        </ul>
    </div>
</nav>