class VerifyEmailUseCase {
    constructor(userRepository) {
      this.userRepository = userRepository;
    }
  
    async execute(userId) {
      const user = await this.userRepository.findById(userId);
      if (!user) {
        throw new Error('User not found');
      }
      
      if (user.isVerified) {
        throw new Error('Email already verified');
      }
      
      return this.userRepository.verifyEmail(userId);
    }
  }
  
  module.exports = VerifyEmailUseCase;