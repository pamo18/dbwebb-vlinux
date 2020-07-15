/*eslint max-len: ["error", { "code": 200 }]*/
/**
 * Log functions
 */

"use strict";

const log = {
    find: function(data, column1, find1, column2 = null, find2 = null, column3 = null, find3 = null) {
        //Note: time only used in column 1 and find 1
        let found = [];
        let toFind1 = find1.toLowerCase();
        let toFind2 = (find2 ? find2.toLowerCase(): null);
        let toFind3 = (find3 ? find3.toLowerCase(): null);
        let hour = RegExp(/^[0-9]{2}/);
        let minute = RegExp(/^[0-9]{2}:[0-9]{2}/);
        let second = RegExp(/^[0-9]{2}:[0-9]{2}:[0-9]{2}/);
        let formatedItem;

        data.forEach(function(item) {
            let item1 = item[column1].toLowerCase();
            let item2 = (column2 ? item[column2].toLowerCase(): null);
            let item3 = (column3 ? item[column3].toLowerCase(): null);

            if (column1 === "time") {
                switch (true) {
                    case second.test(toFind1):
                        break;

                    case minute.test(toFind1):
                        formatedItem = item1.match(minute);
                        item1 = formatedItem[0];
                        break;

                    case hour.test(toFind1):
                        formatedItem = item1.match(hour);
                        item1 = formatedItem[0];
                        break;
                }
            }

            switch (true) {
                case (item1 != null && item2 != null && item3 != null):
                    if (item1 === toFind1 && item2 === toFind2 && item3 === toFind3) {
                        found.push(item);
                    }
                    break;

                case (item1 != null && item2 != null):
                    if (item1 === toFind1 && item2 === toFind2) {
                        found.push(item);
                    }
                    break;

                case (item1 != null && (column1 === "url" || column1 === "ip")):
                    if (item1.includes(toFind1)) {
                        found.push(item);
                    }
                    break;

                case (item1 != null):
                    if (item1 === toFind1) {
                        found.push(item);
                    }
                    break;
            }
        });
        return found;
    }
};

module.exports = log;
