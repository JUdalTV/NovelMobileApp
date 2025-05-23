const express = require('express');
const { novelController, chapterController } = require('../../main/factories/controllers');
const { authMiddleware, validationMiddleware, uploadMiddleware } = require('../../main/factories/middlewares');
const { novelValidation, chapterValidation } = require('../validations');
const upload = require('../../infastructure/middleware/upload');

const router = express.Router();

router.get(
  '/',
  novelController.getAllNovels.bind(novelController)
);

router.get(
  '/search',
  validationMiddleware.validateQuery(novelValidation.searchSchema),
  novelController.searchNovels.bind(novelController)
);

router.get(
  '/:id',
  validationMiddleware.validateParams(novelValidation.idSchema),
  novelController.getNovelById.bind(novelController)
);

router.get(
  '/slug/:slug',
  validationMiddleware.validateParams(novelValidation.slugSchema),
  novelController.getNovelBySlug.bind(novelController)
);

router.post(
  '/',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  uploadMiddleware.uploadCoverImage,
  validationMiddleware.validate(novelValidation.createSchema),
  novelController.createNovel.bind(novelController)
);

router.put(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  uploadMiddleware.uploadCoverImage,
  validationMiddleware.validateParams(novelValidation.idSchema),
  validationMiddleware.validate(novelValidation.updateSchema),
  novelController.updateNovel.bind(novelController)
);

router.delete(
  '/:id',
  authMiddleware.protect(),
  authMiddleware.authorize('admin', 'author'),
  validationMiddleware.validateParams(novelValidation.idSchema),
  novelController.deleteNovel.bind(novelController)
);

// Upload cover image
router.post(
  '/:id/cover',
  authMiddleware.protect(),
  upload.single('coverImage'),
  novelController.uploadCoverImage.bind(novelController)
);

// Get chapters by novel ID
router.get(
  '/:id/chapters',
  validationMiddleware.validateParams(novelValidation.idSchema),
  chapterController.getChaptersByNovelId.bind(chapterController)
);

// Get specific chapter by novel ID and chapter number
router.get(
  '/:id/chapters/number/:chapterNumber',
  validationMiddleware.validateParams(chapterValidation.novelAndChapterSchema),
  chapterController.getChapterByNovelAndNumber.bind(chapterController)
);

module.exports = router;