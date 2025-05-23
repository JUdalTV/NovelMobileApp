const { NotFoundError } = require('../../domain/errors');

class UploadCoverImageUseCase {
  constructor(novelRepository, fileStorage) {
    this.novelRepository = novelRepository;
    this.fileStorage = fileStorage;
  }

  async execute(novelId, coverImageFile) {
    // Check if novel exists
    const novel = await this.novelRepository.findById(novelId);
    if (!novel) {
      throw new NotFoundError('Novel not found');
    }

    // Upload image to storage
    const coverImageUrl = await this.fileStorage.uploadFile(
      coverImageFile,
      `novels/${novelId}/cover`
    );

    // Update novel with new cover image URL
    await this.novelRepository.update(novelId, { coverImage: coverImageUrl });

    return coverImageUrl;
  }
}

module.exports = UploadCoverImageUseCase; 