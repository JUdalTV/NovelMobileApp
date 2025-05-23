class SearchNovelsUseCase {
    constructor(novelRepository) {
      this.novelRepository = novelRepository;
    }
  
    async execute(query, page = 1, limit = 20) {
      return this.novelRepository.search(query, page, limit);
    }
  }
  
  module.exports = SearchNovelsUseCase;