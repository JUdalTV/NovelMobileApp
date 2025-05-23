class ChapterRepository {
    async findById(id) {
      throw new Error('Method not implemented');
    }
  
    async findByNovelIdAndChapterNumber(novelId, chapterNumber) {
      throw new Error('Method not implemented');
    }
  
    async findByNovelId(novelId, page, limit) {
      throw new Error('Method not implemented');
    }
  
    async create(chapterData) {
      throw new Error('Method not implemented');
    }
  
    async update(id, chapterData) {
      throw new Error('Method not implemented');
    }
  
    async delete(id) {
      throw new Error('Method not implemented');
    }
  
    async increaseView(id) {
      throw new Error('Method not implemented');
    }
  }
  
  module.exports = ChapterRepository;