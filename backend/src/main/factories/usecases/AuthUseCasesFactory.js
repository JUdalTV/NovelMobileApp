const RegisterUseCase = require('../../../usecases/auth/RegisterUseCase');
const LoginUseCase = require('../../../usecases/auth/LoginUseCase');
const VerifyEmailUseCase = require('../../../usecases/auth/VerifyEmailUseCase');
const ResetPasswordUseCase = require('../../../usecases/auth/ResetPasswordUseCase');
const { makeUserRepository } = require('../repositories/UserRepositoryFactory');

const makeAuthUseCases = () => {
  const userRepository = makeUserRepository();
  
  return {
    registerUseCase: new RegisterUseCase(userRepository),
    loginUseCase: new LoginUseCase(userRepository),
    verifyEmailUseCase: new VerifyEmailUseCase(userRepository),
    resetPasswordUseCase: new ResetPasswordUseCase(userRepository)
  };
};

module.exports = { makeAuthUseCases }; 