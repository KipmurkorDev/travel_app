const express = require("express");
const authMiddleware = require("../middleware/authVerification");
const {
  getAllDestinations,
  getDestination,
  addDestination,
  getWishLists,
  addToWishlist,
  deleteWishList,
  getBookmarkedAttractions,
  addBookMark,
} = require("../Controllers/destinationsController");
const destinationRouter = express.Router();

// Public routes
destinationRouter.get("/", getAllDestinations);
destinationRouter.get("/:id", getDestination);
destinationRouter.post("/", addDestination);
destinationRouter.get("/wishlist/", getAllDestinations);
// Routes protected by authMiddleware
destinationRouter.use(authMiddleware);
destinationRouter.patch("/wishlist/:destinationId", addToWishlist);
destinationRouter.delete("/wishlist/:id", deleteWishList);
destinationRouter.patch("/bookmark/:destinationId/:attractionId", addBookMark);
destinationRouter.get(
  "/bookmarked-attractions/:userId",
  getBookmarkedAttractions
);

module.exports = destinationRouter;
