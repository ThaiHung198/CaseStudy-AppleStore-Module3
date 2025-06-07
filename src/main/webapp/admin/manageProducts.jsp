<%-- File: webapp/admin/manageProducts.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<c:if test="${empty sessionScope.adminLoggedIn}">
    <c:redirect url="${pageContext.request.contextPath}/admin/adminLogin.jsp"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>${not empty pageTitle ? pageTitle : 'Quản lý Sản phẩm'} - Admin</title>
    <%-- Link Bootstrap và Font Awesome --%>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"> <%-- Giả sử bạn dùng Font Awesome 5 --%>
    <%-- Link đến file CSS tùy chỉnh của bạn --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100"> <%-- Giúp footer ở cuối nếu trang ngắn --%>

<jsp:include page="/admin/includes/admin_header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/admin/includes/admin_sidebar.jsp" />

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 admin-main-content">
            <div class="card mt-3">
                <div class="card-header">
                    <h4 class="card-title d-flex justify-content-between align-items-center">
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" class="btn btn-link text-secondary p-0 mr-2" title="Quay lại Dashboard">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            Quản lý sản phẩm
                        </div>
                        <c:if test="${empty param.action or param.action eq 'list'}">
                            <a href="${pageContext.request.contextPath}/admin/manageProducts?action=add" class="btn btn-primary">
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

                    <%-- Form Thêm mới hoặc Sửa Product --%>
                    <c:if test="${param.action eq 'add' or not empty productToEdit}">
                        <div class="form-container border p-3 mb-4 bg-light rounded">
                            <h2>${not empty pageTitle ? pageTitle : (not empty productToEdit ? 'Chỉnh sửa Sản phẩm' : 'Thêm Sản phẩm mới')}</h2>
                            <form action="${pageContext.request.contextPath}/admin/manageProducts" method="post">
                                <input type="hidden" name="action" value="${not empty productToEdit ? 'update' : 'add'}">
                                <c:if test="${not empty productToEdit}">
                                    <input type="hidden" name="productId" value="${productToEdit.productId}">
                                </c:if>

                                <div class="form-group">
                                    <label for="productName">Tên Sản Phẩm:</label>
                                    <input type="text" id="productName" name="productName" class="form-control" value="${fn:escapeXml(not empty productToEdit ? productToEdit.name : param.productName)}" required>
                                </div>
                                <div class="form-group">
                                    <label for="productDescription">Mô tả:</label>
                                    <textarea id="productDescription" name="productDescription" class="form-control" rows="3">${fn:escapeXml(not empty productToEdit ? productToEdit.description : param.productDescription)}</textarea>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="productPrice">Giá:</label>
                                        <input type="number" id="productPrice" name="productPrice" class="form-control" step="0.01" min="0" value="${not empty productToEdit ? productToEdit.price : param.productPrice}" required>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="categoryId">Danh mục:</label>
                                        <select id="categoryId" name="categoryId" class="form-control" required>
                                            <option value="">-- Chọn Danh mục --</option>
                                            <c:forEach var="category" items="${categoryListForForm}">
                                                <option value="${category.categoryId}" ${ (not empty productToEdit and productToEdit.categoryId == category.categoryId) or (not empty param.categoryId and param.categoryId == category.categoryId) ? 'selected' : ''}>
                                                    <c:out value="${category.name}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="stockQuantity">Số lượng tồn kho:</label>
                                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control" min="0" value="${not empty productToEdit ? productToEdit.stockQuantity : (not empty param.stockQuantity ? param.stockQuantity : 0)}" required>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="imageUrl">URL Hình ảnh:</label>
                                        <input type="url" id="imageUrl" name="imageUrl" class="form-control" value="${fn:escapeXml(not empty productToEdit ? productToEdit.imageUrl : param.imageUrl)}">
                                    </div>
                                </div>
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="isFeatured" name="isFeatured" ${ (not empty productToEdit and productToEdit.isFeatured()) or (not empty param.isFeatured and param.isFeatured eq 'on') ? 'checked' : ''}>
                                    <label class="form-check-label" for="isFeatured">Là sản phẩm nổi bật?</label>
                                </div>
                                <button type="submit" class="btn btn-success">${not empty productToEdit ? 'Cập nhật' : 'Thêm Sản phẩm'}</button>
                                <a href="${pageContext.request.contextPath}/admin/manageProducts?action=list" class="btn btn-secondary">Hủy</a>
                            </form>
                        </div>
                    </c:if>

                    <%-- Danh sách Products --%>
                    <c:if test="${not empty productList}">
                        <h2 class="mt-4">Danh sách sản phẩm hiện có</h2>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover">
                                <thead class="thead-light">
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">Ảnh</th>
                                    <th>Tên</th>
                                    <th>Danh mục</th>
                                    <th class="text-right">Giá</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-center">Nổi bật</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="product" items="${productList}">
                                    <tr>
                                        <td class="text-center">${product.productId}</td>
                                        <td class="text-center">
                                            <c:if test="${not empty product.imageUrl}">
                                                <img src="${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.name)}"
                                                     style="width:50px; height:auto; object-fit: contain;">
                                            </c:if>
                                            <c:if test="${empty product.imageUrl}">
                                                <img src="${pageContext.request.contextPath}/images/placeholder.png" alt="No image"
                                                     style="width:50px; height:auto; object-fit: contain;">
                                            </c:if>
                                        </td>
                                        <td><c:out value="${product.name}"/></td>
                                        <td>
                                            <c:forEach var="cat" items="${categoryListAll}">
                                                <c:if test="${cat.categoryId == product.categoryId}">
                                                    <c:out value="${cat.name}"/>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td class="text-right"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/> VND</td>
                                        <td class="text-center">${product.stockQuantity}</td>
                                        <td class="text-center">
                                            <c:if test="${product.isFeatured()}"><span class="badge badge-success">Có</span></c:if>
                                            <c:if test="${not product.isFeatured()}"><span class="badge badge-secondary">Không</span></c:if>
                                        </td>
                                        <td class="text-center">
                                            <a title="Sửa"
                                               href="${pageContext.request.contextPath}/admin/manageProducts?action=edit&id=${product.productId}"
                                               class="btn btn-sm btn-info mr-1">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a title="Xóa"
                                               href="${pageContext.request.contextPath}/admin/manageProducts?action=delete&id=${product.productId}"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?');"
                                               class="btn btn-sm btn-danger">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty productList}">
                                    <tr>
                                        <td colspan="8" class="text-center">Không tìm thấy sản phẩm nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div> <%-- end card-body --%>
            </div> <%-- end card --%>
        </main>
    </div>
</div>

<%-- <jsp:include page="/admin/includes/admin_footer.jsp" /> --%>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>