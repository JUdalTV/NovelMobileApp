const bcrypt = require('bcryptjs');

class RegisterUseCase {
  constructor(userRepository, emailService) {
    this.userRepository = userRepository;
    this.emailService = emailService;
  }

  async execute(userData) {
    // Kiểm tra email đã tồn tại chưa
    const existingUserByEmail = await this.userRepository.findByEmail(userData.email);
    if (existingUserByEmail) {
      throw new Error('Email already in use');
    }
    
    // Kiểm tra username đã tồn tại chưa
    const existingUserByUsername = await this.userRepository.findByUsername(userData.username);
    if (existingUserByUsername) {
      throw new Error('Username already in use');
    }
    
    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(userData.password, salt);
    
    // Tạo user mới
    const user = await this.userRepository.create({
      ...userData,
      password: hashedPassword,
      role: 'user',
      isVerified: false
    });
    
    // Gửi email xác thực nếu có email service
    if (this.emailService) {
      await this.emailService.sendVerificationEmail(user);
    }
    
    return user;
  }
}

module.exports = RegisterUseCase;