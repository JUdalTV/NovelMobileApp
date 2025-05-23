class ApplicationError extends Error {
    constructor(message, statusCode = 500, errors = []) {
      super(message);
      this.statusCode = statusCode;
      this.errors = errors;
      this.name = this.constructor.name;
      Error.captureStackTrace(this, this.constructor);
    }
  }
  
  module.exports = ApplicationError;