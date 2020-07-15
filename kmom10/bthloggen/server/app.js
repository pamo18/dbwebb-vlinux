/**
 * An Express server.
 */

"use strict";

const express = require('express');
const app = express();
const port = 1337;
const cors = require('cors');
const index = require('./routes/index.js');
const data = require('./routes/data.js');

// This is middleware called for all routes.
// Middleware takes three parameters.
app.use((req, res, next) => {
    console.log(req.method);
    console.log(req.path);
    next();
});

app.use(cors()); //Cross-Origin Resource Sharing (CORS)

app.use("/", index);
app.use("/data", data);

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
