const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  message: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['system', 'novel', 'comment', 'user'],
    default: 'system'
  },
  relatedTo: {
    novel: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Novel'
    },
    chapter: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Chapter'
    },
    comment: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Comment'
    }
  },
  isRead: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Index để lấy thông báo chưa đọc
notificationSchema.index({ user: 1, isRead: 1, createdAt: -1 });

const Notification = mongoose.model('Notification', notificationSchema);
module.exports = Notification;