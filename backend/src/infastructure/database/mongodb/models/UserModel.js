const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: [true, 'Please add a username'],
    unique: true,
    trim: true,
    maxlength: [50, 'Username cannot be more than 50 characters']
  },
  email: {
    type: String,
    required: [true, 'Please add an email'],
    unique: true,
    match: [
      /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
      'Please add a valid email'
    ]
  },
  password: {
    type: String,
    required: [true, 'Please add a password'],
    minlength: [6, 'Password must be at least 6 characters'],
    select: false
  },
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user'
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  favorites: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Novel'
  }],
  readingHistory: [{
    novel: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Novel'
    },
    lastChapter: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Chapter'
    },
    lastRead: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

const UserModel = mongoose.model('User', UserSchema);

module.exports = UserModel;