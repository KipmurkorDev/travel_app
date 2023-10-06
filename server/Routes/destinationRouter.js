const express = require("express");
const authMiddleware = require("../middleware/authVerification");
const {
  getAllDestinations,
  getDestination,
  addDestination,
  addBookMark,
  getBookmarkedAttractions,
  getWishList,
  addToWishlist,
  deleteWishList,
} = require("../Controllers/destinationsController");
const destinationRouter = express.Router();
// get all destinations
destinationRouter.get("/", getAllDestinations);

// add destination or destination by admin
destinationRouter.post("/", addDestination);

// get destination
destinationRouter.get("/:id", getDestination);

//  add destination to wishlist
destinationRouter.patch(
  "/wishlist/:destinationId",
  authMiddleware,
  addToWishlist
);

// get wishlist based on user
destinationRouter.get("/wishlist", getWishList);

// delete from wishlist
destinationRouter.delete("/wishlist/:id", authMiddleware, deleteWishList);

// Route to add a bookmark to an attraction within a destination
destinationRouter.patch(
  "/bookmark/:destinationId/:attractionId",
  authMiddleware,
  addBookMark
);

// Route to get bookmarked attractions for a user
destinationRouter.get(
  "/bookmarked-attractions/:userId",
  getBookmarkedAttractions
);
module.exports = destinationRouter;
