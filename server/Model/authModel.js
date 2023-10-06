const mongoose = require("mongoose");

const authorSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    trim: true,
    lowercase: true,
    unique: true,
    required: "Email address is required",
  },
  password: {
    type: String,
    required: true,
  },
});
const authorModel = mongoose.model("Author", authorSchema);
module.exports = authorModel;
