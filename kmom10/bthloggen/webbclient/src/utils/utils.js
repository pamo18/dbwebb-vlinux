const utils = {
    getMonthSetup: function(year, month) {
        let first = new Date(year, month, 1),
            last = new Date(year, month + 1, 0);

        var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

        let currentMonth = {
            start: days[first.getDay()],
            end: last.getDate()
        };

        return currentMonth;
    },
    getDayPos: function(day) {
        let startPos = {
            "Mon": 0,
            "Tue": 1,
            "Wed": 2,
            "Thu": 3,
            "Fri": 4,
            "Sat": 5,
            "Sun": 6
        };

        return startPos[day];
    },
    getDateAsString: function(date) {
        let y = date.getFullYear(),
            m = date.getMonth() + 1,
            d = date.getDate(),
            dateAsString = d + "/" + m + "/" + y;

        return dateAsString;
    },
    getMonthNames: function() {
        const months = {
            "January": 0,
            "Feburary": 1,
            "March": 2,
            "April": 3,
            "May": 4,
            "June": 5,
            "July": 6,
            "August": 7,
            "September": 8,
            "October": 9,
            "November": 10,
            "December": 11
        };

        return months;
    },
    isToday: function(someDate) {
        const today = new Date();

        /*eslint-disable */
        return someDate.getDate() == today.getDate() &&
            someDate.getMonth() == today.getMonth() &&
            someDate.getFullYear() == today.getFullYear()
        /*eslint-enable */
    },
};

export default utils;
