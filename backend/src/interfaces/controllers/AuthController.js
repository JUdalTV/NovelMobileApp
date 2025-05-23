const { AuthenticationError, ValidationError } = require('../../domain/errors');

class AuthController {
  constructor(registerUseCase, loginUseCase, verifyEmailUseCase, resetPasswordUseCase) {
    this.registerUseCase = registerUseCase;
    this.loginUseCase = loginUseCase;
    this.verifyEmailUseCase = verifyEmailUseCase;
    this.resetPasswordUseCase = resetPasswordUseCase;
  }

  async register(req, res, next) {
    try {
      const userData = req.body;
      const user = await this.registerUseCase.execute(userData);
      
      res.status(201).json({
        success: true,
        message: 'Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.',
        data: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          isVerified: user.isVerified,
          createdAt: user.createdAt
        }
      });
    } catch (error) {
      if (error.message.includes('already in use')) {
        return next(new ValidationError(error.message));
      }
      next(error);
    }
  }

  async login(req, res, next) {
    try {
      const { email, password } = req.body;
      const { user, token } = await this.loginUseCase.execute(email, password);
      
      // Gửi token trong cookie
      const cookieOptions = {
        expires: new Date(Date.now() + process.env.JWT_COOKIE_EXPIRE * 24 * 60 * 60 * 1000),
        httpOnly: true
      };
      
      if (process.env.NODE_ENV === 'production') {
        cookieOptions.secure = true;
      }
      
      res.status(200)
        .cookie('token', token, cookieOptions)
        .json({
          success: true,
          token,
          user: {
            id: user.id,
            username: user.username,
            email: user.email,
            role: user.role
          }
        });
    } catch (error) {
      if (error.message === 'Invalid credentials') {
        return next(new AuthenticationError('Email hoặc mật khẩu không chính xác'));
      }
      next(error);
    }
  }

  async verifyEmail(req, res, next) {
    try {
      const { userId } = req.params;
      await this.verifyEmailUseCase.execute(userId);
      
      res.status(200).json({
        success: true,
        message: 'Xác thực email thành công'
      });
    } catch (error) {
      next(error);
    }
  }

  async resetPassword(req, res, next) {
    try {
      const { userId } = req.params;
      const { newPassword } = req.body;
      
      await this.resetPasswordUseCase.execute(userId, newPassword);
      
      res.status(200).json({
        success: true,
        message: 'Đặt lại mật khẩu thành công'
      });
    } catch (error) {
      next(error);
    }
  }

  async getProfile(req, res, next) {
    try {
      // Thông tin user đã được lấy từ middleware auth
      const { user } = req;
      
      res.status(200).json({
        success: true,
        data: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          isVerified: user.isVerified,
          createdAt: user.createdAt
        }
      });
    } catch (error) {
      next(error);
    }
  }

  async logout(req, res, next) {
    try {
      res.cookie('token', 'none', {
        expires: new Date(Date.now() + 10 * 1000),
        httpOnly: true
      });
      
      res.status(200).json({
        success: true,
        message: 'Đăng xuất thành công'
      });
    } catch (error) {
      next(error);
    }
  }

  async getCurrentUser(req, res, next) {
    try {
      // Thông tin user đã được lấy từ middleware auth
      const { user } = req;
      
      res.status(200).json({
        success: true,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          isVerified: user.isVerified,
          createdAt: user.createdAt
        }
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = AuthController;