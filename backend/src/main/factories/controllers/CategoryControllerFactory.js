const CategoryController = require('../../../interfaces/controllers/CategoryController');
const { makeCategoryUseCases } = require('../usecases/CategoryUseCasesFactory');

const makeCategoryController = () => {
  const {
    getAllCategoriesUseCase,
    getCategoryByIdUseCase,
    getCategoryBySlugUseCase,
    getNovelsByCategoryUseCase,
    createCategoryUseCase,
    updateCategoryUseCase,
    deleteCategoryUseCase
  } = makeCategoryUseCases();
  
  return new CategoryController(
    getAllCategoriesUseCase,
    getCategoryByIdUseCase,
    getCategoryBySlugUseCase,
    getNovelsByCategoryUseCase,
    createCategoryUseCase,
    updateCategoryUseCase,
    deleteCategoryUseCase
  );
};

module.exports = { makeCategoryController };