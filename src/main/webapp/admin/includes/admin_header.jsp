<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid"> <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">TRANG QUẢN LÝ</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav ml-auto">
                <c:if test="${not empty sessionScope.adminLoggedIn}">
                    <li class="nav-item">
                        <span class="navbar-text mr-3">
                            Chào, <c:out value="${sessionScope.adminLoggedIn.userName}"/>!
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-danger btn-sm text-white" href="${pageContext.request.contextPath}/home" class="logout-btn">
                            <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
<div style="padding-top: 56px;"></div> <%-- Để nội dung không bị che bởi fixed-top navbar --%>