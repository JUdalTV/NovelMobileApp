const { NotFoundError } = require('../../domain/errors');

class NovelController {
  constructor(
    getAllNovelsUseCase,
    getNovelByIdUseCase,
    getNovelBySlugUseCase,
    createNovelUseCase,
    updateNovelUseCase,
    deleteNovelUseCase,
    searchNovelsUseCase,
    uploadCoverImageUseCase
  ) {
    this.getAllNovelsUseCase = getAllNovelsUseCase;
    this.getNovelByIdUseCase = getNovelByIdUseCase;
    this.getNovelBySlugUseCase = getNovelBySlugUseCase;
    this.createNovelUseCase = createNovelUseCase;
    this.updateNovelUseCase = updateNovelUseCase;
    this.deleteNovelUseCase = deleteNovelUseCase;
    this.searchNovelsUseCase = searchNovelsUseCase;
    this.uploadCoverImageUseCase = uploadCoverImageUseCase;
  }

  async getAllNovels(req, res, next) {
    try {
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 20;
      const filters = {
        status: req.query.status,
        tags: req.query.tags,
        category: req.query.category,
        sort: req.query.sort || 'newest'
      };
      
      console.log('Getting novels with filters:', filters);
      
      const novels = await this.getAllNovelsUseCase.execute(page, limit, filters);
      
      res.status(200).json({
        success: true,
        count: novels.total,
        pagination: {
          page,
          limit,
          totalPages: Math.ceil(novels.total / limit)
        },
        data: novels.items
      });
    } catch (error) {
      console.error('Error in getAllNovels:', error);
      next(error);
    }
  }

  async getNovelById(req, res, next) {
    try {
      const { id } = req.params;
      const novel = await this.getNovelByIdUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        data: novel
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async getNovelBySlug(req, res, next) {
    try {
      const { slug } = req.params;
      const novel = await this.getNovelBySlugUseCase.execute(slug);
      
      res.status(200).json({
        success: true,
        data: novel
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async createNovel(req, res, next) {
    try {
      const novelData = req.body;
      const coverImageFile = req.file;
      
      const novel = await this.createNovelUseCase.execute(novelData, coverImageFile);
      
      res.status(201).json({
        success: true,
        message: 'Thêm truyện mới thành công',
        data: novel
      });
    } catch (error) {
      next(error);
    }
  }

  async updateNovel(req, res, next) {
    try {
      const { id } = req.params;
      const novelData = req.body;
      const coverImageFile = req.file;
      
      const novel = await this.updateNovelUseCase.execute(id, novelData, coverImageFile);
      
      res.status(200).json({
        success: true,
        message: 'Cập nhật truyện thành công',
        data: novel
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async deleteNovel(req, res, next) {
    try {
      const { id } = req.params;
      await this.deleteNovelUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        message: 'Xóa truyện thành công'
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async searchNovels(req, res, next) {
    try {
      const { q } = req.query;
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 20;
      
      const novels = await this.searchNovelsUseCase.execute(q, page, limit);
      
      res.status(200).json({
        success: true,
        count: novels.total,
        pagination: {
          page,
          limit,
          totalPages: Math.ceil(novels.total / limit)
        },
        data: novels.items
      });
    } catch (error) {
      next(error);
    }
  }

  async uploadCoverImage(req, res, next) {
    try {
      const { id } = req.params;
      const coverImageFile = req.file;
      
      if (!coverImageFile) {
        return res.status(400).json({
          success: false,
          message: 'Vui lòng tải lên file ảnh'
        });
      }

      const coverImageUrl = await this.uploadCoverImageUseCase.execute(id, coverImageFile);
      
      res.status(200).json({
        success: true,
        message: 'Tải lên ảnh bìa thành công',
        data: { coverImage: coverImageUrl }
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }
}

module.exports = NovelController;