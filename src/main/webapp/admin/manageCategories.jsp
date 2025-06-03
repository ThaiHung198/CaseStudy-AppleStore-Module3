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
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
        .container { max-width: 900px; margin: auto; background-color: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1, h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .actions a { margin-right: 8px; text-decoration: none; padding: 5px 10px; border-radius: 4px; }
        .edit-btn { background-color: #ffc107; color: black; }
        .delete-btn { background-color: #dc3545; color: white; }
        .add-btn-container { margin-bottom: 20px; }
        .add-btn { padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; }

        .form-container { border: 1px solid #ccc; padding: 20px; margin-top: 20px; border-radius: 5px; background-color: #f9f9f9;}
        .form-container label { display: block; margin-bottom: 8px; font-weight: bold;}
        .form-container input[type="text"], .form-container textarea {
            width: calc(100% - 22px); padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px;
        }
        .form-container textarea { min-height: 80px; }
        .form-container input[type="submit"], .form-container .cancel-btn {
            padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;
        }
        .form-container input[type="submit"] { background-color: #28a745; color: white; }
        .form-container .cancel-btn { background-color: #6c757d; color: white; text-decoration: none; }

        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
        .success-message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error-message-jsp { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
<div class="container">
    <h1>Category Management</h1>
    <p><a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Back to Dashboard</a></p> <%-- Hoặc URL của servlet dashboard nếu có --%>

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


    <%-- Nút để hiển thị form Add New Category --%>
    <%-- Chỉ hiển thị nút "Add New" nếu không phải đang ở form add hoặc edit --%>
    <c:if test="${empty param.action or param.action eq 'list'}">
        <div class="add-btn-container">
            <a href="${pageContext.request.contextPath}/admin/manageCategories?action=add" class="add-btn">Add New Category</a>
        </div>
    </c:if>


    <%-- Form Thêm mới hoặc Sửa Category --%>
    <%-- Sẽ hiển thị nếu action là "add" hoặc "edit" (thông qua "categoryToEdit" được set) --%>
    <c:if test="${param.action eq 'add' or not empty categoryToEdit}">
        <div class="form-container">
            <h2>${not empty categoryToEdit ? 'Edit Category' : 'Add New Category'}</h2>
            <form action="${pageContext.request.contextPath}/admin/manageCategories" method="post">
                    <%-- Nếu là edit, action của form sẽ là "update" --%>
                    <%-- Nếu là add, action của form sẽ là "add" --%>
                <input type="hidden" name="action" value="${not empty categoryToEdit ? 'update' : 'add'}">

                    <%-- Nếu là edit, cần có categoryId --%>
                <c:if test="${not empty categoryToEdit}">
                    <input type="hidden" name="categoryId" value="${categoryToEdit.categoryId}">
                </c:if>

                <div>
                    <label for="categoryName">Category Name:</label>
                    <input type="text" id="categoryName" name="categoryName" value="${fn:escapeXml(not empty categoryToEdit ? categoryToEdit.name : param.categoryName)}" required>
                        <%-- param.categoryName để giữ lại giá trị nếu add thất bại --%>
                </div>
                <div>
                    <label for="categoryDescription">Description:</label>
                    <textarea id="categoryDescription" name="categoryDescription">${fn:escapeXml(not empty categoryToEdit ? categoryToadmin.description : param.categoryDescription)}</textarea>
                </div>
                <div>
                    <input type="submit" value="${not empty categoryToEdit ? 'Update Category' : 'Add Category'}">
                    <a href="${pageContext.request.contextPath}/admin/manageCategories?action=list" class="cancel-btn">Cancel</a>
                </div>
            </form>
        </div>
    </c:if>


    <%-- Danh sách Categories --%>
    <%-- Chỉ hiển thị danh sách nếu không phải đang ở form add hoặc edit HOẶC nếu có categoryList (luôn hiển thị) --%>
    <c:if test="${not empty categoryList}">
        <h2>Existing Categories</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Created At</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="category" items="${categoryList}">
                <tr>
                    <td>${category.categoryId}</td>
                    <td><c:out value="${category.name}"/></td>
                    <td><c:out value="${category.description}"/></td>
                    <td>${category.createdAt}</td>
                    <td>${category.updatedAt}</td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/admin/manageCategories?action=edit&id=${category.categoryId}" class="edit-btn">Edit</a>
                            <%-- Thêm confirm dialog cho delete --%>
                        <a href="${pageContext.request.contextPath}/admin/manageCategories?action=delete&id=${category.categoryId}"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không? Các sản phẩm trong danh mục này có thể bị ảnh hưởng.');" class="delete-btn">Delete</a>
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
</body>
</html>

