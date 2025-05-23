const Joi = require('joi');

const createSchema = Joi.object({
  name: Joi.string().min(1).max(50).required().messages({
    'string.min': 'Tên thể loại không được để trống',
    'string.max': 'Tên thể loại không được vượt quá 50 ký tự',
    'any.required': 'Tên thể loại là bắt buộc'
  }),
  description: Joi.string().max(500).optional().messages({
    'string.max': 'Mô tả không được vượt quá 500 ký tự'
  })
});

const updateSchema = Joi.object({
  name: Joi.string().min(1).max(50).optional(),
  description: Joi.string().max(500).optional()
});

const idSchema = Joi.object({
  id: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID không hợp lệ',
    'any.required': 'ID là bắt buộc'
  }),
  categoryId: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).optional().messages({
    'string.pattern.base': 'ID thể loại không hợp lệ'
  })
});

const slugSchema = Joi.object({
  slug: Joi.string().min(1).required().messages({
    'string.min': 'Slug không được để trống',
    'any.required': 'Slug là bắt buộc'
  })
});

module.exports = {
  createSchema,
  updateSchema,
  idSchema,
  slugSchema
}; 