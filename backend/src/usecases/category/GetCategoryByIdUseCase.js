class GetCategoryByIdUseCase {
    constructor(categoryRepository) {
      this.categoryRepository = categoryRepository;
    }
  
    async execute(id) {
      const category = await this.categoryRepository.findById(id);
      if (!category) {
        throw new Error('Category not found');
      }
      return category;
    }
  }
  
  module.exports = GetCategoryByIdUseCase;