class GetAllCategoriesUseCase {
    constructor(categoryRepository) {
      this.categoryRepository = categoryRepository;
    }
  
    async execute() {
      return this.categoryRepository.findAll();
    }
  }
  
  module.exports = GetAllCategoriesUseCase;