const jwt = require('jsonwebtoken');
const { AuthenticationError, AuthorizationError } = require('../../domain/errors');

const getTokenFromRequest = (req) => {
  // Kiểm tra header Authorization
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }
  // Kiểm tra token trong cookie
  else if (req.cookies && req.cookies.token) {
    token = req.cookies.token;
  }
  
  return token;
};

exports.protect = (userRepository) => async (req, res, next) => {
  try {
    const token = getTokenFromRequest(req);

    // Kiểm tra xem token có tồn tại không
    if (!token) {
      return next(new AuthenticationError('Vui lòng đăng nhập để truy cập tài nguyên này'));
    }

    try {
      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Lấy thông tin user từ id
      const user = await userRepository.findById(decoded.id);

      if (!user) {
        return next(new AuthenticationError('Người dùng không tồn tại'));
      }

      // Lưu thông tin user vào request
      req.user = user;
      next();
    } catch (err) {
      return next(new AuthenticationError('Không được phép truy cập'));
    }
  } catch (error) {
    next(error);
  }
};

exports.authorize = (...roles) => (req, res, next) => {
  if (!req.user) {
    return next(new AuthenticationError('Vui lòng đăng nhập trước'));
  }
  
  if (!roles.includes(req.user.role)) {
    return next(new AuthorizationError(`Vai trò ${req.user.role} không được phép thực hiện thao tác này`));
  }
  
  next();
};