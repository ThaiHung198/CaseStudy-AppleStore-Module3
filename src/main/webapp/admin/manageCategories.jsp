<%-- File: webapp/admin/manageCategories.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%-- Kiểm tra session admin --%>
<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/> <%-- Đã sửa thành /admin/adminLogin --%>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Quản lý Danh mục - Admin</title>
    <%-- Các link CSS chung cho admin (Bootstrap, Font Awesome, admin_style.css) --%>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <%-- File CSS chung của bạn, bao gồm cả style cho admin --%>
    <%-- Bạn không cần thẻ <c:import url="includes/admin_styles.jsp"/> ở đây nữa nếu đã link style.css --%>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/admin/includes/admin_header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/admin/includes/admin_sidebar.jsp" />

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 admin-main-content">
            <%-- NỘI DUNG HIỆN TẠI CỦA manageCategories.jsp SẼ ĐƯỢC ĐẶT VÀO ĐÂY --%>
            <%-- Bắt đầu từ <div class="container"> hoặc <div class="card"> của bạn --%>

            <div class="card mt-3">
                <div class="card-header">
                    <h4 class="card-title d-flex justify-content-between align-items-center">
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" class="btn btn-link text-secondary p-0 mr-2" title="Quay lại Dashboard">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            Quản lý danh mục
                        </div>
                        <c:if test="${empty param.action or param.action eq 'list'}">
                            <a href="${pageContext.request.contextPath}/admin/manageCategories?action=add" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Thêm mới
                            </a>
                        </c:if>
                    </h4>
                </div>
                <div class="card-body">
                    <%-- Hiển thị thông báo --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${sessionScope.successMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${sessionScope.errorMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty requestScope.errorMessage}">
                        <div class="alert alert-danger">${requestScope.errorMessage}</div>
                    </c:if>

                    <%-- Form Thêm mới hoặc Sửa Category --%>
                    <c:if test="${param.action eq 'add' or not empty categoryToEdit}">
                        <div class="form-container border p-3 mb-4 bg-light rounded"> <%-- Thêm class cho form container --%>
                            <h2>${not empty categoryToEdit ? 'Chỉnh sửa Danh mục' : 'Thêm Danh mục mới'}</h2>
                            <form action="${pageContext.request.contextPath}/admin/manageCategories" method="post">
                                <input type="hidden" name="action" value="${not empty categoryToEdit ? 'update' : 'add'}">
                                <c:if test="${not empty categoryToEdit}">
                                    <input type="hidden" name="categoryId" value="${categoryToEdit.categoryId}">
                                </c:if>
                                <div class="form-group">
                                    <label for="categoryName">Tên danh mục:</label>
                                    <input type="text" id="categoryName" name="categoryName" class="form-control" value="${fn:escapeXml(not empty categoryToEdit ? categoryToEdit.name : param.categoryName)}" required>
                                </div>
                                <div class="form-group">
                                    <label for="categoryDescription">Mô tả:</label>
                                    <textarea id="categoryDescription" name="categoryDescription" class="form-control" rows="3">${fn:escapeXml(not empty categoryToEdit ? categoryToEdit.description : param.categoryDescription)}</textarea>
                                        <%-- Sửa lỗi: categoryToadmin.description thành categoryToEdit.description --%>
                                </div>
                                <button type="submit" class="btn btn-success">${not empty categoryToEdit ? 'Cập nhật' : 'Thêm Danh mục'}</button>
                                <a href="${pageContext.request.contextPath}/admin/manageCategories?action=list" class="btn btn-secondary">Hủy</a>
                            </form>
                        </div>
                    </c:if>

                    <%-- Danh sách Categories --%>
                    <c:if test="${not empty categoryList}">
                        <h2 class="mt-4">Danh sách danh mục hiện có</h2>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover">
                                <thead class="thead-light">
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th>Tên Danh mục</th>
                                    <th>Mô tả</th>
                                    <th class="text-center">Được tạo</th>
                                    <th class="text-center">Được cập nhật</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="category" items="${categoryList}">
                                    <tr>
                                        <td class="text-center">${category.categoryId}</td>
                                        <td><c:out value="${category.name}"/></td>
                                        <td><c:out value="${category.description}"/></td>
                                        <td class="text-center"><fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                        <td class="text-center"><fmt:formatDate value="${category.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                        <td class="text-center">
                                            <a title="Sửa" href="${pageContext.request.contextPath}/admin/manageCategories?action=edit&id=${category.categoryId}" class="btn btn-sm btn-info mr-1">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a title="Xóa" href="${pageContext.request.contextPath}/admin/manageCategories?action=delete&id=${category.categoryId}"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không? Các sản phẩm trong danh mục này có thể bị ảnh hưởng.');"
                                               class="btn btn-sm btn-danger">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categoryList}">
                                    <tr>
                                        <td colspan="6" class="text-center">Không tìm thấy danh mục nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div> <%-- end card-body --%>
            </div> <%-- end card --%>

            <%-- KẾT THÚC NỘI DUNG CŨ CỦA manageCategories.jsp --%>
        </main>
    </div>
</div>

<%-- <jsp:include page="/admin/includes/admin_footer.jsp" /> --%> <%-- Có thể thêm footer nếu muốn --%>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/admin_script.js"></script> --%> <%-- Nếu có JS riêng cho admin --%>
</body>
</html>