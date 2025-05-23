const { validate, validateQuery, validateParams } = require('../../../interfaces/middlewares/validate');

const makeValidationMiddleware = () => {
  return {
    validate: (schema) => validate(schema),
    validateQuery: (schema) => validateQuery(schema),
    validateParams: (schema) => validateParams(schema)
  };
};

module.exports = { makeValidationMiddleware }; 