const { CategoryRepository } = require('../../../../domain/repositories');
const { Category } = require('../../../../domain/entities');
const { CategoryModel } = require('../models');
const { NotFoundError } = require('../../../../domain/errors');

class MongoCategoryRepository extends CategoryRepository {
  async findById(id) {
    const categoryDoc = await CategoryModel.findById(id);
    if (!categoryDoc) return null;

    return this._mapToEntity(categoryDoc);
  }

  async findBySlug(slug) {
    const categoryDoc = await CategoryModel.findOne({ slug });
    if (!categoryDoc) return null;

    return this._mapToEntity(categoryDoc);
  }

  async findAll() {
    const categoriesDoc = await CategoryModel.find().sort({ name: 1 });
    return categoriesDoc.map(categoryDoc => this._mapToEntity(categoryDoc));
  }

  async create(categoryData) {
    const categoryDoc = await CategoryModel.create(categoryData);
    return this._mapToEntity(categoryDoc);
  }

  async update(id, categoryData) {
    const categoryDoc = await CategoryModel.findByIdAndUpdate(id, categoryData, {
      new: true,
      runValidators: true
    });

    if (!categoryDoc) {
      throw new NotFoundError('Category not found');
    }

    return this._mapToEntity(categoryDoc);
  }

  async delete(id) {
    const categoryDoc = await CategoryModel.findByIdAndDelete(id);
    if (!categoryDoc) {
      throw new NotFoundError('Category not found');
    }

    return true;
  }

  _mapToEntity(categoryDoc) {
    return new Category(
      categoryDoc._id.toString(),
      categoryDoc.name,
      categoryDoc.slug,
      categoryDoc.description,
      categoryDoc.createdAt,
      categoryDoc.updatedAt
    );
  }
}

module.exports = MongoCategoryRepository;