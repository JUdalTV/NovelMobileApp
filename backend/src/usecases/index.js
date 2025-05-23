const novelUseCases = require('./novel');
const chapterUseCases = require('./chapter');
const authUseCases = require('./auth');
const categoryUseCases = require('./category');

module.exports = {
  novel: novelUseCases,
  chapter: chapterUseCases,
  auth: authUseCases,
  category: categoryUseCases
};