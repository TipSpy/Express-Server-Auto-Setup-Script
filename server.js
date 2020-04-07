const express = require('express');
const path = require('path');
const app = express();

// Set up your routes here
app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, 'html', 'index.html'));
});