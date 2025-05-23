class CreateChapterUseCase {
    constructor(chapterRepository, novelRepository) {
      this.chapterRepository = chapterRepository;
      this.novelRepository = novelRepository;
    }
  
    async execute(chapterData) {
      // Kiểm tra novel tồn tại
      const novel = await this.novelRepository.findById(chapterData.novelId);
      if (!novel) {
        throw new Error('Novel not found');
      }
      
      // Tạo chapter mới với mapping đúng trường "novel"
      const formattedData = {
        ...chapterData,
        novel: chapterData.novelId  // Map novelId thành novel để khớp với model MongoDB
      };
      
      // Xóa trường novelId vì đã dùng novel
      delete formattedData.novelId;
      
      console.log('CreateChapterUseCase - formattedData:', formattedData);
      
      const chapter = await this.chapterRepository.create(formattedData);
      
      // Cập nhật tổng số chapter của novel
      await this.novelRepository.update(novel.id, {
        totalChapters: novel.totalChapters + 1
      });
      
      return chapter;
    }
  }
  
  module.exports = CreateChapterUseCase;