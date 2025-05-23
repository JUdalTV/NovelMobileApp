const MongoNovelRepository = require('../../../infastructure/database/mongodb/repositories/MongoNovelRepository');

const makeNovelRepository = () => {
  return new MongoNovelRepository();
};

module.exports = { makeNovelRepository };