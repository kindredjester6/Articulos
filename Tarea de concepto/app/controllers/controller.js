const conex = require('../database/connection');

const loadDB = async (req,res) => {
    pool = await conex();

    result = await pool.request().query('use Almacen select * from Articulo') //espera a la base de datos
    res.json(result);
};

const getProduct = function (req, res) {
    res.send("Mostar tabla");
  };
  
const postProducts = function (req, res) {
    res.send("Insertar tabla");
  };

const noExist = function (req, res) {
    res.send("no existe");
  };

module.exports = {getProduct, postProducts, loadDB, noExist};