import React, { Component } from 'react';
import { connect } from 'react-redux';
import { uploadPdf } from '../actions/index';
import { pdfTest } from '../tools/pdf_test';

class Uploader extends Component {
    onUploadClick() {
        debugger;
        this.props.uploadPdf({id: "test.pdf", data: pdfTest});
    }

    render() {
        return (
            <div className="uploader">
                <h2>Awesome Uploader!</h2>
                <div className="input-group">
                    <input className="form-control" type="text" aria-describedby="helpBlock" />
                    <span className="input-group-btn">
                        <button
                            className="btn btn-primary"
                            type="button"
                            onClick={this.onUploadClick.bind(this)}>
                            Upload
                        </button>
                    </span>
                </div>
            </div>
        );
    }
}

export default connect(null, { uploadPdf })(Uploader);
