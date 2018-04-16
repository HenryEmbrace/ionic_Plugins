var argscheck = require('cordova/argscheck'),
utils = require('cordova/utils'),
exec = require('cordova/exec');

var PLUGIN_NAME = "ShareSDKPlugin";

var ShareSDKPlugin = function() {};

function isFunction(obj) {
    return !!(obj && obj.constructor && obj.call && obj.apply);
};

var aStr = 'http://boyueimages.shhwec.com/cycle/20170529/20170529-140511201-23.mp4';
var titleStr = 'ShareTiyle';
var textStr = 'ShareTestfor test';
var imgUrlStr = '';
var urlStr = ‘www.baidu.com’;
ShareSDKPlugin.share = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "share", [titleStr,textStr,imgUrlStr,urlStr]);
};

module.exports = ShareSDKPlugin;
