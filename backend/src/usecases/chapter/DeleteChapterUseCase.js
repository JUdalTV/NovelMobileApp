class DeleteChapterUseCase {
    constructor(chapterRepository, novelRepository) {
      this.chapterRepository = chapterRepository;
      this.novelRepository = novelRepository;
    }
  
    async execute(id) {
      const chapter = await this.chapterRepository.findById(id);
      if (!chapter) {
        throw new Error('Chapter not found');
      }
      
      // Lấy thông tin novel
      const novel = await this.novelRepository.findById(chapter.novelId);
      
      // Xóa chapter
      await this.chapterRepository.delete(id);
      
      // Cập nhật tổng số chapter của novel
      if (novel) {
        await this.novelRepository.update(novel.id, {
          totalChapters: Math.max(0, novel.totalChapters - 1)
        });
      }
      
      return true;
    }
  }
  
  module.exports = DeleteChapterUseCase;