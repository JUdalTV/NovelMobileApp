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