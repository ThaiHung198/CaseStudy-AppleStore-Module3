<%-- File: webapp/bootstrap/header.jsp --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">


<header>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
        <i class="fab fa-apple"></i> AppleStore
      </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavHeader" aria-controls="navbarNavHeader" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNavHeader">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item ${ (pageContext.request.servletPath eq '/home' or fn:endsWith(pageContext.request.servletPath, '/admin/home.jsp')) ? 'active' : '' }">
            <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
          </li>
          <c:if test="${not empty allCategories}">
            <li class="nav-item dropdown ${ pageContext.request.servletPath eq '/products' ? 'active' : '' }">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownCategoriesHeader" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Danh Mục
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdownCategoriesHeader">
                <c:forEach var="category" items="${allCategories}">
                  <a class="dropdown-item ${category.categoryId eq param.categoryId ? 'active' : ''}" href="${pageContext.request.contextPath}/products?categoryId=${category.categoryId}"><c:out value="${category.name}"/></a>
                </c:forEach>
              </div>
            </li>
          </c:if>
          <li class="nav-item ${ pageContext.request.servletPath eq '/contact' ? 'active' : '' }">
            <a class="nav-link" href= #"/contact"><i class="fa-solid fa-phone"></i> 0999888999</a>
          </li>
        </ul>
        <div class="navbar-nav mx-auto"> <%-- mx-auto để cố gắng căn giữa --%>
          <form class="form-inline" action="${pageContext.request.contextPath}/products" method="get" id="searchAndFilterForm">
            <input class="form-control form-control-sm mr-sm-2" type="search" name="searchKeyword"
                   placeholder="Tìm sản phẩm..." aria-label="Search"
                   value="${fn:escapeXml(param.searchKeyword)}" style="width: 130px;">
            <select name="priceRange" class="form-control form-control-sm mr-sm-2" style="width: 130px;">
              <option value="">Lọc theo giá</option>
              <option value="0-2000000" ${param.priceRange eq '0-2000000' ? 'selected' : ''}>Dưới 2 triệu</option>
              <option value="2000000-5000000" ${param.priceRange eq '2000000-5000000' ? 'selected' : ''}>2 - 5 triệu</option>
              <option value="5000000-10000000" ${param.priceRange eq '5000000-10000000' ? 'selected' : ''}>5 - 10 triệu</option>
              <option value="10000000-20000000" ${param.priceRange eq '10000000-20000000' ? 'selected' : ''}>10 - 20 triệu</option>
              <option value="20000000-" ${param.priceRange eq '20000000-' ? 'selected' : ''}>Trên 20 triệu</option>
            </select>

            <button class="btn btn-outline-light btn-sm" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
          </form>
        </div>
        <ul class="navbar-nav">
          <li class="nav-item ${ fn:endsWith(pageContext.request.servletPath, '/viewCart') or fn:endsWith(pageContext.request.servletPath, 'cart.jsp') ? 'active' : '' }">
            <a class="nav-link" href="${pageContext.request.contextPath}/viewCart" id="cart-link">
              <i class="fas fa-shopping-cart"></i> <span class="d-none d-lg-inline">Giỏ Hàng</span> (<span id="cart-count">${not empty totalCartItems ? totalCartItems : 0}</span>)
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminLogin">
              <i class="fas fa-user-shield"></i> <span class="d-none d-lg-inline">Đăng Nhập</span>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
<div style="padding-top: 70px;"></div> <%-- Đệm cho fixed-top navbar, điều chỉnh 70px nếu chiều cao navbar thay đổi --%>