class GetNovelsByCategoryUseCase {
    constructor(novelRepository, categoryRepository) {
      this.novelRepository = novelRepository;
      this.categoryRepository = categoryRepository;
    }
  
    async execute(categoryId, page = 1, limit = 20) {
      const category = await this.categoryRepository.findById(categoryId);
      if (!category) {
        throw new Error('Category not found');
      }
      
      return this.novelRepository.findByCategory(categoryId, page, limit);
    }
  }
  
  module.exports = GetNovelsByCategoryUseCase;