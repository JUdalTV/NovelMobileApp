const Joi = require('joi');

const createSchema = Joi.object({
  title: Joi.string().min(1).max(200).required().messages({
    'string.min': 'Tiêu đề không được để trống',
    'string.max': 'Tiêu đề không được vượt quá 200 ký tự',
    'any.required': 'Tiêu đề là bắt buộc'
  }),
  author: Joi.string().min(1).max(100).required().messages({
    'string.min': 'Tác giả không được để trống',
    'string.max': 'Tác giả không được vượt quá 100 ký tự',
    'any.required': 'Tác giả là bắt buộc'
  }),
  description: Joi.string().max(2000).optional().messages({
    'string.max': 'Mô tả không được vượt quá 2000 ký tự'
  }),
  categories: Joi.array().items(Joi.string()).min(1).required().messages({
    'array.min': 'Phải chọn ít nhất 1 thể loại',
    'any.required': 'Thể loại là bắt buộc'
  }),
  tags: Joi.array().items(Joi.string()).optional(),
  status: Joi.string().valid('ongoing', 'completed', 'paused', 'dropped').default('ongoing')
});

const updateSchema = Joi.object({
  title: Joi.string().min(1).max(200).optional(),
  author: Joi.string().min(1).max(100).optional(),
  description: Joi.string().max(2000).optional(),
  categories: Joi.array().items(Joi.string()).min(1).optional(),
  tags: Joi.array().items(Joi.string()).optional(),
  status: Joi.string().valid('ongoing', 'completed', 'paused', 'dropped').optional()
});

const searchSchema = Joi.object({
  query: Joi.string().min(1).required().messages({
    'string.min': 'Từ khóa tìm kiếm không được để trống',
    'any.required': 'Từ khóa tìm kiếm là bắt buộc'
  }),
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20)
});

const idSchema = Joi.object({
  id: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).required().messages({
    'string.pattern.base': 'ID không hợp lệ',
    'any.required': 'ID là bắt buộc'
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
  searchSchema,
  idSchema,
  slugSchema
}; 