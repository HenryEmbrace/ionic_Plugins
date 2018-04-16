/**
 * Created by Embrace on 2017/6/1.
 */
var argscheck = require('cordova/argscheck'),
utils = require('cordova/utils'),
exec = require('cordova/exec');

var PLUGIN_NAME = "PhotoAndVideo";

var PhotoAndVideo = function() {};

function isFunction(obj) {
    return !!(obj && obj.constructor && obj.call && obj.apply);
};



PhotoAndVideo.getVideosAndImage = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "getVideosAndImage", []);
};

PhotoAndVideo.getImage = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "getImage", []);
};


PhotoAndVideo.getVideos = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "getVideos", []);
};



module.exports = PhotoAndVideo;
