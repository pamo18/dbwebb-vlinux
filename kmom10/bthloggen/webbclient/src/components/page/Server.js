/*eslint max-len: ["error", { "code": 200 }]*/

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import base from '../../config/api.js';
let url = base.api();

class Server extends Component {
    // eslint-disable-next-line
    static propTypes = {
        match: PropTypes.object.isRequired,
        location: PropTypes.object.isRequired,
        history: PropTypes.object.isRequired
    };
    constructor(props) {
        super(props);
        this.changeServer = this.changeServer.bind(this);
        this.state = {
            current: url
        };
    }

    changeServer(e) {
        e.preventDefault();
        const data = new FormData(e.target);

        localStorage.setItem("server", data.get("server"));
        this.props.history.push('/server');
        window.location.reload(false);
    }
    render() {
        return (
            <article>
                <h1>Server URL</h1>
                <h4 className="center">The current server url is: {this.state.current}</h4>
                <form action="/server" className="form-server" onSubmit={this.changeServer}>
                    <label className="form-server-label">Server
                        <input className="form-server-input" type="text" placeholder="server name" name="server" required />
                    </label>
                    <input className="button form-button" type="submit" name="submit" value="Submit" />
                </form>
            </article>
        );
    }
}

export default Server;
