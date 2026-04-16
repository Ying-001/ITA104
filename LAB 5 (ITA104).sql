-- Hiển thị các sản phẩm đã được bán
SELECT 
    ct.MaDH AS order_id,
    sp.TenSP AS product_name,
    ct.SoLuong AS quantity,
    ct.GiaTaiThoiDiemMua AS price
FROM CHI_TIET_DON_HANG ct
INNER JOIN SAN_PHAM sp 
    ON ct.MaSP = sp.MaSP;
	
-- Liệt kê tất cả khách hàng (kể cả chưa mua)
SELECT 
    kh.TenKH AS full_name,
    dh.MaDH AS order_id
FROM KHACH_HANG kh
LEFT JOIN DON_HANG dh 
    ON kh.MaKH = dh.MaKH;

-- Liệt kê tất cả sản phẩm (kể cả chưa bán)
SELECT 
    sp.TenSP AS product_name,
    ct.MaDH AS order_id
FROM CHI_TIET_DON_HANG ct
RIGHT JOIN SAN_PHAM sp 
    ON ct.MaSP = sp.MaSP;

-- Danh bạ chung (không trùng)
SELECT 
    TenKH AS ContactName,
    SoDienThoai AS PhoneNumber
FROM KHACH_HANG

UNION

SELECT 
    TenNCC AS ContactName,
    ThongTinLienHe AS PhoneNumber
FROM NHA_CUNG_CAP;

-- Sản phẩm của 'Công ty Sữa Việt Nam'
SELECT 
    TenSP AS product_name,
    GiaHienTai AS price
FROM SAN_PHAM
WHERE MaNCC IN (
    SELECT MaNCC
    FROM NHA_CUNG_CAP
    WHERE TenNCC = 'Công ty Sữa Việt Nam'
);

-- Hiển thị giá sản phẩm + giá trung bình
SELECT 
    TenSP AS product_name,
    GiaHienTai AS price,
    (SELECT AVG(GiaHienTai) FROM SAN_PHAM) AS average_price
FROM SAN_PHAM;

-- Tìm đơn hàng có tổng tiền > 50000
SELECT *
FROM (
    SELECT 
        MaDH,
        SUM(SoLuong * GiaTaiThoiDiemMua) AS total_amount
    FROM CHI_TIET_DON_HANG
    GROUP BY MaDH
) AS temp
WHERE total_amount > 50000;

-- Nhà cung cấp có ít nhất 1 sản phẩm
SELECT TenNCC AS supplier_name
FROM NHA_CUNG_CAP ncc
WHERE EXISTS (
    SELECT 1
    FROM SAN_PHAM sp
    WHERE sp.MaNCC = ncc.MaNCC
);
