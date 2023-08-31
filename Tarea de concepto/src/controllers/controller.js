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

/**
 * 
 * @param {*} req //No se usa de momento
 * @param {*} res //Este parametro se usa para enviarle una respuesta al cliente
 */
const getProduct = async (req,res) => {


  res.header('Access-Control-Allow-Origin', '*')
  const pool = await conex();
  const result = await pool
    .request()
    .query('spOrdenarLista'); //espera a la base de datos
  const listJson = result.recordset;

  console.log(listJson);

  res.send(listJson);
  };

/**
 * 
 * @param {*} req Este recibe unos datos del cliente para luego
 * introducirlos a la base de datos por medio de sp's.
 * @param {*} res Este envia el estado del servidor al cliente y 
 * si se logró introducir el elemento al BD
 * @returns Este retorna el estado del servidor, 
 * el 400 indica una mala solicitud de parte del cliente
 */
const postProducts = async (req, res) => {
  const { Nombre, Precio } = req.body

  if (Nombre == "" || Precio <= 0 || Precio == null){
    return res.status(400).json({
        Result: 50002
        , msg:'Datos incompletos'
    })
  }
    const pool = await conex();

  const result = await pool
    .request()
    .input("nombre", sql.VarChar, Nombre)
    .input("precio", sql.Money, Precio)
    .query('spInsertarArticulo @nombre, @precio')
  console.log(result.recordset[0])
  res.status(200).json(result.recordset[0])
  };


module.exports = {getProduct, postProducts};
