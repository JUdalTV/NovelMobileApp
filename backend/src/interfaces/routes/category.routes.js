const express = require('express');
const { categoryController } = require('../../main/factories/controllers');
const { authMiddleware, validationMiddleware } = require('../../main/factories/middlewares');
const { categoryValidation } = require('../validations');

const router = express.Router();

router.get(
  '/',
  categoryController.getAllCategories.bind(categoryController)
);

router.get(
  '/:id',
  validationMiddleware.validateParams(categoryValidation.idSchema),
  categoryController.getCategoryById.bind(categoryController)
);

router.get(
  '/slug/:slug',
  validationMiddleware.validateParams(categoryValidation.slugSchema),
  categoryController.getCategoryBySlug.bind(categoryController)
);

router.get(
  '/:categoryId/novels',
  validationMiddleware.validateParams(categoryValidation.idSchema),
  categoryController.getNovelsByCategory.bind(categoryController)
);

router.post(
  '/',
  authMiddleware.protect(),
  authMiddleware.authorize('admin'),
  validationMiddleware.validate(categoryValidation.createSchema),
  categoryController.createCategory.bind(categoryController)
);

router.put(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin'),
  validationMiddleware.validateParams(categoryValidation.idSchema),
  validationMiddleware.validate(categoryValidation.updateSchema),
  categoryController.updateCategory.bind(categoryController)
);

router.delete(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin'),
  validationMiddleware.validateParams(categoryValidation.idSchema),
  categoryController.deleteCategory.bind(categoryController)
);

module.exports = router;