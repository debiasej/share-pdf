import axios from 'axios';

export const UPLOAD_PDF = 'UPLOAD_PDF';

const ROOT_URL = 'http://127.0.0.1:3000'; // reduxblog.herokuapp.com/api

export function uploadPdf(props) {
    debugger;
    const request = axios.post(`${ROOT_URL}/upload`, props,{
        headers: {
            'Content-Type': 'application/json'
        }
    });
    //const request = axios.get(`${ROOT_URL}/upload`);

    return {
        type: UPLOAD_PDF,
        payload: request
    };
}
