class GetChaptersByNovelIdUseCase {
  constructor(chapterRepository, novelRepository) {
    this.chapterRepository = chapterRepository;
    this.novelRepository = novelRepository;
  }

  async execute(novelId, options = {}) {
    // Kiểm tra novel có tồn tại không
    const novel = await this.novelRepository.findById(novelId);
    if (!novel) {
      throw new Error('Novel not found');
    }

    // Lấy danh sách chapter của novel
    const { page = 1, limit = 20, sortBy = 'chapterNumber', sortOrder = 'asc' } = options;
    const chapters = await this.chapterRepository.findByNovelId(
      novelId, 
      { page, limit, sortBy, sortOrder }
    );

    return chapters;
  }
}

module.exports = GetChaptersByNovelIdUseCase;
