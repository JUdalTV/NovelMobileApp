const fs = require('fs');
const path = require('path');
const multer = require('multer');

// Đường dẫn thư mục uploads
const uploadsDir = path.join(process.cwd(), 'public', 'uploads');

// Tạo thư mục uploads nếu chưa tồn tại
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

class LocalStorage {
  constructor() {
    // Sửa baseUrl để sử dụng IP thay vì localhost
    const ipAddress = process.env.IP_ADDRESS || '192.168.1.10'; // Sử dụng IP trong mạng LAN
    const port = process.env.PORT || 5000;
    this.baseUrl = process.env.BASE_URL || `http://${ipAddress}:${port}`;
    this.uploadsDir = uploadsDir;
    
    console.log(`LocalStorage initialized with baseUrl: ${this.baseUrl}`);
  }

  async uploadFile(file, destination) {
    try {
      // Tạo thư mục con nếu cần
      const destDir = path.dirname(path.join(this.uploadsDir, destination));
      if (!fs.existsSync(destDir)) {
        fs.mkdirSync(destDir, { recursive: true });
      }

      // Ghi file
      const filePath = path.join(this.uploadsDir, destination);
      
      return new Promise((resolve, reject) => {
        fs.writeFile(filePath, file.buffer, (err) => {
          if (err) {
            console.error('Error saving file:', err);
            reject(err);
          } else {
            // Trả về đường dẫn public đến file
            const publicUrl = `${this.baseUrl}/uploads/${destination}`;
            resolve(publicUrl);
          }
        });
      });
    } catch (error) {
      console.error('Error uploading file locally:', error);
      throw error;
    }
  }

  async deleteFile(fileUrl) {
    try {
      // Lấy đường dẫn file từ URL
      const urlPrefix = `${this.baseUrl}/uploads/`;
      
      // Kiểm tra URL có đúng định dạng hay không
      if (!fileUrl.startsWith(urlPrefix)) {
        console.warn('Invalid file URL format');
        return true;
      }
      
      const relativePath = fileUrl.substring(urlPrefix.length);
      const filePath = path.join(this.uploadsDir, relativePath);
      
      // Kiểm tra file tồn tại
      if (!fs.existsSync(filePath)) {
        console.warn(`File ${relativePath} does not exist in storage`);
        return true;
      }
      
      // Xóa file
      fs.unlinkSync(filePath);
      return true;
    } catch (error) {
      console.error('Error deleting file locally:', error);
      throw error;
    }
  }
}

module.exports = {
  LocalStorage
};
