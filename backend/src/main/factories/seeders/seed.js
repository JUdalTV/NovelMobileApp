const mongoose = require('mongoose');
const { connectMongoDB } = require('../../../infastructure/database/mongodb');
const { makeCategoryRepository } = require('../repositories/CategoryRepositoryFactory');
const slugify = require('slugify');

const seedCategories = async () => {
  const categoryRepository = makeCategoryRepository();
  
  const categories = [
    { name: 'Tu Tiên', description: 'Thể loại tu tiên cổ điển' },
    { name: 'Huyền Huyễn', description: 'Thể loại huyền ảo kỳ bí' },
    { name: 'Đô Thị', description: 'Thể loại đời sống đô thị hiện đại' },
    { name: 'Kiếm Hiệp', description: 'Thể loại võ lâm kiếm hiệp' },
    { name: 'Khoa Huyễn', description: 'Thể loại khoa học viễn tưởng' },
    { name: 'Lịch Sử', description: 'Thể loại lịch sử cổ đại' },
    { name: 'Quân Sự', description: 'Thể loại quân sự chiến tranh' },
    { name: 'Dị Giới', description: 'Thể loại thế giới khác' }
  ];

  for (const category of categories) {
    try {
      await categoryRepository.create({
        ...category,
        slug: slugify(category.name, { lower: true, locale: 'vi' })
      });
      console.log(`Created category: ${category.name}`);
    } catch (error) {
      console.error(`Error creating category ${category.name}:`, error.message);
    }
  }
};

const seed = async () => {
  try {
    await connectMongoDB();
    console.log('Connected to MongoDB for seeding');
    
    await seedCategories();
    
    console.log('Seeding completed!');
    process.exit(0);
  } catch (error) {
    console.error('Seeding failed:', error);
    process.exit(1);
  }
};

// Run seeding if this file is executed directly
if (require.main === module) {
  seed();
}

module.exports = { seed }; 