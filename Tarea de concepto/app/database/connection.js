const sql = require('mssql')

const dbSettings = {
    user: "Campos",//"admin",
    password: "dhxaQmFTA3$",//"473YYJHP",
    server: "localhost",//"database-1.c0dtmimmbhm5.us-east-1.rds.amazonaws.com",
    database: "Almacen",//"Almacén",
    options: {
        encrypt: true,
        trustServerCertificate:true
    }
};

module.exports = async function getConec() {
    const pool = await sql.connect(dbSettings) //el await es porque es asyncrono

    return pool

}

//exports.done = 'holas'
