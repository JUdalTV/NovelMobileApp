const express = require('express');
const { authController } = require('../../main/factories/controllers');
const { authMiddleware, validationMiddleware } = require('../../main/factories/middlewares');
const { authValidation } = require('../validations');

const router = express.Router();

router.post(
  '/register',
  validationMiddleware.validate(authValidation.registerSchema),
  authController.register.bind(authController)
);

router.post(
  '/login',
  validationMiddleware.validate(authValidation.loginSchema),
  authController.login.bind(authController)
);

router.get(
  '/me',
  authMiddleware.protect(),
  authController.getCurrentUser.bind(authController)
);

router.get(
  '/verify-email/:userId',
  authController.verifyEmail.bind(authController)
);

router.post(
  '/reset-password/:userId',
  authMiddleware.protect(),
  validationMiddleware.validate(authValidation.resetPasswordSchema),
  authController.resetPassword.bind(authController)
);

module.exports = router;