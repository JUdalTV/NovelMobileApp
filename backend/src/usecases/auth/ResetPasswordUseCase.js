const bcrypt = require('bcryptjs');

class ResetPasswordUseCase {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async execute(userId, newPassword) {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
    
    // Hash password mới
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);
    
    // Cập nhật password
    return this.userRepository.update(userId, {
      password: hashedPassword
    });
  }
}

module.exports = ResetPasswordUseCase;