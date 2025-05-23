const jwt = require('jsonwebtoken');
const { config } = require('../config');

// JWT Helpers
const generateToken = (payload) => {
  return jwt.sign(payload, config.jwt.secret, {
    expiresIn: config.jwt.expire
  });
};

const verifyToken = (token) => {
  return jwt.verify(token, config.jwt.secret);
};

// Pagination Helpers
const getPaginationData = (page, limit, total) => {
  const totalPages = Math.ceil(total / limit);
  const hasNext = page < totalPages;
  const hasPrev = page > 1;

  return {
    currentPage: page,
    totalPages,
    totalItems: total,
    itemsPerPage: limit,
    hasNext,
    hasPrev,
    nextPage: hasNext ? page + 1 : null,
    prevPage: hasPrev ? page - 1 : null
  };
};

// Response Helpers
const successResponse = (data, message = 'Success', statusCode = 200) => {
  return {
    success: true,
    message,
    data,
    statusCode
  };
};

const errorResponse = (message = 'Error', statusCode = 500, errors = []) => {
  return {
    success: false,
    message,
    errors,
    statusCode
  };
};

// Slug Helper
const generateSlug = (text) => {
  const slugify = require('slugify');
  return slugify(text, {
    lower: true,
    locale: 'vi',
    remove: /[*+~.()'"!:@]/g
  });
};

// File Upload Helpers
const getFileExtension = (filename) => {
  return filename.split('.').pop().toLowerCase();
};

const isValidImageFile = (filename) => {
  const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  const extension = getFileExtension(filename);
  return validExtensions.includes(extension);
};

// Date Helpers
const formatDate = (date) => {
  return new Date(date).toISOString();
};

const isDateExpired = (date) => {
  return new Date(date) < new Date();
};

module.exports = {
  generateToken,
  verifyToken,
  getPaginationData,
  successResponse,
  errorResponse,
  generateSlug,
  getFileExtension,
  isValidImageFile,
  formatDate,
  isDateExpired
}; 