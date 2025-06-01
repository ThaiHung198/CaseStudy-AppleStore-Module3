<%--
  Created by IntelliJ IDEA.
  User: thaih
  Date: 01/06/2025
  Time: 6:01 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Thêm dòng này để sử dụng JSTL Core tags (như c:if) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Login</title>
  <style>
    body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f4f4; margin: 0; }
    .login-container { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 15px rgba(0,0,0,0.1); width: 320px; }
    .login-container h2 { text-align: center; margin-bottom: 20px; color: #333; }
    .login-container label { display: block; margin-bottom: 8px; color: #555; }
    .login-container input[type="text"],
    .login-container input[type="password"] { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    .login-container input[type="submit"] { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    .login-container input[type="submit"]:hover { background-color: #0056b3; }
    .error-message { color: red; text-align: center; margin-bottom: 15px; font-weight: bold; }
  </style>
</head>
<body>
<div class="login-container">
  <h2>Admin Login</h2>

  <%--
      Sử dụng JSTL <c:if> để kiểm tra xem attribute "errorMessage" có tồn tại và không rỗng không.
      Nếu có, thì mới hiển thị thẻ <p> chứa thông báo lỗi.
      ${errorMessage} là Expression Language để lấy giá trị của attribute "errorMessage"
      mà AdminLoginServlet sẽ đặt vào request scope nếu đăng nhập thất bại.
  --%>
  <c:if test="${not empty requestScope.errorMessage}">
    <p class="error-message">${requestScope.errorMessage}</p>
  </c:if>
  <%--
      requestScope.errorMessage là cách rõ ràng để chỉ định rằng bạn đang tìm attribute
      trong request scope. Nếu bạn chỉ dùng ${errorMessage}, JSP sẽ tìm trong các scope
      theo thứ tự: page, request, session, application. Trong trường hợp này,
      ${errorMessage} cũng thường hoạt động đúng.
  --%>

  <%--
      Form sẽ gửi dữ liệu đến URL "/tên-context-của-bạn/adminLogin"
      Ví dụ, nếu context path của bạn là "CaseStady_AppleStore", URL sẽ là "/CaseStady_AppleStore/adminLogin"
      URL này sẽ được map tới AdminLoginServlet.
  --%>
  <form action="${pageContext.request.contextPath}/adminLogin" method="post">
    <div>
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" required value="admin"> <%-- Thêm value để tiện test --%>
    </div>
    <div>
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required value="admin123"> <%-- Thêm value để tiện test --%>
    </div>
    <div>
      <input type="submit" value="Login">
    </div>
  </form>
</div>
</body>
</html>
