const { UserRepository } = require('../../../../domain/repositories');
const { User } = require('../../../../domain/entities');
const { UserModel } = require('../models');
const { NotFoundError } = require('../../../../domain/errors');

class MongoUserRepository extends UserRepository {
  async findById(id) {
    const userDoc = await UserModel.findById(id);
    if (!userDoc) return null;

    return this._mapToEntity(userDoc);
  }

  async findByEmail(email) {
    const userDoc = await UserModel.findOne({ email }).select('+password');
    if (!userDoc) return null;

    return this._mapToEntity(userDoc);
  }

  async findByUsername(username) {
    const userDoc = await UserModel.findOne({ username });
    if (!userDoc) return null;

    return this._mapToEntity(userDoc);
  }

  async create(userData) {
    const userDoc = await UserModel.create(userData);
    return this._mapToEntity(userDoc);
  }

  async update(id, userData) {
    const userDoc = await UserModel.findByIdAndUpdate(id, userData, {
      new: true,
      runValidators: true
    });

    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    return this._mapToEntity(userDoc);
  }

  async delete(id) {
    const userDoc = await UserModel.findByIdAndDelete(id);
    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    return true;
  }

  async verifyEmail(id) {
    const userDoc = await UserModel.findByIdAndUpdate(
      id,
      { isVerified: true },
      { new: true }
    );

    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    return this._mapToEntity(userDoc);
  }

  async addToFavorites(userId, novelId) {
    const userDoc = await UserModel.findByIdAndUpdate(
      userId,
      { $addToSet: { favorites: novelId } },
      { new: true }
    );

    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    return this._mapToEntity(userDoc);
  }

  async removeFromFavorites(userId, novelId) {
    const userDoc = await UserModel.findByIdAndUpdate(
      userId,
      { $pull: { favorites: novelId } },
      { new: true }
    );

    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    return this._mapToEntity(userDoc);
  }

  async updateReadingHistory(userId, novelId, chapterId) {
    const userDoc = await UserModel.findById(userId);
    
    if (!userDoc) {
      throw new NotFoundError('User not found');
    }

    // Find the existing history entry
    const historyIndex = userDoc.readingHistory.findIndex(
      history => history.novel.toString() === novelId
    );

    if (historyIndex !== -1) {
      // Update existing entry
      userDoc.readingHistory[historyIndex].lastChapter = chapterId;
      userDoc.readingHistory[historyIndex].lastRead = new Date();
    } else {
      // Add new entry
      userDoc.readingHistory.push({
        novel: novelId,
        lastChapter: chapterId,
        lastRead: new Date()
      });
    }

    await userDoc.save();
    return this._mapToEntity(userDoc);
  }

  _mapToEntity(userDoc) {
    return new User(
      userDoc._id.toString(),
      userDoc.username,
      userDoc.email,
      userDoc.password,
      userDoc.role,
      userDoc.isVerified,
      userDoc.createdAt,
      userDoc.updatedAt
    );
  }
}

module.exports = MongoUserRepository;