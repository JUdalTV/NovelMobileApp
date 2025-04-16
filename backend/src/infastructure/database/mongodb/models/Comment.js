const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true,
    trim: true
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  novel: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Novel'
  },
  chapter: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Chapter'
  },
  parent: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Comment'
  },
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  isApproved: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Index cho tìm kiếm comments
commentSchema.index({ novel: 1, createdAt: -1 });
commentSchema.index({ chapter: 1, createdAt: -1 });
commentSchema.index({ parent: 1 });

const Comment = mongoose.model('Comment', commentSchema);
module.exports = Comment;

// File: models/Rating.js
const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  novel: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Novel',
    required: true
  },
  score: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  },
  review: {
    type: String,
    trim: true
  }
}, {
  timestamps: true
});

// Mỗi user chỉ có thể đánh giá một novel một lần
ratingSchema.index({ user: 1, novel: 1 }, { unique: true });

const Rating = mongoose.model('Rating', ratingSchema);
module.exports = Rating;