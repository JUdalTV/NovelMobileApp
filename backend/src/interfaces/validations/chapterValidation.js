const Joi = require('joi');

const createSchema = Joi.object({
  title: Joi.string().min(1).max(200).required().messages({
    'string.min': 'Tiêu đề chương không được để trống',
    'string.max': 'Tiêu đề chương không được vượt quá 200 ký tự',
    'any.required': 'Tiêu đề chương là bắt buộc'
  }),
  chapterNumber: Joi.number().integer().min(1).required().messages({
    'number.base': 'Số chương phải là số',
    'number.integer': 'Số chương phải là số nguyên',
    'number.min': 'Số chương phải lớn hơn 0',
    'any.required': 'Số chương là bắt buộc'
  }),
  content: Joi.string().allow('').optional().messages({
    'string.empty': 'Nội dung chương được cung cấp qua file hoặc trực tiếp'
  }),
  novelId: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID tiểu thuyết không hợp lệ',
    'any.required': 'ID tiểu thuyết là bắt buộc'
  }),
  documentFile: Joi.any().optional()
}).unknown(true);

const updateSchema = Joi.object({
  title: Joi.string().min(1).max(200).optional(),
  chapterNumber: Joi.number().integer().min(1).optional(),
  content: Joi.string().optional().allow('')
});

const idSchema = Joi.object({
  id: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID không hợp lệ',
    'any.required': 'ID là bắt buộc'
  })
});

const novelIdSchema = Joi.object({
  novelId: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID tiểu thuyết không hợp lệ',
    'any.required': 'ID tiểu thuyết là bắt buộc'
  })
});

const novelAndChapterSchema = Joi.object({
  id: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID tiểu thuyết không hợp lệ',
    'any.required': 'ID tiểu thuyết là bắt buộc'
  }),
  chapterNumber: Joi.number().integer().min(1).required().messages({
    'number.min': 'Số chương phải lớn hơn 0',
    'any.required': 'Số chương là bắt buộc'
  })
});

module.exports = {
  createSchema,
  updateSchema,
  idSchema,
  novelIdSchema,
  novelAndChapterSchema
}; 