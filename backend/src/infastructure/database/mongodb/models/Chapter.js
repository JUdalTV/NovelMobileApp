const mongoose = require('mongoose');
const slugify = require('slugify');

const chapterSchema = new mongoose.Schema({
  novel: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Novel',
    required: true
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  slug: {
    type: String
  },
  number: {
    type: Number,
    required: true
  },
  content: {
    type: String,
    required: true
  },
  viewCount: {
    type: Number,
    default: 0
  },
  isPublished: {
    type: Boolean,
    default: true
  },
  publishSchedule: {
    type: Date,
    default: null
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
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

// Compound index for novel + number uniqueness
chapterSchema.index({ novel: 1, number: 1 }, { unique: true });

// Pre-save hook for slug generation
chapterSchema.pre('save', function(next) {
  if (!this.isModified('title')) return next();
  
  this.slug = slugify(this.title, {
    lower: true,
    strict: true
  });
  next();
});

// Pre-save hook to update novel's lastUpdated and chapterCount
chapterSchema.pre('save', async function(next) {
  if (this.isNew && this.isPublished) {
    try {
      const Novel = mongoose.model('Novel');
      await Novel.findByIdAndUpdate(this.novel, {
        $inc: { chapterCount: 1 },
        lastUpdated: Date.now()
      });
    } catch (error) {
      next(error);
    }
  }
  next();
});

// Method to increment view count
chapterSchema.methods.incrementViewCount = async function() {
  this.viewCount += 1;
  await this.save();
  
  // Also increment novel view count
  const Novel = mongoose.model('Novel');
  await Novel.findByIdAndUpdate(this.novel, {
    $inc: { viewCount: 1 }
  });
};

module.exports = mongoose.model('Chapter', chapterSchema);