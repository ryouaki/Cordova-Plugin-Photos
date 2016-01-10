cordova.define("Cordova-plugin-photos.Photos", function(require, exports, module) { var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');
  
var photosExport = {};

photosExport.getThumbPhotos = function(successCallback, errorCallback, args) {
  exec(successCallback, errorCallback, "photosPlugin", "getThumbPhotos", args);
};

photosExport.getRealPhoto = function(successCallback, errorCallback, args) {
  exec(successCallback, errorCallback, "photosPlugin", "getRealPhoto", args);
};

module.exports = photosExport;
});
