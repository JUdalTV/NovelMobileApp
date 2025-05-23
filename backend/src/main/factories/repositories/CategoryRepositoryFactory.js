const MongoCategoryRepository = require('../../../infastructure/database/mongodb/repositories/MongoCategoryRepository');

const makeCategoryRepository = () => {
  return new MongoCategoryRepository();
};

module.exports = { makeCategoryRepository };