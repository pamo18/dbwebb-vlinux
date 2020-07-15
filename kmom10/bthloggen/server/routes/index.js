/*eslint max-len: ["error", { "code": 200 }]*/
/**
 * Route index.
 */

var express = require('express');
var router = express.Router();

router.get('/', (req, res) => res.send(
    "<h2>Följande routes finns med respektivt resultat</h2>" +
    "<h4>/<br/>Visa en lista av de routes som stöds.<br/><br/>" +
    "/data/<br/>Visa samtliga rader.<br/><br/>" +
    "/data?ip=&ltip&gt<br/>Visa raderna som innehåller &ltip&gt.<br/><br/>" +
    "/data?url=&lturl&gt<br/>Visa raderna som innehåller &lturl&gt.<br/><br/>" +
    "/data?month=&ltmonth&gt<br/>Visa raderna från månaden &ltmonth&gt.<br/><br/>" +
    "/data?day=&ltday&gt<br/>Visa raderna från dagen &ltday&gt.<br/><br/>" +
    "/data?time=&lttime&gt<br/>Visa raderna från tiden &lttime&gt.<br/><br/>" +
    "/data?day=&ltday&gt&time=&lttime&gt<br/>Visa raderna från tiden &lttime&gt på dagen &ltday&gt.<br/><br/>" +
    "/data?month=&ltmonth&gt&day=&ltday&gt&time=&lttime&gt<br/>Visa raderna från tiden &lttime&gt på dagen &ltday&gt och månaden &ltmonth&gt.</h4>"
));

module.exports = router;
