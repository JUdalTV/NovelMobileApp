const admin = require('firebase-admin');
const { getStorage } = require('firebase-admin/storage');

let firebaseApp = null;

const setupFirebase = () => {
  // Kiểm tra xem tất cả các biến môi trường Firebase cần thiết có tồn tại không
  if (!firebaseApp && 
      process.env.FIREBASE_PROJECT_ID && 
      process.env.FIREBASE_CLIENT_EMAIL && 
      process.env.FIREBASE_PRIVATE_KEY && 
      process.env.FIREBASE_STORAGE_BUCKET) {
    try {
      // Initialize Firebase Admin
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
        }),
        storageBucket: process.env.FIREBASE_STORAGE_BUCKET
      });
      
      console.log('Firebase initialized successfully');
    } catch (error) {
      console.error('Failed to initialize Firebase:', error);
    }
  } else {
    console.warn('Firebase configuration not found or incomplete. Firebase storage will not be available.');
  }
  
  return firebaseApp;
};

class FirebaseStorage {
  constructor() {
    this.isAvailable = false;
    
    if (!firebaseApp) {
      setupFirebase();
    }
    
    if (firebaseApp) {
      try {
        this.bucket = getStorage().bucket();
        this.isAvailable = true;
      } catch (error) {
        console.error('Error initializing Firebase Storage:', error);
      }
    }
  }

  async uploadFile(file, destination) {
    if (!this.isAvailable) {
      console.warn('Firebase Storage is not available. File upload skipped.');
      // Return a mock URL or local path as fallback
      return `/uploads/${destination}`;
    }
    
    try {
      // Create a file object
      const fileUpload = this.bucket.file(destination);
      
      // Create a write stream
      const blobStream = fileUpload.createWriteStream({
        metadata: {
          contentType: file.mimetype
        }
      });
      
      // Return promise
      return new Promise((resolve, reject) => {
        blobStream.on('error', (error) => {
          reject(error);
        });
        
        blobStream.on('finish', () => {
          // Make the file public
          fileUpload.makePublic().then(() => {
            // Get public URL
            const publicUrl = `https://storage.googleapis.com/${this.bucket.name}/${fileUpload.name}`;
            resolve(publicUrl);
          });
        });
        
        blobStream.end(file.buffer);
      });
    } catch (error) {
      console.error('Error uploading file to Firebase:', error);
      throw error;
    }
  }

  async deleteFile(fileUrl) {
    if (!this.isAvailable) {
      console.warn('Firebase Storage is not available. File deletion skipped.');
      return true;
    }
    
    try {
      // Extract file path from URL
      const filePathRegex = /https:\/\/storage\.googleapis\.com\/[^\/]+\/(.+)/;
      const match = fileUrl.match(filePathRegex);
      
      if (!match) {
        throw new Error('Invalid file URL format');
      }
      
      const filePath = match[1];
      const file = this.bucket.file(filePath);
      
      // Check if file exists
      const [exists] = await file.exists();
      if (!exists) {
        console.warn(`File ${filePath} does not exist in storage`);
        return true;
      }
      
      // Delete the file
      await file.delete();
      return true;
    } catch (error) {
      console.error('Error deleting file from Firebase:', error);
      throw error;
    }
  }
}

// Export both the setup function and the storage class
module.exports = {
  setupFirebase,
  FirebaseStorage
};