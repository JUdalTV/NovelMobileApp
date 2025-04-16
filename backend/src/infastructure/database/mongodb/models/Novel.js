const mongoose = require('mongoose');
const slugify = require('slugify');

const novelSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  slug: {
    type: String,
    unique: true
  },
  author: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  coverImage: {
    type: String,
    default: ''
  },
  categories: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Category',
    required: true
  }],
  status: {
    type: String,
    enum: ['ongoing', 'completed', 'hiatus'],
    default: 'ongoing'
  },
  isPublished: {
    type: Boolean,
    default: true
  },
  isAdult: {
    type: Boolean,
    default: false
  },
  viewCount: {
    type: Number,
    default: 0
  },
  averageRating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  ratingCount: {
    type: Number,
    default: 0
  },
  chapterCount: {
    type: Number,
    default: 0
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  bookmarkCount: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Pre-save hook to create slug
novelSchema.pre('save', function(next) {
  if (!this.isModified('title')) return next();
  
  this.slug = slugify(this.title, {
    lower: true,
    strict: true
  });
  next();
});

// Method to update rating stats
novelSchema.methods.updateRatingStats = async function(newRating, oldRating = null) {
  if (oldRating) {
    // Updating existing rating
    this.averageRating = ((this.averageRating * this.ratingCount) - oldRating + newRating) / this.ratingCount;
  } else {
    // Adding new rating
    this.ratingCount++;
    this.averageRating = ((this.averageRating * (this.ratingCount - 1)) + newRating) / this.ratingCount;
  }
  
  await this.save();
};

// Static method to get popular novels
novelSchema.statics.getPopular = function(limit = 10) {
  return this.find({ isPublished: true })
    .sort({ viewCount: -1 })
    .limit(limit)
    .populate('categories', 'name');
};

module.exports = mongoose.model('Novel', novelSchema);
