const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { ValidationError } = require('../../domain/errors');

// Kiểm tra loại file ảnh
const imageFileFilter = (req, file, cb) => {
  // Cho phép chỉ các file ảnh
  if (file.mimetype.startsWith('image')) {
    cb(null, true);
  } else {
    cb(new ValidationError('Chỉ chấp nhận file ảnh', ['File không hợp lệ']), false);
  }
};

// Kiểm tra loại file văn bản
const documentFileFilter = (req, file, cb) => {
  console.log('File upload details:', {
    fieldname: file.fieldname,
    originalname: file.originalname, 
    mimetype: file.mimetype
  });
  
  // Cho phép các file doc, docx và txt
  const allowedMimes = [
    'application/msword', // doc
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // docx
    'text/plain', // txt
    'application/octet-stream' // Một số client có thể gửi docx với mime type này
  ];
  
  if (allowedMimes.includes(file.mimetype) || 
      file.originalname.endsWith('.docx') || 
      file.originalname.endsWith('.doc') || 
      file.originalname.endsWith('.txt')) {
    cb(null, true);
  } else {
    cb(new ValidationError('Chỉ chấp nhận file .doc, .docx và .txt', ['File không hợp lệ']), false);
  }
};

// Tạo middleware upload với memory storage để sau đó có thể upload lên cloud
const uploadImage = (fieldName, destination, fileStorage) => {
  const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
      fileSize: 5 * 1024 * 1024 // 5MB
    },
    fileFilter: imageFileFilter
  }).single(fieldName);

  return (req, res, next) => {
    upload(req, res, async (err) => {
      if (err) {
        if (err instanceof multer.MulterError) {
          return next(new ValidationError('Lỗi upload file', [err.message]));
        }
        return next(err);
      }

      // Nếu không có file, tiếp tục
      if (!req.file) {
        return next();
      }

      try {
        // Thêm thông tin fileStorage vào req để controller có thể sử dụng
        req.fileStorage = fileStorage;
        req.fileDestination = destination;
        next();
      } catch (error) {
        next(error);
      }
    });
  };
};

// Middleware upload file văn bản cho nội dung chapter
const uploadDocument = (fieldName) => {
  console.log(`Creating uploadDocument middleware for field: ${fieldName}`);
  
  // Sử dụng parse thay vì storage
  const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
      fileSize: 10 * 1024 * 1024 // 10MB cho file văn bản
    },
    fileFilter: documentFileFilter
  }).any(); // Sử dụng .any() thay vì .fields() để chấp nhận tất cả trường

  return (req, res, next) => {
    console.log(`Processing upload request with content-type:`, req.headers['content-type']);
    console.log(`Body before multer:`, req.body);
    
    upload(req, res, async (err) => {
      if (err) {
        console.error(`Upload error:`, err);
        if (err instanceof multer.MulterError) {
          return next(new ValidationError('Lỗi upload file', [err.message]));
        }
        return next(err);
      }

      // Log tất cả các files
      console.log(`Files received after multer:`, 
        req.files ? req.files.map(f => ({ fieldname: f.fieldname, originalname: f.originalname })) : 'No files');
      console.log(`Form fields after multer:`, req.body);

      // Xử lý tên trường có khoảng trắng
      const processedBody = {};
      Object.keys(req.body).forEach(key => {
        const trimmedKey = key.trim();
        processedBody[trimmedKey] = req.body[key];
      });
      
      // Gán lại đối tượng đã xử lý vào req.body
      req.body = processedBody;
      
      // Log sau khi xử lý tên trường
      console.log('Body sau khi xử lý tên trường:', req.body);

      // Tìm file nội dung chương
      const contentFile = req.files && req.files.find(f => 
        f.fieldname === fieldName || 
        f.fieldname === 'chapterContent' || 
        f.fieldname === 'content' ||
        f.fieldname.trim() === fieldName || 
        f.fieldname.trim() === 'chapterContent' || 
        f.fieldname.trim() === 'content'
      );

      if (contentFile) {
        console.log(`Found content file:`, {
          fieldname: contentFile.fieldname,
          originalname: contentFile.originalname,
          mimetype: contentFile.mimetype,
          size: contentFile.size
        });
        
        try {
          // Đọc nội dung file
          if (contentFile.mimetype === 'text/plain') {
            // Đọc trực tiếp nội dung file text
            const content = contentFile.buffer.toString('utf8');
            req.body.content = content;
            console.log(`Extracted text content, length: ${content.length} chars`);
          } else {
            // Đối với file doc/docx, lưu tạm vào req để controller xử lý
            req.body.documentFile = contentFile;
            console.log(`Stored document file in req.body.documentFile for controller processing`);
          }
        } catch (error) {
          console.error(`Error processing file:`, error);
          return next(error);
        }
      } else {
        console.log(`No content file found with expected fieldname`);
      }
      
      // Đảm bảo số chương là number
      if (req.body.chapterNumber) {
        req.body.chapterNumber = parseInt(req.body.chapterNumber, 10);
      }
      
      console.log('Final request body after processing:', req.body);
      next();
    });
  };
};

// Middleware để sửa các tên trường form-data có khoảng trắng
const fixFormData = (req, res, next) => {
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('fixFormData: Kiểm tra và sửa các trường với khoảng trắng');
    
    // Tạo object mới để lưu các key đã được trim
    const cleanedBody = {};
    let hasChanges = false;
    
    // Duyệt qua tất cả các key trong req.body
    Object.keys(req.body).forEach(key => {
      const trimmedKey = key.trim();
      
      // Nếu key và trimmedKey khác nhau, có nghĩa là key có khoảng trắng
      if (key !== trimmedKey) {
        console.log(`fixFormData: Tìm thấy trường có khoảng trắng: '${key}' -> '${trimmedKey}'`);
        cleanedBody[trimmedKey] = req.body[key];
        hasChanges = true;
      } else {
        // Nếu key không có khoảng trắng, giữ nguyên
        cleanedBody[key] = req.body[key];
      }
    });
    
    // Chỉ gán lại nếu có thay đổi
    if (hasChanges) {
      console.log('fixFormData: Đã sửa các trường form-data');
      req.body = cleanedBody;
    }
  }
  
  next();
};

module.exports = {
  uploadImage,
  uploadDocument,
  fixFormData
};