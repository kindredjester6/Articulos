
const conex = require('../database/connection')
const express = require("express");
const router = express.Router();

router.get('/', async (req,res) => {
    dbRes = await conex()
    res.json(dbRes)
})
// Home page route.
router.get("/TableArt", function (req, res) {
  res.send("Mostar tabla");
});

// About page route.
router.get("/InsertArt", function (req, res) {
  res.send("Insertar tabla");
});

//Create an article.
router.post("/InsertArt/:id", function (req, res) {

  res.send(req.params);
});

router.get("/:id", function (req, res) {
  res.send("no existe");
});

module.exports = router;