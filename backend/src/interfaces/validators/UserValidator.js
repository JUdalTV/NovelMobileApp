const Joi = require('joi');

const registerSchema = Joi.object({
  username: Joi.string().alphanum().min(3).max(30).required().messages({
    'string.alphanum': 'Username chỉ chứa ký tự chữ và số',
    'string.min': 'Username phải có ít nhất 3 ký tự',
    'string.max': 'Username không được vượt quá 30 ký tự',
    'any.required': 'Username là bắt buộc'
  }),
  email: Joi.string().email().required().messages({
    'string.email': 'Email không hợp lệ',
    'any.required': 'Email là bắt buộc'
  }),
  password: Joi.string().min(6).required().messages({
    'string.min': 'Mật khẩu phải có ít nhất 6 ký tự',
    'any.required': 'Mật khẩu là bắt buộc'
  }),
  confirmPassword: Joi.string().valid(Joi.ref('password')).required().messages({
    'any.only': 'Mật khẩu xác nhận không khớp',
    'any.required': 'Mật khẩu xác nhận là bắt buộc'
  })
});

const loginSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Email không hợp lệ',
    'any.required': 'Email là bắt buộc'
  }),
  password: Joi.string().required().messages({
    'any.required': 'Mật khẩu là bắt buộc'
  })
});

const updateProfileSchema = Joi.object({
  username: Joi.string().alphanum().min(3).max(30).optional(),
  email: Joi.string().email().optional()
});

const resetPasswordSchema = Joi.object({
  newPassword: Joi.string().min(6).required().messages({
    'string.min': 'Mật khẩu mới phải có ít nhất 6 ký tự',
    'any.required': 'Mật khẩu mới là bắt buộc'
  }),
  confirmPassword: Joi.string().valid(Joi.ref('newPassword')).required().messages({
    'any.only': 'Mật khẩu xác nhận không khớp',
    'any.required': 'Mật khẩu xác nhận là bắt buộc'
  })
});

class UserValidator {
  static validateRegister(data) {
    return registerSchema.validate(data, { abortEarly: false });
  }

  static validateLogin(data) {
    return loginSchema.validate(data, { abortEarly: false });
  }

  static validateUpdateProfile(data) {
    return updateProfileSchema.validate(data, { abortEarly: false });
  }

  static validateResetPassword(data) {
    return resetPasswordSchema.validate(data, { abortEarly: false });
  }
}

module.exports = UserValidator;