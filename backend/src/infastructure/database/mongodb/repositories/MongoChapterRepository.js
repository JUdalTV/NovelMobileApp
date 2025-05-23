const { ChapterRepository } = require('../../../../domain/repositories');
const { Chapter } = require('../../../../domain/entities');
const { ChapterModel } = require('../models');
const { NotFoundError } = require('../../../../domain/errors');

class MongoChapterRepository extends ChapterRepository {
  async findById(id) {
    const chapterDoc = await ChapterModel.findById(id);
    if (!chapterDoc) return null;

    return this._mapToEntity(chapterDoc);
  }

  async findByNovelIdAndChapterNumber(novelId, chapterNumber) {
    const chapterDoc = await ChapterModel.findOne({
      novel: novelId,
      chapterNumber: chapterNumber
    });
    
    if (!chapterDoc) return null;

    return this._mapToEntity(chapterDoc);
  }

  async findByNovelId(novelId, page = 1, limit = 20) {
    const chaptersDoc = await ChapterModel.find({ novel: novelId })
      .sort({ chapterNumber: 1 })
      .skip((page - 1) * limit)
      .limit(limit);
    
    const total = await ChapterModel.countDocuments({ novel: novelId });
    
    return {
      items: chaptersDoc.map(chapterDoc => this._mapToEntity(chapterDoc)),
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalItems: total
    };
  }

  async create(chapterData) {
    const chapterDoc = await ChapterModel.create(chapterData);
    return this._mapToEntity(chapterDoc);
  }

  async update(id, chapterData) {
    const chapterDoc = await ChapterModel.findByIdAndUpdate(id, chapterData, {
      new: true,
      runValidators: true
    });

    if (!chapterDoc) {
      throw new NotFoundError('Chapter not found');
    }

    return this._mapToEntity(chapterDoc);
  }

  async delete(id) {
    const chapterDoc = await ChapterModel.findByIdAndDelete(id);
    if (!chapterDoc) {
      throw new NotFoundError('Chapter not found');
    }

    return true;
  }

  async increaseView(id) {
    const chapterDoc = await ChapterModel.findByIdAndUpdate(
      id,
      { $inc: { views: 1 } },
      { new: true }
    );

    if (!chapterDoc) {
      throw new NotFoundError('Chapter not found');
    }

    return this._mapToEntity(chapterDoc);
  }

  _mapToEntity(chapterDoc) {
    return new Chapter(
      chapterDoc._id.toString(),
      chapterDoc.novel.toString(),
      chapterDoc.title,
      chapterDoc.chapterNumber,
      chapterDoc.content,
      chapterDoc.views,
      chapterDoc.createdAt,
      chapterDoc.updatedAt
    );
  }
}

module.exports = MongoChapterRepository;