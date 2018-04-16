var argscheck = require('cordova/argscheck'),
utils = require('cordova/utils'),
exec = require('cordova/exec');

var PLUGIN_NAME = "QRCodeScan";

var QRCodeScan = function() {};

function isFunction(obj) {
    return !!(obj && obj.constructor && obj.call && obj.apply);
};



QRCodeScan.ScanMethod = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "ScanMethod", []);
};



module.exports = QRCodeScan;