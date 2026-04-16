
-- Bài 1: So sánh GROUP BY và Window Function

-- Cách 1: GROUP BY (sai mục tiêu)
-- => Mỗi sản phẩm chỉ còn 1 dòng riêng lẻ
SELECT 
    TenSP,
    AVG(GiaHienTai) AS GiaTrungBinh
FROM SAN_PHAM
GROUP BY TenSP;

-- Cách 2: Window Function (đúng)
SELECT 
    TenSP,
    GiaHienTai,
    AVG(GiaHienTai) OVER () AS GiaTrungBinhToanBo
FROM SAN_PHAM;

-- Bài 2: PARTITION BY theo danh mục
ALTER TABLE SAN_PHAM 
ADD COLUMN category VARCHAR(50);

SELECT 
    category,
    TenSP,
    GiaHienTai,
    AVG(GiaHienTai) OVER (PARTITION BY category) AS GiaTrungBinhTheoDanhMuc
FROM SAN_PHAM;

-- Bài 3: Xếp hạng sản phẩm


SELECT 
    TenSP,
    GiaHienTai,
    ROW_NUMBER() OVER (ORDER BY GiaHienTai DESC) AS row_num,
    RANK() OVER (ORDER BY GiaHienTai DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY GiaHienTai DESC) AS dense_rank_num
FROM SAN_PHAM;

-- Bài 4: Tổng lũy kế doanh thu theo ngày

-- Bước 1: Tính doanh thu theo ngày
WITH daily_revenue AS (
    SELECT 
        dh.NgayMua,
        SUM(ct.SoLuong * ct.GiaTaiThoiDiemMua) AS TongDoanhThuNgay
    FROM DON_HANG dh
    JOIN CHI_TIET_DON_HANG ct 
        ON dh.MaDH = ct.MaDH
    GROUP BY dh.NgayMua
)
-- Bước 2: Tính tổng lũy kế
SELECT 
    NgayMua,
    TongDoanhThuNgay,
    SUM(TongDoanhThuNgay) OVER (ORDER BY NgayMua) AS TongLuyKe
FROM daily_revenue;

