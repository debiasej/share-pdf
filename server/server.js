const express = require('express');
const app = express();
const port = 3000;
const path = require('path');
const bodyParser = require('body-parser');
const fs = require('fs');
const MongoClient = require('mongodb').MongoClient;
const config = require('./utils/config.js');

var db;
console.log(config.mongodbUrl + " " );

MongoClient.connect(config.mongodbUrl, (err, database) => {
  if (err) return console.log(err);
  db = database;
  app.listen(process.env.PORT || port, () => {
    console.log('listening on ' + port);
  });
});

var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
// intercept OPTIONS method
  if ('OPTIONS' == req.method) {
    res.sendStatus(200);
  } else {
    next();
  }
};

app.use(bodyParser.json());
app.use(express.static(__dirname));
app.use(allowCrossDomain);

app.get('/user', (req, res) => {
  db.collection('users').find().toArray((err, result) => {
    if (err) return console.log(err);
    console.log(result);
    console.log('Loading user...');

    res.sendFile(path.resolve(__dirname, 'index.html'));
  })
});

app.get('/', (req, res) => {
  console.log('Loading index.html...');
  res.sendFile(path.resolve(__dirname, 'index.html'));
});

app.post('/upload', (req, res) => {
  var name = req.body.id;
  var pdf = req.body.base64String;

  var pdf = pdf.replace('data:application/pdf;base64,', '');

  fs.writeFile(name, pdf, 'base64', function(err) {
    if (err)
      res.send({result: "ERROR: PDF document malformed"});
    else
      res.send({result: "OK"});
  });
});