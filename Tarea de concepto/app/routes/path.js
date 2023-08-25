const conex = require('../database/connection')
const express = require("express");
const router = express.Router();
const controller = require('../controllers/controller')

// Home page route.
router.get('/', controller.loadDB)

// Articles pages
router.get("/TableArt", controller.getProduct);

// Create an articles.
router.post("/InsertArt", controller.postProducts);


router.get("/:id", controller.noExist);

module.exports = router;