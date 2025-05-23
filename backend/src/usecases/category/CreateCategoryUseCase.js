class CreateCategoryUseCase {
    constructor(categoryRepository) {
      this.categoryRepository = categoryRepository;
    }
  
    async execute(categoryData) {
      return this.categoryRepository.create(categoryData);
    }
  }
  
  module.exports = CreateCategoryUseCase;