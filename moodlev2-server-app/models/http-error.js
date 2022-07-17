class HttpError extends Error {
    constructor(message, errorStatus) {
      super(message); // Add a "message" property
      this.status = errorStatus; // Adds a "status" property
    }
  }
  
  module.exports = HttpError;
