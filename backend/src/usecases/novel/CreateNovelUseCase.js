class CreateNovelUseCase {
    constructor(novelRepository, fileStorage) {
      this.novelRepository = novelRepository;
      this.fileStorage = fileStorage;
    }
  
    async execute(novelData, coverImageFile) {
      let coverImageUrl = null;
      
      if (coverImageFile) {
        coverImageUrl = await this.fileStorage.uploadFile(
          coverImageFile,
          `novels/covers/${Date.now()}-${coverImageFile.originalname}`
        );
      }
      
      return this.novelRepository.create({
        ...novelData,
        coverImage: coverImageUrl
      });
    }
  }
  
  module.exports = CreateNovelUseCase;