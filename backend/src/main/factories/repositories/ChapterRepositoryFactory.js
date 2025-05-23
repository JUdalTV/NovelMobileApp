const MongoChapterRepository = require('../../../infastructure/database/mongodb/repositories/MongoChapterRepository');

const makeChapterRepository = () => {
  return new MongoChapterRepository();
};

module.exports = { makeChapterRepository };