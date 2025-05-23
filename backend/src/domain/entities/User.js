class User {
    constructor(id, username, email, password, role = 'user', isVerified = false, createdAt = new Date(), updatedAt = new Date()) {
      this.id = id;
      this.username = username;
      this.email = email;
      this.password = password;
      this.role = role;
      this.isVerified = isVerified;
      this.createdAt = createdAt;
      this.updatedAt = updatedAt;
    }
  }
  
  module.exports = User;