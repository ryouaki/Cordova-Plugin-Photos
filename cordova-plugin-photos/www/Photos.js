var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');
  
var photosExport = {};

photosExport.getThumbPhotos = function(successCallback, errorCallback, args) {
  exec(successCallback, errorCallback, "photosPlugin", "getThumbPhotos", args);
};

photosExport.getRealPhoto = function(successCallback, errorCallback, args) {
  exec(successCallback, errorCallback, "photosPlugin", "getRealPhoto", args);
};

photosExport.getMultiRealPhotos = function(successCallback, errorCallback, args) {
  exec(successCallback, errorCallback, "photosPlugin", "getMultiRealPhotos", args);
};

module.exports = photosExport;