const { FirebaseStorage } = require('../../../infastructure/storage/firebase');
const { LocalStorage } = require('../../../infastructure/storage/local');
const { config } = require('../../config');

const makeFileStorage = () => {
  // Tạm thời sử dụng local storage
    return new LocalStorage();
  
  // Khi đã cấu hình Firebase đúng, bạn có thể uncomment dòng này
  // return new FirebaseStorage();
};

module.exports = { makeFileStorage };