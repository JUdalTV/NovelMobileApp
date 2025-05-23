const {
    GetAllCategoriesUseCase,
    GetCategoryByIdUseCase,
    GetCategoryBySlugUseCase,
    GetNovelsByCategoryUseCase,
    CreateCategoryUseCase,
    UpdateCategoryUseCase,
    DeleteCategoryUseCase
  } = require('../../../usecases/category');
  const { makeCategoryRepository } = require('../repositories/CategoryRepositoryFactory');
  const { makeNovelRepository } = require('../repositories/NovelRepositoryFactory');
  
  const makeCategoryUseCases = () => {
    const categoryRepository = makeCategoryRepository();
    const novelRepository = makeNovelRepository();
  
    return {
      getAllCategoriesUseCase: new GetAllCategoriesUseCase(categoryRepository),
      getCategoryByIdUseCase: new GetCategoryByIdUseCase(categoryRepository),
      getCategoryBySlugUseCase: new GetCategoryBySlugUseCase(categoryRepository),
      getNovelsByCategoryUseCase: new GetNovelsByCategoryUseCase(novelRepository, categoryRepository),
      createCategoryUseCase: new CreateCategoryUseCase(categoryRepository),
      updateCategoryUseCase: new UpdateCategoryUseCase(categoryRepository),
      deleteCategoryUseCase: new DeleteCategoryUseCase(categoryRepository)
    };
  };
  
  module.exports = { makeCategoryUseCases };