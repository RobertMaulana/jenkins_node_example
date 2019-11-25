'use strict';

const express = require('express');
const MongoClient = require('mongodb').MongoClient;

// Connect to the db
MongoClient.connect("mongodb://10.8.11.24:27017/node-test", function(err, db) {
  if(!err) {
    console.log("We are connected");
  }
});

// Constants
const PORT = 8081;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('from testing\n');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);