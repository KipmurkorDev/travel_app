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
destinationRouter.get("/wishlist/", authMiddleware, getWishLists);
destinationRouter.get(
  "/bookmarked-attractions",
  authMiddleware,
  getBookmarkedAttractions
);
destinationRouter.get("/:id", getDestination);
destinationRouter.post("/", addDestination);

// Routes protected by authMiddleware
destinationRouter.use(authMiddleware);
destinationRouter.patch("/wishlist/:destinationId", addToWishlist);
destinationRouter.delete("/wishlist/:id", deleteWishList);
destinationRouter.patch("/bookmark/:destinationId/:attractionId", addBookMark);

module.exports = destinationRouter;
