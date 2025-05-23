const { NotFoundError } = require('../../domain/errors');

class CategoryController {
  constructor(
    getAllCategoriesUseCase,
    getCategoryByIdUseCase,
    getCategoryBySlugUseCase,
    getNovelsByCategoryUseCase,
    createCategoryUseCase,
    updateCategoryUseCase,
    deleteCategoryUseCase
  ) {
    this.getAllCategoriesUseCase = getAllCategoriesUseCase;
    this.getCategoryByIdUseCase = getCategoryByIdUseCase;
    this.getCategoryBySlugUseCase = getCategoryBySlugUseCase;
    this.getNovelsByCategoryUseCase = getNovelsByCategoryUseCase;
    this.createCategoryUseCase = createCategoryUseCase;
    this.updateCategoryUseCase = updateCategoryUseCase;
    this.deleteCategoryUseCase = deleteCategoryUseCase;
  }

  async getAllCategories(req, res, next) {
    try {
      const categories = await this.getAllCategoriesUseCase.execute();
      
      res.status(200).json({
        success: true,
        count: categories.length,
        data: categories
      });
    } catch (error) {
      next(error);
    }
  }

  async getCategoryById(req, res, next) {
    try {
      const { id } = req.params;
      const category = await this.getCategoryByIdUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        data: category
      });
    } catch (error) {
      if (error.message === 'Category not found') {
        return next(new NotFoundError('Không tìm thấy thể loại'));
      }
      next(error);
    }
  }

  async getCategoryBySlug(req, res, next) {
    try {
      const { slug } = req.params;
      const category = await this.getCategoryBySlugUseCase.execute(slug);
      
      res.status(200).json({
        success: true,
        data: category
      });
    } catch (error) {
      if (error.message === 'Category not found') {
        return next(new NotFoundError('Không tìm thấy thể loại'));
      }
      next(error);
    }
  }

  async getNovelsByCategory(req, res, next) {
    try {
      const { categoryId } = req.params;
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 20;
      
      const novels = await this.getNovelsByCategoryUseCase.execute(categoryId, page, limit);
      
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
      if (error.message === 'Category not found') {
        return next(new NotFoundError('Không tìm thấy thể loại'));
      }
      next(error);
    }
  }

  async createCategory(req, res, next) {
    try {
      const categoryData = req.body;
      
      const category = await this.createCategoryUseCase.execute(categoryData);
      
      res.status(201).json({
        success: true,
        message: 'Thêm thể loại mới thành công',
        data: category
      });
    } catch (error) {
      next(error);
    }
  }

  async updateCategory(req, res, next) {
    try {
      const { id } = req.params;
      const categoryData = req.body;
      
      const category = await this.updateCategoryUseCase.execute(id, categoryData);
      
      res.status(200).json({
        success: true,
        message: 'Cập nhật thể loại thành công',
        data: category
      });
    } catch (error) {
      if (error.message === 'Category not found') {
        return next(new NotFoundError('Không tìm thấy thể loại'));
      }
      next(error);
    }
  }

  async deleteCategory(req, res, next) {
    try {
      const { id } = req.params;
      await this.deleteCategoryUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        message: 'Xóa thể loại thành công'
      });
    } catch (error) {
      if (error.message === 'Category not found') {
        return next(new NotFoundError('Không tìm thấy thể loại'));
      }
      next(error);
    }
  }
}

module.exports = CategoryController;