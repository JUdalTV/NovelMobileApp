class GetChapterByIdUseCase {
    constructor(chapterRepository) {
      this.chapterRepository = chapterRepository;
    }
  
    async execute(id) {
      const chapter = await this.chapterRepository.findById(id);
      if (!chapter) {
        throw new Error('Chapter not found');
      }
      
      // Tăng số lượt xem
      await this.chapterRepository.increaseView(id);
      
      return chapter;
    }
  }
  
  module.exports = GetChapterByIdUseCase;