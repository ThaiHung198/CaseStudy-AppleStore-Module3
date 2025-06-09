package com.example.casestady.dao;

import com.example.casestady.model.Category;
import com.example.casestady.model.Product;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
public class ProductDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    public ProductDAO() {
        super();
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setImageUrl(rs.getString("image_url"));
        product.setisFeatured(rs.getBoolean("is_featured"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));
        return product;
    }

    //Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.* FROM Products p ORDER BY p.name ASC";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return products;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi lấy tất cả sản phẩm", ex);
        }
        return products;
    }
    // Lấy sản phẩm theo Category ID

    public List<Product> getProductsByCategoryId(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ? ORDER BY name ASC";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return products;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi lấy sản phẩm theo category ID", ex);
        }
        return products;
    }

    // lấy các sản phẩm nổi bật
    public List<Product> getFeaturedProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE is_featured = TRUE ORDER BY name ASC";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return products;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi lấy sản phẩm nổi bật", ex);
        }
        return products;
    }

    // Lấy 1 sản phẩm bằng Product ID
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return null;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi lấy sản phẩm theo ID", ex);
        }
        return null;
    }

    // Thêm 1 sản phẩm mới
    // Trả về ID của sản phẩm mới được tạo, hoặc -1 nếu thất bại
    public int addProduct(Product product) {
        String sql = "INSERT INTO Products (category_id, name, description, price, image_url, is_featured, stock_quantity) " + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return -1;
            }
            PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setBigDecimal(4, product.getPrice());
            ps.setString(5, product.getImageUrl());
            ps.setBoolean(6, product.isFeatured());
            ps.setInt(7, product.getStockQuantity());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);// Trả về ID được tạo
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi thêm sản phẩm mới", ex);
        }
        return -1; // thêm thất bại
    }

    // Cập nhật 1 sản phẩm
    //Trả về true nếu cập nhật thành công
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET category_id = ?,name = ?,description = ?,price = ?,image_url = ?,is_featured = ?,stock_quantity = ? WHERE product_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setBigDecimal(4, product.getPrice());
            ps.setString(5, product.getImageUrl());
            ps.setBoolean(6, product.isFeatured());
            ps.setInt(7, product.getStockQuantity());
            ps.setInt(8, product.getProductId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi cập nhật sản phẩm", ex);
        }
        return false;
    }

    // Xóa 1 sản phẩm
    //Trả về true nếu Xóa thành công
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE product_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Lỗi: Kết nối CSDL chưa được khởi tạo hoặc đã đóng!");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi SQL khi xóa sản phẩm", ex);
        }
        return false;
    }
    public List<Product> searchAndFilterProducts(String keyword, BigDecimal minPrice, BigDecimal maxPrice, Integer categoryId) {
        List<Product> products = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM Products WHERE 1=1"); // Bắt đầu với điều kiện luôn đúng

        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append(" AND LOWER(name) LIKE LOWER(?)");
        }
        if (minPrice != null) {
            sqlBuilder.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sqlBuilder.append(" AND price <= ?");
        }
        if (categoryId != null && categoryId > 0) {
            sqlBuilder.append(" AND category_id = ?");
        }
        sqlBuilder.append(" ORDER BY name ASC");

        try (PreparedStatement ps = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (minPrice != null) {
                ps.setBigDecimal(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setBigDecimal(paramIndex++, maxPrice);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs)); // Giả sử bạn có hàm này
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Error during product search/filter", ex);
        }
        return products;
    }


    public static void main(String[] args) {
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO(); // Giả sử CategoryDAO đã có và hoạt động
        List<Category> categories = categoryDAO.getAllCategories();

        System.out.println("Số lượng categories ban đầu: " + categories.size());

        int testCategoryId = -1;          // Sẽ lưu ID của category dùng để test
        String testCategoryName = "";     // Sẽ lưu tên của category dùng để test
        int idCategoryTamDeXoa = -1;      // Sẽ lưu ID của category tạm được tạo (nếu có) để xóa sau

        if (categories.isEmpty()) {
            System.out.println(">>> Khối categories.isEmpty() được thực thi.");
            System.out.println("Cần có ít nhất một danh mục để test sản phẩm. Vui lòng thêm danh mục trước.");
            Category temCat = new Category();
            // Đặt tên cụ thể để dễ nhận biết là category tạm
            temCat.setName("Danh Mục Tạm Thời Cho Test ProductDAO");
            temCat.setDescription("Dùng cho test product trong ProductDAO.main()");

            int tempCatIdReturned = categoryDAO.addCategory(temCat);
            System.out.println("Đã thử thêm Category tạm, ID nhận được từ addCategory: " + tempCatIdReturned);

            if (tempCatIdReturned != -1) {
                idCategoryTamDeXoa = tempCatIdReturned; // QUAN TRỌNG: Lưu lại ID của category tạm vừa tạo
                Category newlyAddedCat = categoryDAO.getCategoryById(tempCatIdReturned);
                if (newlyAddedCat != null) {
                    // categories.add(newlyAddedCat); // Không cần add vào list này nữa vì ta đã có ID
                    testCategoryId = newlyAddedCat.getCategoryId();
                    testCategoryName = newlyAddedCat.getName();
                    System.out.println("Đã tạo và sử dụng Category tạm: " + newlyAddedCat.getName() + " với ID: " + newlyAddedCat.getCategoryId());
                } else {
                    System.err.println("LỖI: Không thể lấy lại Category tạm vừa thêm bằng getCategoryById với ID: " + tempCatIdReturned);
                    // Nếu không lấy được category vừa tạo, thì không thể test sản phẩm, nên dừng lại
                    if (idCategoryTamDeXoa != -1) { // Cố gắng xóa category tạm nếu nó đã được tạo ID
                        categoryDAO.deleteCategory(idCategoryTamDeXoa);
                        System.out.println("Đã cố gắng dọn dẹp Category tạm với ID: " + idCategoryTamDeXoa);
                    }
                    return;
                }
            } else {
                System.err.println("LỖI: Thêm Category tạm thất bại (addCategory trả về -1)!");
                return; // Dừng lại nếu không tạo được category
            }
        } else {
            // Nếu đã có category, lấy category đầu tiên để test
            testCategoryId = categories.get(0).getCategoryId();
            testCategoryName = categories.get(0).getName();
        }

        // Kiểm tra lại xem đã có category ID hợp lệ để test chưa
        if (testCategoryId == -1) {
            System.err.println("LỖI: Không có Category ID hợp lệ để tiến hành test sản phẩm!");
            // Cố gắng dọn dẹp category tạm nếu nó đã được tạo
            if (idCategoryTamDeXoa != -1) {
                categoryDAO.deleteCategory(idCategoryTamDeXoa);
                System.out.println("Đã cố gắng dọn dẹp Category tạm với ID (do lỗi thiết lập test): " + idCategoryTamDeXoa);
            }
            return;
        }

        System.out.println("Sử dụng Category ID: " + testCategoryId + " (" + testCategoryName + ") để test.");

        System.out.println("---Test Thêm Sản Phẩm Mới---");
        Product newProduct = new Product();
        newProduct.setCategoryId(testCategoryId); // Sử dụng category ID đã xác định
        newProduct.setName("Sản Phẩm Test " + System.currentTimeMillis());
        newProduct.setDescription("Mô tả cho sản phẩm test.");
        newProduct.setPrice(new BigDecimal("199.99"));
        newProduct.setImageUrl("images/test_product.jpg");
        newProduct.setisFeatured(true);
        newProduct.setStockQuantity(50);
        System.out.println("ĐANG THỬ THÊM SẢN PHẨM với Category ID: " + newProduct.getCategoryId() + " cho sản phẩm: " + newProduct.getName());
        int newProductId = productDAO.addProduct(newProduct);

        if (newProductId != -1) {
            System.out.println("Đã thêm sản phẩm mới với ID: " + newProductId + " và Tên: " + newProduct.getName());

            System.out.println("\n--- Test Lấy sản phẩm Vừa thêm---");
            Product fetchedProduct = productDAO.getProductById(newProductId);
            if (fetchedProduct != null) {
                System.out.println("Lấy được sản phẩm: " + fetchedProduct.getName() + ", Giá: " + fetchedProduct.getPrice());
            } else {
                System.out.println("Không tìm thấy sản phẩm với ID: " + newProductId);
            }

            if (fetchedProduct != null) { // Chỉ thực hiện cập nhật/xóa nếu sản phẩm được lấy thành công
                System.out.println("\n--- Test Cập Nhật Sản Phẩm---");
                fetchedProduct.setName(fetchedProduct.getName() + " (Đã cập nhật)");
                fetchedProduct.setPrice(new BigDecimal("249.99"));
                boolean updated = productDAO.updateProduct(fetchedProduct);
                if (updated) {
                    System.out.println("Cập nhật sản phẩm ID " + fetchedProduct.getProductId() + " Thành Công.");
                    Product updatedProductCheck = productDAO.getProductById(fetchedProduct.getProductId());
                    if (updatedProductCheck != null) {
                        System.out.println("Tên mới: " + updatedProductCheck.getName() + ", Giá mới: " + updatedProductCheck.getPrice());
                    }
                } else {
                    System.out.println("Cập nhật sản phẩm thất bại.");
                }
            }

            System.out.println("\n---Test Lấy Tất Cả Sản Phẩm ---");
            List<Product> allProducts = productDAO.getAllProducts();
            System.out.println("Tổng số sản phẩm: " + allProducts.size());
            for (Product p : allProducts) {
                System.out.println("-ID: " + p.getProductId() + ", Tên: " + p.getName());
            }

            System.out.println("\n--- Test Lấy sản phẩm theo Category ID: " + testCategoryId + "---");
            List<Product> productsByCategory = productDAO.getProductsByCategoryId(testCategoryId);
            System.out.println("Số sản phẩm trong category '" + testCategoryName + "': " + productsByCategory.size());
            for (Product p : productsByCategory) {
                System.out.println("- ID: " + p.getProductId() + ", Tên: " + p.getName());
            }

            System.out.println("\n---Test Lấy Sản Phẩm Nổi Bật ---");
            List<Product> featureProducts = productDAO.getFeaturedProducts();
            System.out.println("Số sản phẩm nổi bật: " + featureProducts.size());
            for (Product p : featureProducts) {
                System.out.println("- ID: " + p.getProductId() + ", Tên: " + p.getName() + ", Nổi bật: " + p.isFeatured());
            }

            System.out.println("\n--- Test Xóa Sản Phẩm ---");
            boolean deleted = productDAO.deleteProduct(newProductId);
            if (deleted) {
                System.out.println("Đã xóa sản phẩm với ID: " + newProductId);
                Product deletedProductCheck = productDAO.getProductById(newProductId);
                if (deletedProductCheck == null) {
                    System.out.println("Xác nhận: Sản phẩm không còn tồn tại.");
                } else {
                    System.out.println("Lỗi: Sản phẩm vẫn còn tồn tại sau khi xóa.");
                }
            } else {
                System.out.println("Xóa sản phẩm thất bại.");
            }

        } else {
            System.out.println("Thêm sản phẩm mới thất bại.");
        }

        // Xóa danh mục tạm nếu nó đã được tạo trong lần chạy main() này
        if (idCategoryTamDeXoa != -1) {
            System.out.println("\n--- Dọn dẹp Category tạm ---");
            boolean catDeleted = categoryDAO.deleteCategory(idCategoryTamDeXoa);
            if (catDeleted) {
                System.out.println("Đã xóa thành công Category tạm với ID: " + idCategoryTamDeXoa);
            } else {
                System.err.println("LỖI: Không xóa được Category tạm với ID: " + idCategoryTamDeXoa);
            }
        }

        // Đóng kết nối nếu DBContext của bạn có phương thức close()
        // productDAO.closeConnection(); // Hoặc tương tự
        // categoryDAO.closeConnection();
    }
    // Trong ProductDAO.java
    public boolean updateStockQuantity(int productId, int newStockQuantity) {
        String sql = "UPDATE Products SET stock_quantity = ? WHERE product_id = ?";
        try {
            if (connection == null || connection.isClosed()) {
                LOGGER.log(Level.SEVERE, "Kết nối cơ sở dữ liệu chưa được khởi tạo hoặc đóng.");
                return false;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newStockQuantity);
            ps.setInt(2, productId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL khi cập nhật số lượng hàng tồn kho cho ID sản phẩm: " + productId, ex);
        }
        return false;
    }

}
