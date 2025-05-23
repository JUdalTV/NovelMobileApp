class UpdateNovelUseCase {
    constructor(novelRepository, fileStorage) {
      this.novelRepository = novelRepository;
      this.fileStorage = fileStorage;
    }
  
    async execute(id, novelData, coverImageFile) {
      const novel = await this.novelRepository.findById(id);
      if (!novel) {
        throw new Error('Novel not found');
      }
  
      let coverImageUrl = novel.coverImage;
      
      if (coverImageFile) {
        // Xóa ảnh cũ nếu có
        if (novel.coverImage) {
          await this.fileStorage.deleteFile(novel.coverImage);
        }
        
        coverImageUrl = await this.fileStorage.uploadFile(
          coverImageFile,
          `novels/covers/${Date.now()}-${coverImageFile.originalname}`
        );
      }
      
      return this.novelRepository.update(id, {
        ...novelData,
        coverImage: coverImageUrl
      });
    }
  }
  
  module.exports = UpdateNovelUseCase;