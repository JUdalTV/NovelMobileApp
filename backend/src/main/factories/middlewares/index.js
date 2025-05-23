const { makeAuthMiddleware } = require('./AuthMiddlewareFactory');
const { makeValidationMiddleware } = require('./ValidationMiddlewareFactory');
const { makeUploadMiddleware } = require('./UploadMiddlewareFactory');

// Khởi tạo các middleware
const authMiddleware = makeAuthMiddleware();
const validationMiddleware = makeValidationMiddleware();
const uploadMiddleware = makeUploadMiddleware();

module.exports = {
  authMiddleware,
  validationMiddleware,
  uploadMiddleware
}; 