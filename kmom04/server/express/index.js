const express = require('express');
const app = express();
const port = 1337;
const data = require('../data/items.json');

app.get('/', (req, res) => res.send(
    "<h2>Följande routes finns med respektivt resultat</h2>" +
    "<h4>/	En presentation av de olika routesen.<br/><br/>" +
    "/all<br/>Hela JSON-filen.<br/><br/>" +
    "/names<br/>Namnen på alla växterna.<br/><br/>" +
    "/color/&ltcolor&gt<br/>Alla växter som kan ha en specifikt &ltcolor&gt som färg.</h4>"
));

app.get('/all', (req, res) => res.json(data));

app.get('/names', function(req, res) {
    let names = [];

    Object.keys(data.items).forEach(function(item) {
        names.push({"name": data.items[item].name});
    });
    res.json({"names": names});
});

app.get('/color/:col', function(req, res) {
    let items = [];

    Object.keys(data.items).forEach(function(item) {
        let current = data.items[item];
        let colors = [];
        let find = req.params.col.toLowerCase();

        current.color.forEach(function(c) {
            colors.push(c.toLowerCase());
        });
        if (colors.includes(find)) {
            items.push(data.items[item]);
        }
    });
    res.json({"items": items});
});


app.listen(port, () => console.log(`Example app listening on port ${port}!`));
