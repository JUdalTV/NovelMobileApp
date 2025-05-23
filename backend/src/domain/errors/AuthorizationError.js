const ApplicationError = require('./ApplicationError');

class AuthorizationError extends ApplicationError {
  constructor(message = 'Not authorized to access this resource') {
    super(message, 403);
  }
}

module.exports = AuthorizationError;