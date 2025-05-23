const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: process.env.RATE_LIMIT_WINDOW_MS || 15 * 60 * 1000, // 15 phút
  max: process.env.RATE_LIMIT_MAX || 100, // giới hạn mỗi IP
  message: {
    success: false,
    message: 'Quá nhiều yêu cầu, vui lòng thử lại sau'
  }
});

module.exports = apiLimiter;