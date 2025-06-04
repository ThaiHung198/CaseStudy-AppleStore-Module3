<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Giỏ Hàng - Apple Store</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    /* Thêm CSS tùy chỉnh cho trang giỏ hàng nếu cần */
    .cart-item-static img { width: 80px; margin-right: 15px; }
    .table th, .table td { vertical-align: middle; }
  </style>
</head>
<body>
<%-- Copy phần header menu từ home.jsp vào đây --%>
<header class="header-placeholder">
  <nav class="container">
    <ul>
      <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
      <%-- Giả sử allCategories được truyền từ một filter hoặc không cần ở đây --%>
      <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
      <li><a href="${pageContext.request.contextPath}/cart-view" id="cart-link" class="active">Giỏ Hàng (<span id="cart-count">2</span>)</a></li> <%-- Số tượng trưng --%>
      <li><a href="${pageContext.request.contextPath}/admin/adminLogin">Admin Login</a></li>
    </ul>
  </nav>
</header>

<div class="container mt-4">
  <h2>Giỏ Hàng Của Bạn (Tượng trưng)</h2>
  <hr>
  <c:choose>
    <c:when test="${true}"> <%-- Luôn hiển thị sản phẩm mẫu --%>
      <table class="table table-hover">
        <thead>
        <tr>
          <th scope="col" style="width: 15%;">Sản Phẩm</th>
          <th scope="col" style="width: 40%;">Tên</th>
          <th scope="col" style="width: 15%;">Đơn Giá</th>
          <th scope="col" style="width: 10%;">Số Lượng</th>
          <th scope="col" style="width: 20%;">Thành Tiền</th>
        </tr>
        </thead>
        <tbody>
        <tr class="cart-item-static">
          <td><img src="${pageContext.request.contextPath}/images/sample-product-1.jpg" alt="iPhone Mẫu"></td>
          <td>iPhone 1X Pro Max (Mẫu)</td>
          <td>25.000.000 VND</td>
          <td>1</td>
          <td>25.000.000 VND</td>
        </tr>
        <tr class="cart-item-static">
          <td><img src="${pageContext.request.contextPath}/images/sample-product-2.jpg" alt="iPad Mẫu"></td>
          <td>iPad Air Gen X (Mẫu)</td>
          <td>15.000.000 VND</td>
          <td>1</td>
          <td>15.000.000 VND</td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
          <td colspan="4" class="text-right"><strong>Tổng Cộng:</strong></td>
          <td colspan="1"><strong>40.000.000 VND</strong></td>
        </tr>
        </tfoot>
      </table>
      <div class="text-right mt-3">
        <a href="#" class="btn btn-primary">Tiến hành Thanh Toán (Tượng trưng)</a>
      </div>
    </c:when>
    <c:otherwise>
      <p>Giỏ hàng của bạn đang trống.</p>
    </c:otherwise>
  </c:choose>
</div>

<footer class="footer-placeholder mt-5">
  <p>© 2025 Your Apple Store. All rights reserved.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<%-- Không cần cart.js nếu chỉ là CSS tĩnh --%>
</body>
</html>