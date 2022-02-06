//'use strict';

const fs = require('fs');

function jsonReader(filePath, cb) {
    
  fs.readFile(filePath, (err, fileData) => {
    if (err) {
      return cb && cb(err);
    }
    try {
      const object = JSON.parse(fileData);
      return cb && cb(null, object);
    } catch (err) {
      return cb && cb(err);
    }
  });
}

jsonReader("./input_data.json", (err, customer) => {
  if (err) {
    console.log(err);
    return;
  }
  //console.log(customer.address); // => "Infinity Loop Drive"
  console.log(customer.div.div[0].p[0].a['#text'])
});

//console.log('hello node');
