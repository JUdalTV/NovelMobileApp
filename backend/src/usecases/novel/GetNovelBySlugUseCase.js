class GetNovelBySlugUseCase {
    constructor(novelRepository) {
      this.novelRepository = novelRepository;
    }
  
    async execute(slug) {
      const novel = await this.novelRepository.findBySlug(slug);
      if (!novel) {
        throw new Error('Novel not found');
      }
      return novel;
    }
  }
  
  module.exports = GetNovelBySlugUseCase;