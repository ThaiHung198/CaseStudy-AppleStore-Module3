package com.example.casestady.controller;

import com.example.casestady.dao.AdminDAO;
import com.example.casestady.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = "/admin/adminLogin")
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // false: không tạo session mới nếu chưa có
        if (session != null && session.getAttribute("adminLoggedIn") != null){
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
            return;
        }
        request.getRequestDispatcher("/admin/adminLogin.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{
        String usernameInput = request.getParameter("username");
        String passwordInput = request.getParameter("password");

        if (usernameInput == null || usernameInput.isEmpty() || passwordInput == null || passwordInput.isEmpty()){
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/admin/adminLogin.jsp").forward(request, response);
            return;
        }
        Admin adminFromDB = adminDAO.getAdminByUsername(usernameInput);
        if (adminFromDB != null && adminFromDB.getPassword().equals(passwordInput)){
            // đăng nhập thành công

            // Tạo session mới nếu chưa có, hoặc lấy session hiện tại
            HttpSession session = request.getSession();
            session.setAttribute("adminLoggedIn", adminFromDB);
            session.setMaxInactiveInterval(30*60);
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
        }else {
            // đăng nhập thất bại
            request.setAttribute("thông báo lỗi", "Tên người dùng hoặc mật khẩu không hợp lệ.");
            request.getRequestDispatcher("/admin/adminLogin.jsp").forward(request, response);
        }
    }
    @Override
    public String getServletInfo() {
        return "Xử lý các yêu cầu đăng nhập của quản trị viên";
    }
}
