class Chapter {
    constructor(id, novelId, title, chapterNumber, content, views = 0, createdAt = new Date(), updatedAt = new Date()) {
      this.id = id;
      this.novelId = novelId;
      this.title = title;
      this.chapterNumber = chapterNumber;
      this.content = content;
      this.views = views;
      this.createdAt = createdAt;
      this.updatedAt = updatedAt;
    }
  }
  
  module.exports = Chapter;