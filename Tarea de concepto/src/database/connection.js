const sql = require('mssql') //commonJS, otra alternativa sería ES modules

const dbSettings = { //La configuración de la base de datos
    user: "Campos",//"admin",
    password: "dhxaQmFTA3$",//"473YYJHP",
    server: "localhost",//"database-1.c0dtmimmbhm5.us-east-1.rds.amazonaws.com",
    database: "Almacen",//"Almacen",
    options: {
        encrypt: true, 
        trustServerCertificate:true //Certificado de veracidad
    }
};

module.exports = async function getConec() {
    const pool = await sql.connect(dbSettings) //el await es porque es asyncrono

    return pool
}

