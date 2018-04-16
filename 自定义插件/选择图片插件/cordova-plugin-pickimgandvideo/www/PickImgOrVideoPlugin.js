var argscheck = require('cordova/argscheck'),
utils = require('cordova/utils'),
exec = require('cordova/exec');

var PLUGIN_NAME = "PickImgOrVideoPlugin";

var PickImgOrVideoPlugin = function() {};

function isFunction(obj) {
    return !!(obj && obj.constructor && obj.call && obj.apply);
};



PickImgOrVideoPlugin.pickImgOrVideoMethod = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "pickImgOrVideoMethod", []);
};



module.exports = PickImgOrVideoPlugin;