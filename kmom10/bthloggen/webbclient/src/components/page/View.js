/*eslint max-len: ["error", { "code": 150 }]*/

import React, { Component } from 'react';
import { NavLink } from 'react-router-dom';
import Data from './data.js';
import PropTypes from 'prop-types';

class View extends Component {
    static propTypes = {
        match: PropTypes.object.isRequired,
        location: PropTypes.object.isRequired,
        history: PropTypes.object.isRequired
    };
    constructor(props) {
        super(props);
        this.state = {
            message: ""
        };
    }

    render() {
        return (
            <main>
                <nav className="navbar_main under">
                    <ul>
                        <li><NavLink to="/view/all" activeClassName="selected">All</NavLink></li>
                        <li><NavLink to="/view/ip" activeClassName="selected">IP</NavLink></li>
                        <li><NavLink to="/view/url" activeClassName="selected">URL</NavLink></li>
                        <li><NavLink to="/view/day" activeClassName="selected">Day</NavLink></li><br />
                        <li><NavLink to="/view/month" activeClassName="selected">Month</NavLink></li>
                        <li><NavLink to="/view/time" activeClassName="selected">Time</NavLink></li>
                        <li><NavLink to="/view/day-time" activeClassName="selected">Day & Time</NavLink></li>
                        <li><NavLink to="/view/month-day-time" activeClassName="selected">Month, Day & Time</NavLink></li>
                    </ul>
                </nav>
                <div>
                    <h1>{this.state.title}</h1>
                    <Data key={this.props.match.params.type} type={this.props.match.params.type}/>
                </div>
            </main>
        );
    }
}

export default View;
