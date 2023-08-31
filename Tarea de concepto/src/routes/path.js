const conex = require('../database/connection')
const express = require("express");
const router = express.Router();
const controller = require('../controllers/controller')

// Home page route.
//router.get('/', controller.getSession)

//Envia una lista con elementos JSON
router.get("/ListaJson", controller.getProduct);

// Create an article.
router.post("/InsertArt", controller.postProducts);


module.exports = router;
