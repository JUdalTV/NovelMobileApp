class GetChapterByNovelAndNumberUseCase {
    constructor(chapterRepository, novelRepository) {
      this.chapterRepository = chapterRepository;
      this.novelRepository = novelRepository;
    }
  
    async execute(novelId, chapterNumber) {
      const novel = await this.novelRepository.findById(novelId);
      if (!novel) {
        throw new Error('Novel not found');
      }
      
      const chapter = await this.chapterRepository.findByNovelIdAndChapterNumber(novelId, chapterNumber);
      if (!chapter) {
        throw new Error('Chapter not found');
      }
      
      // Tăng số lượt xem
      await this.chapterRepository.increaseView(chapter.id);
      
      return chapter;
    }
  }
  
  module.exports = GetChapterByNovelAndNumberUseCase;