const ApplicationError = require('./ApplicationError');

class AuthenticationError extends ApplicationError {
  constructor(message = 'Authentication failed') {
    super(message, 401);
  }
}

module.exports = AuthenticationError;