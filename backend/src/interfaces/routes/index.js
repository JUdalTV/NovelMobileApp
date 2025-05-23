const authRoutes = require('./auth.routes');
const novelRoutes = require('./novel.routes');
const chapterRoutes = require('./chapter.routes');
const categoryRoutes = require('./category.routes');
const adminRoutes = require('./admin.routes');

function setupRoutes(app) {
  app.use('/api/auth', authRoutes);
  app.use('/api/novels', novelRoutes);
  app.use('/api/chapters', chapterRoutes);
  app.use('/api/categories', categoryRoutes);
  app.use('/api/admin', adminRoutes);
}

module.exports = { setupRoutes };