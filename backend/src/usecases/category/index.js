const GetAllCategoriesUseCase = require('./GetAllCategoriesUseCase');
const GetCategoryByIdUseCase = require('./GetCategoryByIdUseCase');
const GetNovelsByCategoryUseCase = require('./GetNovelsByCategoryUseCase');
const CreateCategoryUseCase = require('./CreateCategoryUseCase');
const UpdateCategoryUseCase = require('./UpdateCategoryUseCase');
const DeleteCategoryUseCase = require('./DeleteCategoryUseCase');
const GetCategoryBySlugUseCase = require('./GetCategoryBySlugUseCase');

module.exports = {
  GetAllCategoriesUseCase,
  GetCategoryByIdUseCase,
  GetNovelsByCategoryUseCase,
  CreateCategoryUseCase,
  UpdateCategoryUseCase,
  DeleteCategoryUseCase,
  GetCategoryBySlugUseCase
};