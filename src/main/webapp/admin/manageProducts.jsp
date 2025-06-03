<%--
  Created by IntelliJ IDEA.
  User: thaih
  Date: 03/06/2025
  Time: 1:45 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>${not empty pageTitle ? pageTitle : 'Manage Products'} - Admin</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
        .container { max-width: 1000px; margin: auto; background-color: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1, h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 0.9em; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #e9ecef; }
        .actions a { margin-right: 5px; text-decoration: none; padding: 4px 8px; border-radius: 3px; font-size: 0.9em;}
        .edit-btn { background-color: #ffc107; color: black; }
        .delete-btn { background-color: #dc3545; color: white; }
        .add-btn-container { margin-bottom: 20px; }
        .add-btn { padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; }

        .form-container { border: 1px solid #ccc; padding: 20px; margin-top: 20px; border-radius: 5px; background-color: #f9f9f9;}
        .form-container label { display: block; margin-bottom: 6px; font-weight: bold;}
        .form-container input[type="text"],
        .form-container input[type="number"],
        .form-container input[type="url"],
        .form-container textarea,
        .form-container select {
            width: calc(100% - 22px); padding: 8px; margin-bottom: 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
        }
        .form-container textarea { min-height: 70px; }
        .form-container input[type="checkbox"] { margin-right: 5px; vertical-align: middle; }
        .form-container input[type="submit"], .form-container .cancel-btn {
            padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;
        }
        .form-container input[type="submit"] { background-color: #28a745; color: white; }
        .form-container .cancel-btn { background-color: #6c757d; color: white; text-decoration: none; display: inline-block; }

        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
        .success-message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error-message-jsp { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .product-image-thumbnail { max-width: 50px; max-height: 50px; }
    </style>
</head>
<body>
<div class="container">
    <h1>Quản lý sản phẩm</h1>
    <p><a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Back to Dashboard</a></p>

    <c:if test="${not empty sessionScope.successMessage}">
        <p class="message success-message">${sessionScope.successMessage}</p>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <p class="message error-message-jsp">${sessionScope.errorMessage}</p>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.errorMessage}">
        <p class="message error-message-jsp">${requestScope.errorMessage}</p>
    </c:if>

    <c:if test="${empty param.action or param.action eq 'list'}">
        <div class="add-btn-container">
            <a href="${pageContext.request.contextPath}/admin/manageProducts?action=add" class="add-btn">Thêm Sản Phẩm Mới</a>
        </div>
    </c:if>

    <c:if test="${param.action eq 'add' or not empty productToEdit}">
        <div class="form-container">
            <h2>${not empty pageTitle ? pageTitle : (not empty productToEdit ? 'Edit Product' : 'Add New Product')}</h2>
            <form action="${pageContext.request.contextPath}/admin/manageProducts" method="post">
                <input type="hidden" name="action" value="${not empty productToEdit ? 'update' : 'add'}">
                <c:if test="${not empty productToEdit}">
                    <input type="hidden" name="productId" value="${productToEdit.productId}">
                </c:if>

                <div>
                    <label for="productName">Tên Sản Phẩm:</label>
                    <input type="text" id="productName" name="productName" value="${fn:escapeXml(not empty productToEdit ? productToEdit.name : param.productName)}" required>
                </div>
                <div>
                    <label for="productDescription">Miêu Tả Sản Phẩm:</label>
                    <textarea id="productDescription" name="productDescription">${fn:escapeXml(not empty productToEdit ? productToEdit.description : param.productDescription)}</textarea>
                </div>
                <div>
                    <label for="productPrice">Giá Sản Phẩm:</label>
                    <input type="number" id="productPrice" name="productPrice" step="0.01" min="0" value="${not empty productToEdit ? productToEdit.price : param.productPrice}" required>
                </div>
                <div>
                    <label for="categoryId">Loại:</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="category" items="${categoryListForForm}">
                            <option value="${category.categoryId}" ${ (not empty productToEdit and productToEdit.categoryId == category.categoryId) or (not empty param.categoryId and param.categoryId == category.categoryId) ? 'selected' : ''}>
                                <c:out value="${category.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label for="stockQuantity">Số Lượng Hàng Tồn Kho:</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" min="0" value="${not empty productToEdit ? productToEdit.stockQuantity : (not empty param.stockQuantity ? param.stockQuantity : 0)}" required>
                </div>
                <div>
                    <label for="imageUrl">Image URL:</label>
                    <input type="url" id="imageUrl" name="imageUrl" value="${fn:escapeXml(not empty productToEdit ? productToEdit.imageUrl : param.imageUrl)}">
                </div>
                <div>
                    <label for="isFeatured">
                        <input type="checkbox" id="isFeatured" name="isFeatured" ${ (not empty productToEdit and productToEdit.isFeatured()) or (not empty param.isFeatured and param.isFeatured eq 'on') ? 'checked' : ''}>
                        Được Nổi bật?
                    </label>
                </div>
                <div>
                    <input type="submit" value="${not empty productToEdit ? 'Update Product' : 'Thêm'}">
                    <a href="${pageContext.request.contextPath}/admin/manageProducts?action=list" class="cancel-btn">Cancel</a>
                </div>
            </form>
        </div>
    </c:if>

    <c:if test="${not empty productList}">
        <h2>Existing Products</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Featured</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${productList}">
                <tr>
                    <td>${product.productId}</td>
                    <td>
                        <c:if test="${not empty product.imageUrl}">
                            <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}" class="product-image-thumbnail">
                        </c:if>
                    </td>
                    <td><c:out value="${product.name}"/></td>
                    <td>
                            <%-- Tìm tên category từ categoryListAll (truyền từ servlet) --%>
                        <c:forEach var="cat" items="${categoryListAll}">
                            <c:if test="${cat.categoryId == product.categoryId}">
                                <c:out value="${cat.name}"/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td><c:out value="${product.price}"/></td>
                    <td>${product.stockQuantity}</td>
                    <td>${product.isFeatured() ? 'Yes' : 'No'}</td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/admin/manageProducts?action=edit&id=${product.productId}" class="edit-btn">Edit</a>
                        <a href="${pageContext.request.contextPath}/admin/manageProducts?action=delete&id=${product.productId}"
                           onclick="return confirm('Are you sure you want to delete this product?');" class="delete-btn">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty productList}">
                <tr>
                    <td colspan="8">No products found.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </c:if>
</div>
</body>
</html>

