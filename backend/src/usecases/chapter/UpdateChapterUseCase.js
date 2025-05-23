class UpdateChapterUseCase {
    constructor(chapterRepository) {
      this.chapterRepository = chapterRepository;
    }
  
    async execute(id, chapterData) {
      const chapter = await this.chapterRepository.findById(id);
      if (!chapter) {
        throw new Error('Chapter not found');
      }
      
      return this.chapterRepository.update(id, chapterData);
    }
  }
  
  module.exports = UpdateChapterUseCase;