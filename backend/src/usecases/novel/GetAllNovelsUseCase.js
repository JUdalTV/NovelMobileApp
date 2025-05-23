class GetAllNovelsUseCase {
    constructor(novelRepository) {
      this.novelRepository = novelRepository;
    }
  
    async execute(page = 1, limit = 20, filters = {}) {
      return this.novelRepository.findAll(page, limit, filters);
    }
  }
  
  module.exports = GetAllNovelsUseCase;
