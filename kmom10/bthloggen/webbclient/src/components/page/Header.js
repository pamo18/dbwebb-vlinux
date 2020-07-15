/*eslint max-len: ["error", { "code": 200 }]*/

import React, { Component } from 'react';
import { NavLink } from 'react-router-dom';
import logo from '../../assets/img/logo.png';

class Header extends Component {
    constructor(props) {
        super(props);
        this.state = {
            message: ""
        };
    }

    render() {
        const checkActive = (match, location) => {
            if (!location) {
                return false;
            }
            const {pathname} = location;

            return pathname === "/";
        };

        const checkActiveView = (match, location) => {
            if (!location) {
                return false;
            }
            const {pathname} = location;
            var splitLink = pathname.split("/")[1];

            return splitLink === "view";
        };

        return (
            <header className="site-header">
                <img src={logo} className="logo" alt="logo" />
                <span className="site-title">BTH Server & Nätverk AB</span>
                <nav className="navbar_main">
                    <ul>
                        <li><NavLink to="/" activeClassName="selected" isActive={checkActive}>Home</NavLink ></li>
                        <li><NavLink to="/view/all" activeClassName="selected" isActive={checkActiveView}>View</NavLink ></li>
                        <li><NavLink to="/server" activeClassName="selected">Server</NavLink ></li>
                    </ul>
                </nav>
            </header>
        );
    }
}

export default Header;
