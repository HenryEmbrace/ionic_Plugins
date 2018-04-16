var exec = require('cordova/exec');

module.exports = {

    selectAll: function (args, onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectAll", [args]);
    },

    selectImage: function (args, onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectImage", [args]);
    },


    selectVideo: function (onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectVideo", []);
    },


    selectAllSingle: function (onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectAllSingle", []);
    },


    selectImageSingle: function (onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectImageSingle", []);
    },


    selectVideoSingle: function (onSuccess, onError) {
        exec(onSuccess, onError, "SelectImageVideo", "selectVideoSingle", []);
    }
}