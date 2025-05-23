const errorHandler = require('./error');
const validate = require('./validate');
const apiLimiter = require('./rateLimit');
const { uploadImage, uploadDocument, fixFormData } = require('./upload');
const { protect, authorize } = require('./auth');

const setupMiddlewares = (app) => {
  // Thiết lập rate limit cho các routes API
  app.use('/api', apiLimiter);
};

module.exports = {
  errorHandler,
  validate,
  apiLimiter,
  uploadImage,
  uploadDocument,
  fixFormData,
  protect,
  authorize,
  setupMiddlewares
};