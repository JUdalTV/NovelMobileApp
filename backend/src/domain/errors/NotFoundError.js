const ApplicationError = require('./ApplicationError');

class NotFoundError extends ApplicationError {
  constructor(message = 'Resource not found') {
    super(message, 404);
  }
}

module.exports = NotFoundError;