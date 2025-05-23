const { makeAuthController } = require('./AuthControllerFactory');
const { makeNovelController } = require('./NovelControllerFactory');
const { makeChapterController } = require('./ChapterControllerFactory');
const { makeCategoryController } = require('./CategoryControllerFactory');

// Khởi tạo các controller
const authController = makeAuthController();
const novelController = makeNovelController();
const chapterController = makeChapterController();
const categoryController = makeCategoryController();

module.exports = {
  authController,
  novelController,
  chapterController,
  categoryController
};