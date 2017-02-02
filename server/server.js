const express = require('express');
const app = express();
const port = 3000;
const path = require('path');
const bodyParser = require('body-parser');
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

//app.set('view engine', 'ejs')
//app.use(bodyParser.urlencoded({extended: true}));
//app.use(bodyParser.json());
app.use(express.static(__dirname));

app.get('/user', (req, res) => {
  db.collection('users').find().toArray((err, result) => {
    if (err) return console.log(err);
    console.log(result);
    console.log('Loading index.html...');

    res.sendFile(path.resolve(__dirname, 'index.html'));
  })
});

app.get('/dist', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'index.html'));
});
