 
--  Bảng Danh mục sản phẩm
CREATE TABLE IF NOT EXISTS DANH_MUC (
    MaDM INT PRIMARY KEY,
    TenDM VARCHAR(100) NOT NULL UNIQUE
);

--  Bảng Nhà cung cấp
CREATE TABLE IF NOT EXISTS NHA_CUNG_CAP (
    MaNCC INT PRIMARY KEY,
    TenNCC VARCHAR(150) NOT NULL,
    ThongTinLienHe VARCHAR(255)
);

--  Bảng Khách hàng
CREATE TABLE IF NOT EXISTS KHACH_HANG (
    MaKH INT PRIMARY KEY,
    TenKH VARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) UNIQUE, 
    Email VARCHAR(100) UNIQUE,
    DiaChi VARCHAR(255)
);

-- 4. Bảng Nhân viên
CREATE TABLE IF NOT EXISTS NHAN_VIEN (
    MaNV INT PRIMARY KEY,
    TenNV VARCHAR(100) NOT NULL,
    ViTri VARCHAR(50) DEFAULT N'Thu ngân', -- Ràng buộc DEFAULT
    NgayVaoLam DATE DEFAULT CURRENT_DATE
);

-- 5. Bảng Chương trình khuyến mãi
CREATE TABLE IF NOT EXISTS KHUYEN_MAI (
    MaKM INT PRIMARY KEY,
    TenKM VARCHAR(200) NOT NULL,
    MoTa VARCHAR(500),
    PhanTramGiam DECIMAL(5, 2) CHECK (PhanTramGiam >= 0 AND PhanTramGiam <= 100), -- Ràng buộc CHECK
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    CONSTRAINT CHK_NgayHopLe CHECK (NgayKetThuc >= NgayBatDau) -- Đảm bảo ngày kết thúc sau ngày bắt đầu
);

-- 6. Bảng Sản phẩm
CREATE TABLE IF NOT EXISTS SAN_PHAM (
    MaSP INT PRIMARY KEY,
    TenSP VARCHAR(200) NOT NULL,
    GiaHienTai DECIMAL(18, 2) NOT NULL CHECK (GiaHienTai >= 0),
    MaDM INT NOT NULL,
    MaNCC INT NOT NULL,
    FOREIGN KEY (MaDM) REFERENCES DANH_MUC(MaDM),
    FOREIGN KEY (MaNCC) REFERENCES NHA_CUNG_CAP(MaNCC)
);

-- 7. Bảng Đơn hàng
CREATE TABLE IF NOT EXISTS DON_HANG (
    MaDH INT PRIMARY KEY,
    NgayMua DATE DEFAULT CURRENT_TIMESTAMP,
    MaKH INT NOT NULL,
    MaNV INT NOT NULL,
    MaKM INT NULL, -- Cho phép NULL vì có thể đơn hàng không áp dụng khuyến mãi
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH),
    FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN(MaNV),
    FOREIGN KEY (MaKM) REFERENCES KHUYEN_MAI(MaKM)
);

-- 8. Bảng Chi tiết đơn hàng
CREATE TABLE IF NOT EXISTS CHI_TIET_DON_HANG (
    MaDH INT,
    MaSP INT,
    SoLuong INT NOT NULL DEFAULT 1 CHECK (SoLuong > 0),
    GiaTaiThoiDiemMua DECIMAL(18, 2) NOT NULL CHECK (GiaTaiThoiDiemMua >= 0),
    PRIMARY KEY (MaDH, MaSP), -- Khóa chính kết hợp từ 2 cột
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH),
    FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP)
);

INSERT INTO DANH_MUC VALUES 
(1, 'Đồ uống'), (2, 'Thực phẩm');

INSERT INTO NHA_CUNG_CAP VALUES
(1, 'Vinamilk', 'TP.HCM'),
(2, 'Acecook', 'Hà Nội');

INSERT INTO KHACH_HANG VALUES
(1, 'Nguyễn Văn An', '0901111111', 'a@gmail.com', 'Hà Nội'),
(2, 'Trần Thị Ba', '0902222222', 'b@gmail.com', 'Hà Nội');

-- UPDATE khach_hang
-- SET tenkh = 'Trần Thị Ba',
--     diachi = 'Hà Nội',
--     sodienthoai = '0902222222'
-- WHERE makh = 2;

INSERT INTO NHAN_VIEN VALUES
(1, 'Lê Văn Lương', 'Thu ngân', CURRENT_DATE);

INSERT INTO SAN_PHAM VALUES
(8, 'Nước suối Aquafina', 10000, 1, 1),
(9, 'Mì Hảo Hảo', 5000, 2, 2);

INSERT INTO DON_HANG VALUES
(1, CURRENT_DATE, 1, 1);

INSERT INTO CHI_TIET_DON_HANG VALUES
(1, 8, 2, 10000);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(15) UNIQUE
);
-- 1. Thêm cột email
ALTER TABLE suppliers
ADD email VARCHAR(100);

-- 2. Thêm supplier_id vào bảng SAN_PHAM
ALTER TABLE SAN_PHAM
ADD supplier_id INT;

-- Thêm khóa ngoại
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

-- 1. INSERT
INSERT INTO suppliers (supplier_id, supplier_name, contact_phone) VALUES
(1, 'Công ty TNHH ABC', '0901234567'),
(2, 'Công ty XYZ', '0912345678'),
(3, 'Nhà cung cấp Minh Long', '0987654321'),
(4, 'Công ty Hoàng Gia', '0978123456'),
(5, 'Công ty Đại Phát', '0965432187');
-- 2. UPDATE
UPDATE suppliers
SET contact_phone = '0911112222'
WHERE supplier_name = 'Công ty Thực phẩm Á Châu';

-- 3. DELETE
DELETE FROM SAN_PHAM
WHERE MaSP = 8;

-- 1. Tạo bảng test
CREATE TABLE test_table (
    id INT
);

-- 2. Xóa cột contact_phone
ALTER TABLE suppliers
DROP COLUMN contact_phone;

-- 3. Xóa bảng test
DROP TABLE test_table;

SELECT * FROM DANH_MUC;
SELECT * FROM NHA_CUNG_CAP;
SELECT * FROM KHACH_HANG;
SELECT * FROM NHAN_VIEN;
SELECT * FROM SAN_PHAM;
SELECT * FROM DON_HANG;
SELECT * FROM CHI_TIET_DON_HANG;
SELECT * FROM suppliers;