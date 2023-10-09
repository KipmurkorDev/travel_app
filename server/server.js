const express = require("express");
require("dotenv").config();
const app = express();
const cors = require("cors");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const morgan = require("morgan");
const router = require("./Routes/index");
app.use(cors());
app.use(bodyParser.json());
app.use(morgan("tiny"));
app.use(express.urlencoded({ extended: false }));
mongoose
  .connect(process.env.DB_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected..."))
  .catch((err) => console.log(err));

app.use("", router);

const port = process.env.PORT || 80;
app.listen(port, () => {
  console.log(`Server running ....${port}`);
});
