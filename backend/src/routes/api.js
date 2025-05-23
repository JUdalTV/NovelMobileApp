const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const auth = require('../middleware/auth');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// User routes
router.get('/users', auth, async (req, res) => {
  try {
    const users = await User.find().select('-password');
    res.json(users);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

router.post('/users', [
  auth,
  body('username', 'Username is required').not().isEmpty(),
  body('email', 'Please include a valid email').isEmail(),
  body('role', 'Role is required').isIn(['admin', 'user', 'moderator']),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { username, email, role, isVerified } = req.body;
    const user = new User({
      username,
      email,
      role,
      isVerified: isVerified || false
    });
    await user.save();
    res.json(user);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

// Novel routes
router.get('/novels', auth, async (req, res) => {
  try {
    const novels = await Novel.find();
    res.json(novels);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

router.post('/novels', [
  auth,
  body('title', 'Title is required').not().isEmpty(),
  body('author', 'Author is required').not().isEmpty(),
  body('genre', 'Genre is required').not().isEmpty(),
  body('status', 'Status is required').isIn(['published', 'draft', 'archived']),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const novel = new Novel(req.body);
    await novel.save();
    res.json(novel);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

// Comment routes
router.get('/comments', auth, async (req, res) => {
  try {
    const comments = await Comment.find();
    res.json(comments);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

router.post('/comments', [
  auth,
  body('content', 'Content is required').not().isEmpty(),
  body('userId', 'User ID is required').not().isEmpty(),
  body('novelId', 'Novel ID is required').not().isEmpty(),
  body('status', 'Status is required').isIn(['active', 'hidden', 'reported']),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const comment = new Comment(req.body);
    await comment.save();
    res.json(comment);
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

// Admin registration route
router.post('/admin/register', [
  body('username', 'Username is required').not().isEmpty(),
  body('email', 'Please include a valid email').isEmail(),
  body('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 }),
  body('adminKey', 'Admin registration key is required').equals(process.env.ADMIN_REGISTRATION_KEY)
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { username, email, password } = req.body;

    // Check if user already exists
    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ msg: 'User already exists' });
    }

    // Create new admin user
    user = new User({
      username,
      email,
      password,
      role: 'admin',
      isVerified: true
    });

    // Hash password
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(password, salt);

    await user.save();

    // Create JWT token
    const payload = {
      user: {
        id: user.id,
        role: user.role
      }
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '24h' },
      (err, token) => {
        if (err) throw err;
        res.json({ token });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router; 