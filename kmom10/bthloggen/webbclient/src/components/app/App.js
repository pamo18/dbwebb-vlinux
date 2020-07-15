import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';

import Header from '../page/Header.js';
import Home from '../page/Home.js';
import View from '../page/View.js';
import Server from '../page/Server.js';
import Footer from '../page/Footer.js';

import './App.css';

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            message: ""
        };
    }

    render() {
        return (
            <Router>
                <div className="App">
                    <Header />
                    <div className="wrap-main">
                        <main>
                            <Switch>
                                <Route exact path="/" component={Home} />
                                <Route exact path="/view" component={View} />
                                <Route exact path="/view/:type" component={View} />
                                <Route exact path="/server" component={Server} />
                            </Switch>
                        </main>
                    </div>
                    <Footer />
                </div>
            </Router>
        );
    }
}

export default App;
