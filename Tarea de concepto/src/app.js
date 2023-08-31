const express = require('express')
const rutas = require('./routes/path')
const app = express() //commonJS
const cors = require('cors')
const config = require('./config')

app.disable('x-powered-by')//desabilitar marca de agua
 //recordar mover

app.use(express.json()); //Hace que pueda leer Json
app.use(cors())  //Evita los problemas de origen
app.use(express.urlencoded({ extended:false }));

app.use('/', rutas); //Son las rutas(o recursos en donde se accede a los datos)

app.listen(config.PORT, async ()=> { //Escucha hasta que esté disponible el puerto
    console.log(`server listening on port http://localhost:${config.PORT}/ListaJson`)
});

