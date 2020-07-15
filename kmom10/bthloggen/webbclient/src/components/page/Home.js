/*eslint max-len: ["error", { "code": 200 }]*/

import React, { Component } from 'react';
import log from '../../assets/img/log.png';

class Home extends Component {
    constructor(props) {
        super(props);
        this.state = {
            message: ""
        };
    }
    render() {
        return (
            <article>
                <h1>Web Client</h1>
                <p>Web Client to filter and search for IP addresses, URLs, days, months, times, days & times and Months, Days & Times from the log file.</p>
                <h4 className="center">This work is a part of vlinux Kmom10, Blekinge Tekniska Högskola</h4>
                <div className="home"><img src={log} className="log" alt="log file" />Log file.</div>
            </article>
        );
    }
}

export default Home;
