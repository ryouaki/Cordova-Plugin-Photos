cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-plugin-photos/www/Photos.js",
        "id": "cordova-plugin-photos.Photos",
        "pluginId": "cordova-plugin-photos",
        "clobbers": [
            "Photos"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.2.0",
    "cordova-plugin-photos": "1.0.1"
}
// BOTTOM OF METADATA
});