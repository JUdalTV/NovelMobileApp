const { FirebaseStorage } = require('./firebase');
const LocalStorage = require('./local');

class StorageFactory {
  static createStorage(type = 'local') {
    switch (type.toLowerCase()) {
      case 'firebase':
        return new FirebaseStorage();
      case 'local':
      default:
        return new LocalStorage();
    }
  }
}

module.exports = {
  StorageFactory
};