class GetCategoryBySlugUseCase {
    constructor(categoryRepository) {
      this.categoryRepository = categoryRepository;
    }
  
    async execute(slug) {
      const category = await this.categoryRepository.findBySlug(slug);
      if (!category) {
        throw new Error('Category not found');
      }
      return category;
    }
  }
  
  module.exports = GetCategoryBySlugUseCase;