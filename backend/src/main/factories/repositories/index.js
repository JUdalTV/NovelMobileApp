const { makeUserRepository } = require('./UserRepositoryFactory');
const { makeNovelRepository } = require('./NovelRepositoryFactory');
const { makeChapterRepository } = require('./ChapterRepositoryFactory');
const { makeCategoryRepository } = require('./CategoryRepositoryFactory');

module.exports = {
  makeUserRepository,
  makeNovelRepository,
  makeChapterRepository,
  makeCategoryRepository
};