/*eslint max-len: ["error", { "code": 200 }]*/

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import base from '../../config/api.js';
let api = base.api();


class Data extends Component {
    static propTypes = {
        match: PropTypes.object.isRequired,
        location: PropTypes.object.isRequired,
        history: PropTypes.object.isRequired,
        type: PropTypes.string
    };
    constructor(props) {
        super(props);
        this.getContent = this.getContent.bind(this);
        this.setPaginate = this.setPaginate.bind(this);
        this.setCurrent = this.setCurrent.bind(this);
        this.setFilter1 = this.setFilter1.bind(this);
        this.setFilter2 = this.setFilter2.bind(this);
        this.setFilter3 = this.setFilter3.bind(this);
        this.getSearch = this.getSearch.bind(this);
        this.state = {
            type: this.props.type,
            view: {
                title: ""
            },
            data: [],
            search: [],
            showing1: false,
            showing2: false,
            showing3: false,
            pagination: [],
            count: 0,
            filter1: "",
            filter2: "",
            filter3: "",
            current: 1,
            page: 1000
        };
    }

    componentDidMount() {
        this.getContent(this.props.type, this.state.current, this.state.page);
    }

    setPaginate(length) {
        let pageCount = Math.ceil(length / this.state.page),
            pagination = [];

        for (let i = 1; i <= pageCount; i++) {
            let link = "#",
                isSelected = this.state.current === i ? "paginate selected" : "paginate";

            pagination.push(
                <li><a href={link} className={isSelected} onClick={() => this.setCurrent(i)}>{i}</a></li>
            );
        }

        this.setState({
            pagination: [
                <div key="sides" className="sides">
                    {pagination}
                </div>
            ]
        });
    }

    setCurrent(current) {
        this.setState({
            current: current
        }, () => this.getContent(this.state.type, this.state.current, this.state.page));
    }

    setFilter1(e) {
        this.setState({
            filter1: e.target.value,
            current: 1
        }, () => this.getContent(this.state.type, this.state.current, this.state.page));
    }

    setFilter2(e) {
        this.setState({
            filter2: e.target.value,
            current: 1
        }, () => this.getContent(this.state.type, this.state.current, this.state.page));
    }

    setFilter3(e) {
        this.setState({
            filter3: e.target.value,
            current: 1
        }, () => this.getContent(this.state.type, this.state.current, this.state.page));
    }

    getSearch(toggle1, toggle2=false, toggle3=false) {
        this.setState({
            showing1: toggle1,
            showing2: toggle2,
            showing3: toggle3
        });
    }

    getContent(type, current, page) {
        let that = this,
            filter1 = this.state.filter1,
            filter2 = this.state.filter2,
            filter3 = this.state.filter3,
            view,
            url;

        switch (type) {
            case "all":
                url = "/data/";
                this.getSearch(false);
                view = {
                    title: "View All",
                    label: ["all"]
                };
                break;

            case "ip":
                url = "/data?ip=" + filter1;
                this.getSearch(true);
                view = {
                    title: "Filter IP",
                    label: ["ip"]
                };
                break;

            case "url":
                url = "/data?url=" + filter1;
                this.getSearch(true);
                view = {
                    title: "Filter URL",
                    label: ["url"]
                };
                break;

            case "day":
                url = "/data?day=" + filter1;
                this.getSearch(true);
                view = {
                    title: "Search Day",
                    label: ["day"]
                };
                break;

            case "month":
                url = "/data?month=" + filter1;
                this.getSearch(true);
                view = {
                    title: "Search Month",
                    label: ["month"]
                };
                break;

            case "time":
                url = "/data?time=" + filter1;
                this.getSearch(true);
                view = {
                    title: "Search Time",
                    label: ["time"]
                };
                break;

            case "day-time":
                url = "/data?day=" + filter1 + "&time=" +filter2;
                this.getSearch(true, true);
                view = {
                    title: "Search Day & Time",
                    label: ["day", "time"]
                };
                break;

            case "month-day-time":
                url = "/data?month=" + filter1 + "&day=" + filter2 + "&time=" +filter3;
                this.getSearch(true, true, true);
                view = {
                    title: "Search Day & Time",
                    label: ["month", "day", "time"]
                };
                break;

            default:
                url = "/data/";
                this.getSearch(false);
        }

        that.setState({
            view: view
        });

        if (url && this.state.res) {
            this.makeTable(this.state.res, current, page);
        } else if (url) {
            fetch(api + url)
                .then(res => res.json())
                .then(res => this.makeTable(res, current, page));
        }
    }

    makeTable(data, current, page) {
        let result = [],
            start = (current * page) - page,
            stop = (start + page) - 1,
            count = data.length;

        this.setState({
            count: count
        });

        this.setPaginate(count);

        for (let i = start; i <= stop; i++) {
            if (i === count) {
                break;
            } else {
                result.push(
                    <tr key={i}>
                        <td data-title="IP">{ data[i].ip }</td>
                        <td data-title="URL">{ data[i].url }</td>
                        <td data-title="Date">{ data[i].day + " " + data[i].month + " " + data[i].year }</td>
                        <td data-title="Time">{ data[i].time }</td>
                    </tr>
                );
            }
        }

        this.setState({
            data: [
                <table key="results" className="results">
                    <thead>
                        <tr>
                            <th>IP</th>
                            <th>URL</th>
                            <th>Date</th>
                            <th>Time</th>
                        </tr>
                    </thead>
                    { result }
                </table>
            ]
        });
    }

    render() {
        const { showing1 } = this.state;
        const { showing2 } = this.state;
        const { showing3 } = this.state;

        return (
            <article>
                <h1>{this.state.view.title}</h1>
                <div className="count">
                    <p className="result">{"#" + this.state.count}</p>
                </div>
                { showing1 ?
                    <input
                        className="form-input"
                        type="text"
                        name="filter1"
                        placeholder={this.state.view.label[0]}
                        value={this.state.filter1}
                        onChange={this.setFilter1}
                    />
                    :null
                }
                { showing2 ?
                    <input
                        className="form-input"
                        type="text"
                        name="filter2"
                        placeholder={this.state.view.label[1]}
                        value={this.state.filter2}
                        onChange={this.setFilter2}
                    />
                    :null
                }
                { showing3 ?
                    <input
                        className="form-input"
                        type="text"
                        name="filter3"
                        placeholder={this.state.view.label[2]}
                        value={this.state.filter3}
                        onChange={this.setFilter3}
                    />
                    :null
                }
                { this.state.pagination }
                { this.state.data }
            </article>
        );
    }
}

export default Data;
