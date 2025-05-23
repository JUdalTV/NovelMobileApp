const ApplicationError = require('./ApplicationError');

class ValidationError extends ApplicationError {
  constructor(message = 'Validation failed', errors = []) {
    super(message, 400, errors);
  }
}

module.exports = ValidationError;