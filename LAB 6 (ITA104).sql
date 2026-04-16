
-- Bài 1: Tổng quan thống kê về sản phẩm
-- -----------------------------------------
SELECT 
    COUNT(*) AS SoLuongSanPham,           
    AVG(GiaHienTai) AS GiaTrungBinh,      
    MIN(GiaHienTai) AS GiaThapNhat,       
    MAX(GiaHienTai) AS GiaCaoNhat         
FROM SAN_PHAM;

-- Bài 2: Phân tích nhà cung cấp
-- -----------------------------------------
SELECT 
    ncc.TenNCC AS TenNhaCungCap,
    COUNT(sp.MaSP) AS TongSanPham
FROM NHA_CUNG_CAP ncc
JOIN SAN_PHAM sp 
    ON ncc.MaNCC = sp.MaNCC
GROUP BY ncc.TenNCC
HAVING COUNT(sp.MaSP) > 1;

-- Bài 3: Xử lý ngày đặt hàng
-- -----------------------------------------
SELECT 
    MaDH AS order_id,
    TO_CHAR(NgayMua, 'DD/MM/YYYY') AS NgayMua
FROM DON_HANG
WHERE EXTRACT(YEAR FROM NgayMua) = 2026
  AND EXTRACT(MONTH FROM NgayMua) = 04;

-- Bài 4: Báo cáo khách hàng VIP
-- -----------------------------------------
SELECT 
    kh.TenKH AS TenKhachHang,
    SUM(ct.SoLuong * ct.GiaTaiThoiDiemMua) AS TongChiTieu
FROM KHACH_HANG kh
JOIN DON_HANG dh 
    ON kh.MaKH = dh.MaKH
JOIN CHI_TIET_DON_HANG ct 
    ON dh.MaDH = ct.MaDH
GROUP BY kh.TenKH
HAVING SUM(ct.SoLuong * ct.GiaTaiThoiDiemMua) > 100000
ORDER BY TongChiTieu DESC;