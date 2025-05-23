// User roles
const USER_ROLES = {
  USER: 'user',
  ADMIN: 'admin',
  MODERATOR: 'moderator'
};

// Novel status
const NOVEL_STATUS = {
  ONGOING: 'ongoing',
  COMPLETED: 'completed',
  PAUSED: 'paused',
  DROPPED: 'dropped'
};

// Sort options
const SORT_OPTIONS = {
  TITLE: 'title',
  VIEWS: 'views',
  RATING: 'rating',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt',
  CHAPTER_NUMBER: 'chapterNumber'
};

// Sort orders
const SORT_ORDERS = {
  ASC: 'asc',
  DESC: 'desc'
};

// Pagination
const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_LIMIT: 20,
  MAX_LIMIT: 100
};

// File upload
const FILE_UPLOAD = {
  MAX_SIZE: 5 * 1024 * 1024, // 5MB
  ALLOWED_TYPES: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
  UPLOAD_PATHS: {
    NOVEL_COVERS: 'novels/covers',
    USER_AVATARS: 'users/avatars'
  }
};

// Error messages
const ERROR_MESSAGES = {
  VALIDATION_ERROR: 'Dữ liệu không hợp lệ',
  NOT_FOUND: 'Không tìm thấy tài nguyên',
  UNAUTHORIZED: 'Chưa đăng nhập',
  FORBIDDEN: 'Không có quyền truy cập',
  INTERNAL_ERROR: 'Lỗi hệ thống',
  EMAIL_ALREADY_EXISTS: 'Email đã tồn tại',
  USERNAME_ALREADY_EXISTS: 'Tên người dùng đã tồn tại',
  INVALID_CREDENTIALS: 'Email hoặc mật khẩu không đúng',
  EMAIL_NOT_VERIFIED: 'Email chưa được xác thực',
  INVALID_TOKEN: 'Token không hợp lệ',
  TOKEN_EXPIRED: 'Token đã hết hạn'
};

// Success messages
const SUCCESS_MESSAGES = {
  LOGIN_SUCCESS: 'Đăng nhập thành công',
  REGISTER_SUCCESS: 'Đăng ký thành công',
  EMAIL_VERIFIED: 'Email đã được xác thực',
  PASSWORD_RESET: 'Mật khẩu đã được đặt lại',
  PROFILE_UPDATED: 'Cập nhật hồ sơ thành công',
  NOVEL_CREATED: 'Tạo tiểu thuyết thành công',
  NOVEL_UPDATED: 'Cập nhật tiểu thuyết thành công',
  NOVEL_DELETED: 'Xóa tiểu thuyết thành công',
  CHAPTER_CREATED: 'Tạo chương thành công',
  CHAPTER_UPDATED: 'Cập nhật chương thành công',
  CHAPTER_DELETED: 'Xóa chương thành công',
  CATEGORY_CREATED: 'Tạo thể loại thành công',
  CATEGORY_UPDATED: 'Cập nhật thể loại thành công',
  CATEGORY_DELETED: 'Xóa thể loại thành công'
};

module.exports = {
  USER_ROLES,
  NOVEL_STATUS,
  SORT_OPTIONS,
  SORT_ORDERS,
  PAGINATION,
  FILE_UPLOAD,
  ERROR_MESSAGES,
  SUCCESS_MESSAGES
}; 