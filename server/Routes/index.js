const authorRouter = require("./userRouter");
const destinationRouter = require("./destinationRouter");
const express = require("express");
const router = express.Router();

router.use("/users", authorRouter);
router.use("/destinations", destinationRouter);
module.exports = router;
