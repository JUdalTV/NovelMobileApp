const express = require('express');
const { chapterController } = require('../../main/factories/controllers');
const { authMiddleware, validationMiddleware, uploadMiddleware } = require('../../main/factories/middlewares');
const { chapterValidation } = require('../validations');

const router = express.Router();

router.get(
  '/:id',
  validationMiddleware.validateParams(chapterValidation.idSchema),
  chapterController.getChapterById.bind(chapterController)
);

router.get(
  '/novel/:novelId',
  validationMiddleware.validateParams(chapterValidation.novelIdSchema),
  chapterController.getChaptersByNovelId.bind(chapterController)
);

router.get(
  '/novel/:novelId/number/:chapterNumber',
  validationMiddleware.validateParams(chapterValidation.novelAndChapterSchema),
  chapterController.getChapterByNovelAndNumber.bind(chapterController)
);

router.post(
  '/',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  uploadMiddleware.fixFormData,
  uploadMiddleware.uploadDocument('chapterContent'),
  uploadMiddleware.fixFormData,
  validationMiddleware.validate(chapterValidation.createSchema),
  chapterController.createChapter.bind(chapterController)
);

router.put(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  validationMiddleware.validateParams(chapterValidation.idSchema),
  uploadMiddleware.fixFormData,
  uploadMiddleware.uploadDocument('chapterContent'),
  uploadMiddleware.fixFormData,
  validationMiddleware.validate(chapterValidation.updateSchema),
  chapterController.updateChapter.bind(chapterController)
);

router.delete(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  validationMiddleware.validateParams(chapterValidation.idSchema),
  chapterController.deleteChapter.bind(chapterController)
);

module.exports = router;