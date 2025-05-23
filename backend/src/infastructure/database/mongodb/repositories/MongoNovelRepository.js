const { NovelRepository } = require('../../../../domain/repositories');
const { Novel } = require('../../../../domain/entities');
const { NovelModel } = require('../models');
const { NotFoundError } = require('../../../../domain/errors');
const mongoose = require('mongoose');

class MongoNovelRepository extends NovelRepository {
  async findById(id) {
    const novelDoc = await NovelModel.findById(id)
      .populate('categories');
      
    if (!novelDoc) return null;

    return this._mapToEntity(novelDoc);
  }

  async findBySlug(slug) {
    const novelDoc = await NovelModel.findOne({ slug })
      .populate('categories');
      
    if (!novelDoc) return null;

    return this._mapToEntity(novelDoc);
  }

  async findAll(page = 1, limit = 20, filters = {}) {
    const options = {
      page,
      limit,
      sort: { createdAt: -1 },
      populate: 'categories'
    };

    // Construct filter query
    const query = {};
    
    if (filters.status) {
      query.status = filters.status;
    }
    
    if (filters.tags && filters.tags.length > 0) {
      query.tags = { $in: filters.tags };
    }
    
    // Add category filter
    if (filters.category) {
      // Find category by name if it's a string
      if (typeof filters.category === 'string') {
        const categoryNameRegex = new RegExp(filters.category, 'i');
        // Using aggregation to find novels with specific category names
        const matchingNovels = await NovelModel.aggregate([
          {
            $lookup: {
              from: 'categories',
              localField: 'categories',
              foreignField: '_id',
              as: 'categoryObjects'
            }
          },
          {
            $match: {
              'categoryObjects.name': { $regex: categoryNameRegex }
            }
          },
          { $project: { _id: 1 } }
        ]);
        
        if (matchingNovels.length > 0) {
          query._id = { $in: matchingNovels.map(novel => novel._id) };
        } else {
          // If no novels match the category, return empty result
          return {
            items: [],
            page,
            limit,
            totalPages: 0,
            totalItems: 0
          };
        }
      }
    }

    const novelsDoc = await NovelModel.find(query)
      .populate('categories')
      .sort(options.sort)
      .skip((page - 1) * limit)
      .limit(limit);
    
    const total = await NovelModel.countDocuments(query);
    
    return {
      items: novelsDoc.map(novelDoc => this._mapToEntity(novelDoc)),
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalItems: total
    };
  }

  async create(novelData) {
    const novelDoc = await NovelModel.create(novelData);
    return this._mapToEntity(novelDoc);
  }

  async update(id, novelData) {
    const novelDoc = await NovelModel.findByIdAndUpdate(id, novelData, {
      new: true,
      runValidators: true
    }).populate('categories');

    if (!novelDoc) {
      throw new NotFoundError('Novel not found');
    }

    return this._mapToEntity(novelDoc);
  }

  async delete(id) {
    const novelDoc = await NovelModel.findByIdAndDelete(id);
    if (!novelDoc) {
      throw new NotFoundError('Novel not found');
    }

    return true;
  }

  async increaseView(id) {
    const novelDoc = await NovelModel.findByIdAndUpdate(
      id,
      { $inc: { views: 1 } },
      { new: true }
    );

    if (!novelDoc) {
      throw new NotFoundError('Novel not found');
    }

    return this._mapToEntity(novelDoc);
  }

  async findByCategory(categoryId, page = 1, limit = 20) {
    const options = {
      page,
      limit,
      sort: { createdAt: -1 }
    };

    const query = { categories: categoryId };

    const novelsDoc = await NovelModel.find(query)
      .populate('categories')
      .sort(options.sort)
      .skip((page - 1) * limit)
      .limit(limit);
    
    const total = await NovelModel.countDocuments(query);
    
    return {
      items: novelsDoc.map(novelDoc => this._mapToEntity(novelDoc)),
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalItems: total
    };
  }

  async search(query, page = 1, limit = 20) {
    const searchRegex = new RegExp(query, 'i');
    
    // Thực hiện aggregation để tìm kiếm các truyện có tên thể loại khớp với query
    const matchingNovelsByCategory = await NovelModel.aggregate([
      {
        $lookup: {
          from: 'categories',
          localField: 'categories',
          foreignField: '_id',
          as: 'categoryObjects'
        }
      },
      {
        $match: {
          'categoryObjects.name': { $regex: searchRegex }
        }
      },
      { $project: { _id: 1 } }
    ]);
    
    const novelIdsByCategory = matchingNovelsByCategory.map(novel => novel._id);
    
    const searchQuery = {
      $or: [
        { title: searchRegex },           // Tìm theo tiêu đề
        { author: searchRegex },          // Tìm theo tác giả
        { tags: searchRegex },            // Tìm theo thẻ
        { _id: { $in: novelIdsByCategory } }  // Tìm theo thể loại
      ]
    };

    console.log(`Searching for: '${query}' with regex: ${searchRegex}`);
    
    const novelsDoc = await NovelModel.find(searchQuery)
      .populate('categories')
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(limit);
    
    const total = await NovelModel.countDocuments(searchQuery);
    
    return {
      items: novelsDoc.map(novelDoc => this._mapToEntity(novelDoc)),
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalItems: total
    };
  }

  async addRating(id, rating) {
    const novelDoc = await NovelModel.findById(id);
    
    if (!novelDoc) {
      throw new NotFoundError('Novel not found');
    }
    
    // Calculate new average rating
    const totalRating = novelDoc.rating * novelDoc.totalRatings;
    const newTotalRatings = novelDoc.totalRatings + 1;
    const newRating = (totalRating + rating) / newTotalRatings;
    
    // Update novel with new rating
    const updatedNovel = await NovelModel.findByIdAndUpdate(
      id,
      { 
        rating: parseFloat(newRating.toFixed(2)), 
        totalRatings: newTotalRatings 
      },
      { new: true }
    ).populate('categories');
    
    return this._mapToEntity(updatedNovel);
  }

  _mapToEntity(novelDoc) {
    return new Novel(
      novelDoc._id.toString(),
      novelDoc.title,
      novelDoc.author,
      novelDoc.slug,
      novelDoc.description,
      novelDoc.coverImage,
      novelDoc.categories.map(cat => cat._id.toString()),
      novelDoc.tags,
      novelDoc.status,
      novelDoc.views,
      novelDoc.rating,
      novelDoc.totalChapters,
      novelDoc.createdAt,
      novelDoc.updatedAt
    );
  }
}

module.exports = MongoNovelRepository;