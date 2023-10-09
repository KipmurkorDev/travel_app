const mongoose = require("mongoose");

const attractionSchema = new mongoose.Schema({
  name: String,
  description: String,
  image: String,
  bookmarkedBy: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Author",
    },
  ],
});

const destinationSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    required: true,
  },
  attractions: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Attraction",
    },
  ],
  wishlist: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Author",
    },
  ],
  bookmarks: [
    {
      authorId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Author",
      },
      attractionId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Attraction",
      },
    },
  ],
});

const Destination = mongoose.model("Destination", destinationSchema);
const Attraction = mongoose.model("Attraction", attractionSchema);

module.exports = { Destination, Attraction };
