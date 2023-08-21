const sql = require('mssql')

const dbSettings = {
    user: 'admin',
    password: '473YYJHP',
    server: 'database-1.c0dtmimmbhm5.us-east-1.rds.amazonaws.com',
    database: 'Almacén',
    options: {
        encrypt: true,
        trustServerCertificate:true
    }
};

module.exports = async function getConec() {
    const pool = await sql.connect(dbSettings) //el await es porque es asyncrono

    result = await pool.request().query('select 1')

    return result

}

//exports.done = 'hola'
