const { protect, authorize } = require('../../../interfaces/middlewares/auth');
const { makeUserRepository } = require('../repositories/UserRepositoryFactory');

const makeAuthMiddleware = () => {
  const userRepository = makeUserRepository();
  
  return {
    protect: () => protect(userRepository),
    authorize: (...roles) => authorize(...roles)
  };
};

module.exports = { makeAuthMiddleware }; 