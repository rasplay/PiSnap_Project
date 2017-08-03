var five = require('johnny-five');
var Raspi = require('raspi-io');
var board = new five.Board({
  io: new Raspi()
});

var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.send('Welcome to GPIO');
});

router.get('/read/:pinno', function(req, res, next) {
  console.log('GPIO READ');
  pinno = Number(req.params.pinno);

  readfn(pinno, res);
  console.log('end router');
});

var readfn = function(pinno, res) {
  pin = new five.Pin('P1-'+pinno);
  pin.query(function(state){
    value=(state.value === true)?'true':'false';
    console.log(value);
    res.send(''+value);
  });
}

var writefn = function(pinno, value, res) {
  var pin = new five.Pin('P1-'+pinno);
  five.Pin.write(pin, value);

  res.send('');
}

router.get('/write/:pinno/:value', function(req, res, next) { 
  pinno = Number(req.params.pinno);

  value=(req.params.value.toString().trim() === 'HIGH')?true:false;

  writefn(pinno, value, res);
});

module.exports = router;

