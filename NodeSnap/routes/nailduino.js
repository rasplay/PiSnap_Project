var nailduino = require('johnny-five');
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  //res.render('nailduino', { title: 'nailduino' });

   
  res.send('Welcome to nailduino');
});

router.get('/blink/:pinno', function(req, res, next) {
    console.log('route success');
    board = new nailduino.Board();
    board.on("ready", function() {
        var led = new nailduino.Led(Number(req.params.pinno));
        led.blink(500);

      res.send('');
    });
});

module.exports = router;

