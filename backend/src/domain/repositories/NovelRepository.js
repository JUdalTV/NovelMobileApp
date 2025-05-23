class NovelRepository {
    async findById(id) {
      throw new Error('Method not implemented');
    }
  
    async findBySlug(slug) {
      throw new Error('Method not implemented');
    }
  
    async findAll(page, limit, filters) {
      throw new Error('Method not implemented');
    }
  
    async create(novelData) {
      throw new Error('Method not implemented');
    }
  
    async update(id, novelData) {
      throw new Error('Method not implemented');
    }
  
    async delete(id) {
      throw new Error('Method not implemented');
    }
  
    async increaseView(id) {
      throw new Error('Method not implemented');
    }
  
    async findByCategory(categoryId, page, limit) {
      throw new Error('Method not implemented');
    }
  
    async search(query, page, limit) {
      throw new Error('Method not implemented');
    }
  }
  
  module.exports = NovelRepository;