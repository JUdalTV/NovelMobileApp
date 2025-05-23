class UpdateCategoryUseCase {
    constructor(categoryRepository) {
      this.categoryRepository = categoryRepository;
    }
  
    async execute(id, categoryData) {
      const category = await this.categoryRepository.findById(id);
      if (!category) {
        throw new Error('Category not found');
      }
      
      return this.categoryRepository.update(id, categoryData);
    }
  }
  
  module.exports = UpdateCategoryUseCase;