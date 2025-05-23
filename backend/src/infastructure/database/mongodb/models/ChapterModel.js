const mongoose = require('mongoose');

const ChapterSchema = new mongoose.Schema({
  novel: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Novel',
    required: true
  },
  title: {
    type: String,
    required: [true, 'Please add a chapter title'],
    trim: true,
    maxlength: [200, 'Title cannot be more than 200 characters']
  },
  chapterNumber: {
    type: Number,
    required: [true, 'Please add a chapter number']
  },
  content: {
    type: String,
    required: [true, 'Please add chapter content']
  },
  views: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

// Ensure that novel and chapterNumber combination is unique
ChapterSchema.index({ novel: 1, chapterNumber: 1 }, { unique: true });

const ChapterModel = mongoose.model('Chapter', ChapterSchema);

module.exports = ChapterModel;