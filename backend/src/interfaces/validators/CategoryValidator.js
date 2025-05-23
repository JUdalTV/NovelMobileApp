const Joi = require('joi');

const createCategorySchema = Joi.object({
  name: Joi.string().min(1).max(50).required().messages({
    'string.min': 'Tên thể loại không được để trống',
    'string.max': 'Tên thể loại không được vượt quá 50 ký tự',
    'any.required': 'Tên thể loại là bắt buộc'
  }),
  description: Joi.string().max(500).optional().messages({
    'string.max': 'Mô tả không được vượt quá 500 ký tự'
  })
});

const updateCategorySchema = Joi.object({
  name: Joi.string().min(1).max(50).optional(),
  description: Joi.string().max(500).optional()
});

class CategoryValidator {
  static validateCreate(data) {
    return createCategorySchema.validate(data, { abortEarly: false });
  }

  static validateUpdate(data) {
    return updateCategorySchema.validate(data, { abortEarly: false });
  }
}

module.exports = CategoryValidator;