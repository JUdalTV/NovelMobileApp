const MongoUserRepository = require('../../../infastructure/database/mongodb/repositories/MongoUserRepository');

const makeUserRepository = () => {
  return new MongoUserRepository();
};

module.exports = { makeUserRepository };