const { uploadImage, uploadDocument, fixFormData } = require('../../../interfaces/middlewares/upload');
const { makeFileStorage } = require('../storage/FileStorageFactory');

const makeUploadMiddleware = () => {
  const fileStorage = makeFileStorage();
  
  return {
    uploadCoverImage: uploadImage('coverImage', 'novels/covers', fileStorage),
    uploadDocument: (fieldName) => uploadDocument(fieldName),
    fixFormData: fixFormData
  };
};

module.exports = { makeUploadMiddleware }; 