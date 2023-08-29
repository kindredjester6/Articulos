const conex = require('../database/connection');
const sql = require('mssql')

/*
const getSession = (req,res) => {


  const h1 = "<h2> hola!!! </h2>"
  res.send(
    `
    <h1>Pagina inicial</h1> ${h1}
    `
    )
};
*/

const getProduct = async (req,res) => {

  res.header('Access-Control-Allow-Origin', '*')
  pool = await conex();
  result = await pool
    .request()
    .query('use Almacen select * from Articulo'); //espera a la base de datos
  const listJson = result.recordset;

  console.log(listJson);

  res.send(listJson);
  };

const postProducts = async (req, res) => {
    const { Nombre, Precio } = req.body

    if (Nombre == "" || Precio <= 0 || Precio == null){
      return res.status(400).json({
        msg: 'Llene todos los campos'
      })
    }
    const pool = await conex();

    await pool.request()
    .input("nombre", sql.VarChar, Nombre)
    .input("precio", sql.Money, Precio)
    .query('spSimple @nombre, @precio')
    res.status(200).json({
      msg: 'Todo bién'
    })
  };


module.exports = {getProduct, postProducts};
