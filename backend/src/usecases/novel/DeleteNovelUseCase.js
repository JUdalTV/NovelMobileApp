class DeleteNovelUseCase {
    constructor(novelRepository, chapterRepository, fileStorage) {
      this.novelRepository = novelRepository;
      this.chapterRepository = chapterRepository;
      this.fileStorage = fileStorage;
    }
  
    async execute(id) {
      const novel = await this.novelRepository.findById(id);
      if (!novel) {
        throw new Error('Novel not found');
      }
  
      // Xóa tất cả chapters
      const chapters = await this.chapterRepository.findByNovelId(id, 1, 1000);
      for (const chapter of chapters.items) {
        await this.chapterRepository.delete(chapter.id);
      }
  
      // Xóa ảnh bìa
      if (novel.coverImage) {
        await this.fileStorage.deleteFile(novel.coverImage);
      }
  
      // Xóa novel
      return this.novelRepository.delete(id);
    }
  }
  
  module.exports = DeleteNovelUseCase;