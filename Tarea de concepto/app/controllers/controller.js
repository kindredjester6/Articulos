const conex = require('../database/connection');
const sql = require('mssql')

const loadDB = async (req,res) => {
    pool = await conex();
    
    result = await pool.request().query('use Almacen select * from Articulo') //espera a la base de datos
    console.log(result.recordset)
    res.json(result.recordset);
    const json = result.recordset
    const listObj = JSON.parse(json)
    console.log(listObj)
};

const getProduct = (req, res)=>{
    
    res.json("Mostar tabla");
  };
  
const postProducts = async (req, res) => {
    const { Nombre, Precio } = req.body

    if (Nombre == null || Precio == 0){
      return res.status(400).json({
        msg: 'Llene todos los campos'
      })
    }
    const pool = await conex();

    await pool.request()
    .input("nombre", sql.VarChar, "NombreArt")
    .input("precio", sql.Money, 10)
    .query('spSimple @nombre, @precio')
    res.json("Insertar articulos")
  };

const noExist =  (req, res) => {

    res.json("no existe");
  };

module.exports = {getProduct, postProducts, loadDB, noExist};
