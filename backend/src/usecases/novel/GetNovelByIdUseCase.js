class GetNovelByIdUseCase {
    constructor(novelRepository) {
      this.novelRepository = novelRepository;
    }
  
    async execute(id) {
      const novel = await this.novelRepository.findById(id);
      if (!novel) {
        throw new Error('Novel not found');
      }
      return novel;
    }
  }
  
  module.exports = GetNovelByIdUseCase;