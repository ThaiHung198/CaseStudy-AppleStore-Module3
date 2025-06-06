<%--
  Created by IntelliJ IDEA.
  User: thaih
  Date: 02/06/2025
  Time: 3:27 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <%-- Cho việc escape HTML --%>

<%-- Kiểm tra session admin --%>
<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Categories - Admin</title>
    <c:import url="includes/admin_styles.jsp"/>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h4 class="card-title d-flex justify-content-between align-items-center">
                <div>
                    <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" class="btn btn-link"><i
                            class="fa-solid fa-arrow-left"></i></a>
                    Quản lý danh mục
                </div>
                <%-- Nút để hiển thị form Add New Category --%>
                <%-- Chỉ hiển thị nút "Add New" nếu không phải đang ở form add hoặc edit --%>
                <c:if test="${empty param.action or param.action eq 'list'}">
                    <a href="${pageContext.request.contextPath}/admin/manageCategories?action=add"
                       class="btn btn-primary"><i class="fa-solid fa-plus"></i> Thêm mới</a>
                </c:if>
            </h4>
        </div>
        <div class="card-body">

            <%-- Hiển thị thông báo từ session (nếu có) và xóa chúng --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <p class="message success-message">${sessionScope.successMessage}</p>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <p class="message error-message-jsp">${sessionScope.errorMessage}</p>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <%-- Hiển thị thông báo lỗi từ request (ví dụ: validation error từ servlet) --%>
            <c:if test="${not empty requestScope.errorMessage}">
                <p class="message error-message-jsp">${requestScope.errorMessage}</p>
            </c:if>

            <%-- Form Thêm mới hoặc Sửa Category --%>
            <%-- Sẽ hiển thị nếu action là "add" hoặc "edit" (thông qua "categoryToEdit" được set) --%>
            <c:if test="${param.action eq 'add' or not empty categoryToEdit}">
                    <h2>${not empty categoryToEdit ? 'Edit Category' : 'Add New Category'}</h2>
                    <form action="${pageContext.request.contextPath}/admin/manageCategories" method="post">
                            <%-- Nếu là edit, action của form sẽ là "update" --%>
                            <%-- Nếu là add, action của form sẽ là "add" --%>
                        <input type="hidden" name="action" value="${not empty categoryToEdit ? 'update' : 'add'}">

                            <%-- Nếu là edit, cần có categoryId --%>
                        <c:if test="${not empty categoryToEdit}">
                            <input type="hidden" name="categoryId" value="${categoryToEdit.categoryId}">
                        </c:if>

                        <div class="form-group">
                            <label for="categoryName">Category Name:</label>
                            <input type="text" id="categoryName" name="categoryName"
                                   value="${fn:escapeXml(not empty categoryToEdit ? categoryToEdit.name : param.categoryName)}"
                                   class="form-control"
                                   required>
                                <%-- param.categoryName để giữ lại giá trị nếu add thất bại --%>
                        </div>
                        <div class="form-group">
                            <label for="categoryDescription">Description:</label>
                            <textarea id="categoryDescription"
                                      name="categoryDescription"
                                      class="form-control"
                                      rows="5"
                            >${fn:escapeXml(not empty categoryToEdit ? categoryToadmin.description : param.categoryDescription)}</textarea>
                        </div>
                        <div>
                            <button type="submit"
                                    class="btn btn-primary">${not empty categoryToEdit ? 'Update Category' : 'Add Category'}</button>
                            <a href="${pageContext.request.contextPath}/admin/manageCategories?action=list"
                               class="btn btn-link">Cancel</a>
                        </div>
                    </form>
            </c:if>


            <%-- Danh sách Categories --%>
            <%-- Chỉ hiển thị danh sách nếu không phải đang ở form add hoặc edit HOẶC nếu có categoryList (luôn hiển thị) --%>
            <c:if test="${not empty categoryList}">
                <table class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Miêu tả</th>
                        <th>Được tạo</th>
                        <th>Được cập nhật</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="category" items="${categoryList}">
                        <tr>
                            <td class="text-center">${category.categoryId}</td>
                            <td><c:out value="${category.name}"/></td>
                            <td><c:out value="${category.description}"/></td>
                            <td class="text-center">${category.createdAt}</td>
                            <td class="text-center">${category.updatedAt}</td>
                            <td class="text-center">
                                <a title="Sửa"
                                   href="${pageContext.request.contextPath}/admin/manageCategories?action=edit&id=${category.categoryId}"
                                   class="btn btn-sm btn-info"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <%-- Thêm confirm dialog cho delete --%>
                                <a title="Xóa"
                                   href="${pageContext.request.contextPath}/admin/manageCategories?action=delete&id=${category.categoryId}"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không? Các sản phẩm trong danh mục này có thể bị ảnh hưởng.');"
                                   class="btn btn-sm btn-danger"><i class="fa-solid fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categoryList}">
                        <tr>
                            <td colspan="6">No categories found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>

