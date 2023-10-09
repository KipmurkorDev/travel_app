# API Documentation

This document provides an overview of the API routes available in the Destination Flutter App backend server. The API is designed to support the mobile application and provides functionality for managing destinations, user accounts, wishlists, and bookmarks.

## Destination Routes

### Get All Destinations

- **Route:** `GET /destinations`
- **Description:** Fetches a list of all destinations.
- **Access:** Public

### Get Destination by ID

- **Route:** `GET /destinations/:id`
- **Description:** Retrieves detailed information about a specific destination based on its ID.
- **Access:** Public

### Add Destination

- **Route:** `POST /destinations`
- **Description:** Adds a new destination to the database.
- **Access:** Public

### Get User's Wishlists

- **Route:** `GET /destinations/wishlist`
- **Description:** Fetches the user's wishlists, showing attractions they are interested in.
- **Access:** Protected (Requires Authentication)

### Add to Wishlist

- **Route:** `PATCH /destinations/wishlist/:destinationId`
- **Description:** Adds an attraction to the user's wishlist.
- **Access:** Protected (Requires Authentication)

### Remove from Wishlist

- **Route:** `DELETE /destinations/wishlist/:id`
- **Description:** Removes an attraction from the user's wishlist.
- **Access:** Protected (Requires Authentication)

### Get User's Bookmarked Attractions

- **Route:** `GET /destinations/bookmarked-attractions`
- **Description:** Retrieves the user's bookmarked attractions.
- **Access:** Protected (Requires Authentication)

### Add Bookmark

- **Route:** `PATCH /destinations/bookmark/:destinationId/:attractionId`
- **Description:** Adds an attraction to the user's bookmarks.
- **Access:** Protected (Requires Authentication)

### Remove Bookmark

- **Route:** `DELETE /destinations/bookmark/:attractionId`
- **Description:** Removes an attraction from the user's bookmarks.
- **Access:** Protected (Requires Authentication)

## User Routes

### User Signup

- **Route:** `POST /users/signup`
- **Description:** Allows users to sign up by providing necessary information.
- **Access:** Public

### User Login

- **Route:** `POST /users/login`
- **Description:** Allows users to log in and receive an authentication token.
- **Access:** Public

## Authentication Middleware

To access routes protected by authentication, you need to include a valid authentication token in the request headers. The `authMiddleware` is applied to routes that require authentication to ensure the user is logged in.

```javascript

```
