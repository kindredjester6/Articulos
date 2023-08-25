const express = require('express')
const rutas = require('./routes/path')
const app = express() //commonJS
const config = require('./config')

app.disable('x-powered-by')//desabilitar marca de agua
 //recordar mover

app.use(express.json());
app.use(express.urlencoded({ extended:false }));

app.use('/', rutas);

app.listen(config.PORT, async ()=> {
    console.log(`server listening on port http://localhost:${config.PORT}`)
});
