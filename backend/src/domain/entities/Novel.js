class Novel {
    constructor(id, title, author, slug, description, coverImage, categories = [], tags = [], status = 'ongoing', views = 0, rating = 0, totalChapters = 0, createdAt = new Date(), updatedAt = new Date()) {
      this.id = id;
      this.title = title;
      this.author = author;
      this.slug = slug;
      this.description = description;
      this.coverImage = coverImage;
      this.categories = categories;
      this.tags = tags;
      this.status = status;
      this.views = views;
      this.rating = rating;
      this.totalChapters = totalChapters;
      this.createdAt = createdAt;
      this.updatedAt = updatedAt;
    }
  }
  
  module.exports = Novel;