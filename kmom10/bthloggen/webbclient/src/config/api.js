const base = {
    api: function() {
        let server;

        if (localStorage.getItem("server") === null) {
            server = "localhost";
        } else {
            server = localStorage.getItem("server");
        }

        let api = "http://" + server + ":1337";

        return api;
    }
};

export default base;
