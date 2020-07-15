/*eslint max-len: ["error", { "code": 200 }]*/
/**
 * Route data.
 */

"use strict";

var express = require('express');
var router = express.Router();
const log = require('../models/log.js');
const data = require('../../data/log.json');

router.get('/', function(req, res) {
    let found;

    switch (true) {
        case Object.keys(req.query).length === 0:
            found = data;
            break;

        case req.query.ip != undefined:
            found = log.find(data, "ip", req.query.ip);
            break;

        case req.query.url != undefined:
            found = log.find(data, "url", req.query.url);
            break;

        case req.query.time != undefined && req.query.day != undefined && req.query.month != undefined:
            //Note: time only used in column 1 and find 1
            found = log.find(data, "time", req.query.time, "day", req.query.day, "month", req.query.month);
            break;

        case req.query.time != undefined && req.query.day != undefined:
            //Note: time only used in column 1 and find 1
            found = log.find(data, "time", req.query.time, "day", req.query.day);
            break;

        case req.query.time != undefined:
            //Note: time only used in column 1 and find 1
            found = log.find(data, "time", req.query.time);
            break;

        case req.query.day != undefined:
            found = log.find(data, "day", req.query.day);
            break;

        case req.query.month != undefined:
            found = log.find(data, "month", req.query.month);
            break;

        default:
            found = {"error": "invalid filter"};
    }

    res.json(found);
});

module.exports = router;
