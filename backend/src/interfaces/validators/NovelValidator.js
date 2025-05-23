const Joi = require('joi');

const createNovelSchema = Joi.object({
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

const updateNovelSchema = Joi.object({
  title: Joi.string().min(1).max(200).optional(),
  author: Joi.string().min(1).max(100).optional(),
  description: Joi.string().max(2000).optional(),
  categories: Joi.array().items(Joi.string()).min(1).optional(),
  tags: Joi.array().items(Joi.string()).optional(),
  status: Joi.string().valid('ongoing', 'completed', 'paused', 'dropped').optional()
});

const novelQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  category: Joi.string().optional(),
  status: Joi.string().valid('ongoing', 'completed', 'paused', 'dropped').optional(),
  sortBy: Joi.string().valid('title', 'views', 'rating', 'createdAt', 'updatedAt').default('createdAt'),
  sortOrder: Joi.string().valid('asc', 'desc').default('desc'),
  search: Joi.string().optional()
});

class NovelValidator {
  static validateCreate(data) {
    return createNovelSchema.validate(data, { abortEarly: false });
  }

  static validateUpdate(data) {
    return updateNovelSchema.validate(data, { abortEarly: false });
  }

  static validateQuery(data) {
    return novelQuerySchema.validate(data, { abortEarly: false });
  }
}

module.exports = NovelValidator;