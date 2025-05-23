const { ValidationError } = require('../../domain/errors');

const validate = (schema) => (req, res, next) => {
  // Log thông tin chi tiết
  console.log('Body trước khi validate:', JSON.stringify(req.body, null, 2));
  console.log('Headers:', JSON.stringify(req.headers, null, 2));
  console.log('Content-Type:', req.headers['content-type']);
  
  // Log các trường cụ thể
  console.log('Các trường cần thiết:');
  console.log('- title:', req.body.title);
  console.log('- chapterNumber:', req.body.chapterNumber);
  console.log('- novelId:', req.body.novelId);
  console.log('- content:', req.body.content ? 'Có nội dung' : 'Không có nội dung');
  
  // Nếu là form-data và có trường có khoảng trắng, thử xử lý
  if (req.headers['content-type'] && req.headers['content-type'].includes('multipart/form-data')) {
    console.log('Đây là form-data request, kiểm tra tên trường có khoảng trắng');
    const processedBody = {};
    
    // Xử lý tên trường có khoảng trắng trong tất cả trường hợp
    Object.keys(req.body).forEach(key => {
      processedBody[key.trim()] = req.body[key];
    });
    
    // Cập nhật lại req.body
    Object.assign(req.body, processedBody);
    
    console.log('Body sau khi xử lý khoảng trắng:', JSON.stringify(req.body, null, 2));
  }
  
  const { error } = schema.validate(req.body, {
    abortEarly: false,
    allowUnknown: true,
    stripUnknown: false
  });
  
  if (error) {
    console.log('Validation Error:', error);
    const errorMessages = error.details.map(detail => detail.message);
    return next(new ValidationError('Dữ liệu không hợp lệ', errorMessages));
  }
  
  console.log('Validation passed successfully');
  next();
};

const validateQuery = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.query, {
    abortEarly: false,
    allowUnknown: true
  });
  
  if (error) {
    const errorMessages = error.details.map(detail => detail.message);
    return next(new ValidationError('Dữ liệu query không hợp lệ', errorMessages));
  }
  
  next();
};

const validateParams = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.params, {
    abortEarly: false,
    allowUnknown: true
  });
  
  if (error) {
    const errorMessages = error.details.map(detail => detail.message);
    return next(new ValidationError('Dữ liệu params không hợp lệ', errorMessages));
  }
  
  next();
};

module.exports = {
  validate,
  validateQuery,
  validateParams
};