const { Destination, Attraction } = require("../Model/destinationModel"); // Import the Destination model
// Controller function to get all destinations
const getAllDestinations = async (req, res) => {
  try {
    const destinations = await Destination.find(
      {},
      { name: 1, description: 1, image: 1 }
    );
    res.status(200).json(destinations);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};
const addDestination = async (req, res) => {
  try {
    // Extract destination data from the request body
    const { name, description, image, attractions } = req.body;

    if (!name || !description || !image || attractions.length === 0) {
      return res.status(400).json({
        error: "Bad Request",
        message:
          "One or more required fields are missing or attractions array is empty.",
      });
    }
    // Create an array to hold the attraction IDs
    const attractionIds = [];

    // Iterate through the attractions data and create attraction objects
    for (const attractionData of attractions) {
      const { name, description } = attractionData;

      // Create a new attraction using the Attraction model
      const newAttraction = new Attraction({
        name,
        description,
      });

      // Save the new attraction to the database
      const savedAttraction = await newAttraction.save();

      // Push the ID of the saved attraction to the array
      attractionIds.push(savedAttraction._id);
    }

    // Create a new destination object with the attraction IDs
    const newDestination = new Destination({
      name,
      description,
      image,
      attractions: attractionIds,
    });

    // Save the new destination to the database
    const savedDestination = await newDestination.save();

    res.status(201).json(savedDestination);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Controller function to get a destination by ID
const getDestination = async (req, res) => {
  try {
    const destinationId = req.params.id;

    // Find the destination by ID in the database, populate the 'attractions' field
    const destination = await Destination.findById(destinationId)
      .populate("attractions")
      .exec();

    if (!destination) {
      return res.status(404).json({ error: "Destination not found" });
    }

    res.status(200).json(destination); // Respond with the destination and populated attractions as JSON
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Controller to add a destination to a user's wishlist
const addToWishlist = async (req, res) => {
  try {
    const { destinationId } = req.params;
    const userId = res.locals.author;

    // Check if the destination and user exist
    const destination = await Destination.findById(destinationId);
    if (!destination) {
      return res.status(404).json({ message: "Destination not found." });
    }

    // Check if the user is already in the destination's wishlist
    const isUserInWishlist = destination.wishlist.includes(userId);
    if (isUserInWishlist) {
      return res
        .status(400)
        .json({ message: "User already in destination wishlist." });
    }

    // Add the user to the destination's wishlist
    destination.wishlist.push(userId);
    await destination.save();

    res
      .status(200)
      .json({ message: "Destination added to wishlist successfully." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Controller function to get a user's wishlist of destinations
const getWishList = async (req, res) => {
  try {
    console.log("userId:");
    const userId = res.locals.author;

    // Find all destinations where the user's ID appears in the wishlist
    const destinations = await Destination.find({
      wishlist: userId,
    });

    if (destinations.length === 0) {
      return res
        .status(404)
        .json({ error: "No destinations found in wishlist" });
    }

    res.status(200).json(destinations);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Controller function to delete a destination from a user's wishlist
const deleteWishList = async (req, res) => {
  try {
    const userId = res.locals.author;
    const destinationId = req.params.id;

    // Find the destination by ID in the database
    const destination = await Destination.findOne({
      "wishlist.authorId": userId,
      _id: destinationId,
    });

    if (!destination) {
      return res
        .status(404)
        .json({ error: "Destination not found in wishlist" });
    }

    // Remove the user's ID from the wishlist
    destination.wishlist = destination.wishlist.filter(
      (item) => !item.authorId.equals(userId)
    );
    await destination.save();

    res.status(200).json({ message: "Destination removed from wishlist" });
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Controller function to add a bookmark to an attraction within a destination
const addBookMark = async (req, res) => {
  try {
    const { destinationId, attractionId } = req.params;
    const userId = req.body.userId;

    // Find the destination by ID
    const destination = await Destination.findById(destinationId);

    if (!destination) {
      return res.status(404).json({ error: "Destination not found" });
    }

    // Find the attraction by ID
    const attraction = await Attraction.findById(attractionId);

    if (!attraction) {
      return res.status(404).json({ error: "Attraction not found" });
    }

    // Check if the user has already bookmarked this attraction
    const isAlreadyBookmarked = attraction.bookmarkedBy.includes(userId);

    if (isAlreadyBookmarked) {
      return res
        .status(400)
        .json({ error: "Attraction already bookmarked by the user" });
    }

    // Add the user's ID to the attraction's bookmarkedBy array
    attraction.bookmarkedBy.push(userId);
    await attraction.save();

    res.status(201).json({ message: "Attraction bookmarked successfully" });
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Controller function to get bookmarked attractions for a user
const getBookmarkedAttractions = async (req, res) => {
  try {
    const userId = res.locals.author;

    // Find attractions where the user has bookmarked attractions
    const bookmarkedAttractions = await Attraction.find({
      bookmarkedBy: userId,
    });

    res.status(200).json(bookmarkedAttractions);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
};

module.exports = {
  getAllDestinations,
  addDestination,
  getDestination,
  getWishList,
  addBookMark,
  deleteWishList,
  getBookmarkedAttractions,
  addToWishlist,
};
