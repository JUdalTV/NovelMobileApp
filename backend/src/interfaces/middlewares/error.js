const { ApplicationError } = require('../../domain/errors');

const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  // Log lỗi để debug
  console.error(err);

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Không tìm thấy tài nguyên';
    error = new ApplicationError(message, 404);
  }

  // Mongoose duplicate key
  if (err.code === 11000) {
    const message = 'Thông tin đã tồn tại';
    error = new ApplicationError(message, 400);
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map(val => val.message);
    error = new ApplicationError('Dữ liệu không hợp lệ', 400, message);
  }

  res.status(error.statusCode || 500).json({
    success: false,
    message: error.message || 'Lỗi hệ thống',
    errors: error.errors || []
  });
};

module.exports = errorHandler;