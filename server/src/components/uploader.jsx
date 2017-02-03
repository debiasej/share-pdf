import React, { Component } from 'react';

class Uploader extends Component {
    render() {
        return (
            <div className="uploader">
                <h2>Awesome Uploader!</h2>
                <div className="input-group">
                    <input className="form-control" type="text" aria-describedby="helpBlock" />
                    <span className="input-group-btn">
                        <button className="btn btn-primary" type="button">Upload</button>
                    </span>
                </div>
            </div>
        );
    }
}

export default Uploader;