const Joi = require('joi');

const createChapterSchema = Joi.object({
  title: Joi.string().min(1).max(200).required().messages({
    'string.min': 'Tiêu đề chương không được để trống',
    'string.max': 'Tiêu đề chương không được vượt quá 200 ký tự',
    'any.required': 'Tiêu đề chương là bắt buộc'
  }),
  chapterNumber: Joi.number().integer().min(1).required().messages({
    'number.min': 'Số chương phải lớn hơn 0',
    'any.required': 'Số chương là bắt buộc'
  }),
  content: Joi.string().min(1).required().messages({
    'string.min': 'Nội dung chương không được để trống',
    'any.required': 'Nội dung chương là bắt buộc'
  }),
  novelId: Joi.string().required().messages({
    'any.required': 'ID tiểu thuyết là bắt buộc'
  })
});

const updateChapterSchema = Joi.object({
  title: Joi.string().min(1).max(200).optional(),
  chapterNumber: Joi.number().integer().min(1).optional(),
  content: Joi.string().min(1).optional()
});

const chapterQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  sortBy: Joi.string().valid('chapterNumber', 'createdAt', 'views').default('chapterNumber'),
  sortOrder: Joi.string().valid('asc', 'desc').default('asc')
});

class ChapterValidator {
  static validateCreate(data) {
    return createChapterSchema.validate(data, { abortEarly: false });
  }

  static validateUpdate(data) {
    return updateChapterSchema.validate(data, { abortEarly: false });
  }

  static validateQuery(data) {
    return chapterQuerySchema.validate(data, { abortEarly: false });
  }
}

module.exports = ChapterValidator;