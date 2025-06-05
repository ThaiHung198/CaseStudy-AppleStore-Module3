package com.example.casestady.util; // Đảm bảo package đúng

import com.example.casestady.model.CartItem;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

public class CartUtil {

    /**
     * Tính tổng số lượng của tất cả các sản phẩm trong giỏ hàng (từ HttpSession).
     * Đồng thời đặt giá trị này vào request attribute "totalCartItems".
     *
     * @param request HttpServletRequest để lấy session và đặt attribute.
     * @return Tổng số lượng sản phẩm trong giỏ hàng.
     */
    public static int getTotalItemsInCart(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới nếu không có
        int totalCartItems = 0;

        if (session != null) {
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            if (cart != null) {
                for (CartItem item : cart.values()) {
                    totalCartItems += item.getQuantity();
                }
            }
        }
        request.setAttribute("totalCartItems", totalCartItems); // Đặt vào request scope
        return totalCartItems; // Trả về giá trị để có thể dùng nếu cần
    }


    public static Map<Integer, CartItem> getCartFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            if (cart != null) {
                return cart;
            }
        }
        return new HashMap<>(); // Trả về map rỗng nếu không có giỏ hàng
    }

}