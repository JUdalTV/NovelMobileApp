const dotenv = require('dotenv');

// Tải biến môi trường trước tất cả các import khác
dotenv.config();

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const mongoose = require('mongoose');
const path = require('path');

const { setupRoutes } = require('./src/interfaces/routes');
const { setupMiddlewares } = require('./src/interfaces/middlewares');
const { connectMongoDB } = require('./src/infastructure/database/mongodb');
const { setupFirebase } = require('./src/infastructure/storage/firebase');
const { config } = require('./src/main/config');

// Khởi tạo Express app
const app = express();
const PORT = process.env.PORT || 5000;
const ALT_PORT = 3000; // Alternative port

// CORS config chi tiết hơn
const corsOptions = {
  origin: ['http://localhost:3000', 'http://localhost:5000', 'http://localhost', 'http://10.0.2.2:5000', 'http://127.0.0.1:5000', 'http://192.168.1.10:5000'],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin', 'X-Requested-With'],
  exposedHeaders: ['Content-Length', 'X-Total-Count'],
  credentials: true,
  optionsSuccessStatus: 200,
  maxAge: 86400 // 24 hours
};

// Middleware cơ bản
app.use(helmet({ 
  crossOriginResourcePolicy: { policy: "cross-origin" },
  crossOriginOpenerPolicy: { policy: "unsafe-none" }
}));
app.use(cors(corsOptions));
app.use(express.json({ limit: '10mb' })); // Increase JSON size limit
app.use(express.urlencoded({ extended: true, limit: '10mb' })); // Increase URL-encoded size limit
app.use(morgan('dev'));

// Phục vụ các file tĩnh
app.use('/uploads', express.static(path.join(__dirname, 'public/uploads')));

// Thiết lập middleware tùy chỉnh
setupMiddlewares(app);

// Kết nối MongoDB
connectMongoDB().then(() => {
  console.log('MongoDB Connected');
}).catch(err => {
  console.error('MongoDB Connection Error:', err);
  process.exit(1);
});

// Khởi tạo Firebase nếu cần
setupFirebase();

// Thiết lập routes
setupRoutes(app);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error details:', {
    name: err.name,
    message: err.message,
    code: err.code,
    field: err.field,
    stack: err.stack
  });
  
  // Multer error
  if (err.name === 'MulterError') {
    return res.status(400).json({
      success: false,
      message: `Lỗi upload file: ${err.message}`,
      errors: [`Lỗi ở trường ${err.field || 'không xác định'}: ${err.code}`]
    });
  }
  
  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    errors: err.errors || []
  });
});

// Khởi động server trên cổng chính
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`Server URL: http://localhost:${PORT}`);
  
  // Hiển thị địa chỉ IP để dễ truy cập từ thiết bị khác
  const os = require('os');
  const networkInterfaces = os.networkInterfaces();
  const addresses = [];
  
  Object.keys(networkInterfaces).forEach(interfaceName => {
    const interfaces = networkInterfaces[interfaceName];
    interfaces.forEach(iface => {
      // Bỏ qua interface loopback và non-IPv4
      if ('IPv4' !== iface.family || iface.internal !== false) return;
      addresses.push(`http://${iface.address}:${PORT}`);
    });
  });
  
  console.log('Network URLs:');
  addresses.forEach(address => console.log(`  ${address}`));
});

// Khởi động server trên cổng phụ (alternative port)
// Tạo một instance mới của app
const altApp = express();
altApp.use(cors(corsOptions));
altApp.use(express.json({ limit: '10mb' }));
altApp.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Thiết lập redirect từ cổng phụ đến cổng chính
altApp.use((req, res, next) => {
  setupRoutes(altApp); // Thiết lập routes giống như app chính
  next();
});

// Khởi động server trên cổng phụ
altApp.listen(ALT_PORT, '0.0.0.0', () => {
  console.log(`Alternative server running on port ${ALT_PORT}`);
  console.log(`Alternative server URL: http://localhost:${ALT_PORT}`);
});

module.exports = app;