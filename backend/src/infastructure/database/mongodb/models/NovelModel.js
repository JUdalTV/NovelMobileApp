const mongoose = require('mongoose');
const slugify = require('slugify');

const NovelSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please add a title'],
    unique: true,
    trim: true,
    maxlength: [200, 'Title cannot be more than 200 characters']
  },
  author: {
    type: String,
    required: [true, 'Please add an author name'],
    trim: true,
    maxlength: [100, 'Author name cannot be more than 100 characters']
  },
  slug: {
    type: String,
    unique: true
  },
  description: {
    type: String,
    required: [true, 'Please add a description']
  },
  coverImage: {
    type: String,
    default: 'no-image.jpg'
  },
  categories: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Category'
  }],
  tags: [String],
  status: {
    type: String,
    enum: ['ongoing', 'completed', 'hiatus'],
    default: 'ongoing'
  },
  views: {
    type: Number,
    default: 0
  },
  rating: {
    type: Number,
    default: 0,
    min: [0, 'Rating must be at least 0'],
    max: [5, 'Rating cannot be more than 5']
  },
  totalChapters: {
    type: Number,
    default: 0
  },
  totalRatings: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Create novel slug from the title
NovelSchema.pre('save', function(next) {
  if (this.isModified('title')) {
    this.slug = slugify(this.title, { lower: true });
  }
  next();
});

// Cascade delete chapters when a novel is deleted
NovelSchema.pre('remove', async function(next) {
  await this.model('Chapter').deleteMany({ novel: this._id });
  next();
});

// Reverse populate with virtuals
NovelSchema.virtual('chapters', {
  ref: 'Chapter',
  localField: '_id',
  foreignField: 'novel',
  justOne: false
});

const NovelModel = mongoose.model('Novel', NovelSchema);

module.exports = NovelModel;