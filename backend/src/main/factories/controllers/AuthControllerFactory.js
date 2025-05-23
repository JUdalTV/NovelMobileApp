const AuthController = require('../../../interfaces/controllers/AuthController');
const { makeAuthUseCases } = require('../usecases/AuthUseCasesFactory');

const makeAuthController = () => {
  const { registerUseCase, loginUseCase, verifyEmailUseCase, resetPasswordUseCase } = makeAuthUseCases();
  return new AuthController(registerUseCase, loginUseCase, verifyEmailUseCase, resetPasswordUseCase);
};

module.exports = { makeAuthController };