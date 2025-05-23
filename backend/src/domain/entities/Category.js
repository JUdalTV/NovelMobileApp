class Category {
    constructor(id, name, slug, description = '', createdAt = new Date(), updatedAt = new Date()) {
      this.id = id;
      this.name = name;
      this.slug = slug;
      this.description = description;
      this.createdAt = createdAt;
      this.updatedAt = updatedAt;
    }
  }
  
  module.exports = Category;