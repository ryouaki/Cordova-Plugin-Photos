/*
 * Module : moduleDetailView.js
 * Auther : Ryou(46517115@qq.com)
 */
moduleJs.createModule('moduleDetailView',{
  
  // optional property
  moduleName : 'moduleDetailView',
  
  /*
   * onShowView will be invoked at the first time you call the api moduleJs.showView
   * You can do something like initialize UI or others.
   */
  onShowView : function(param) {
    Photos.getRealPhoto(function(arguments){
      var objs = JSON.parse(arguments);
      document.getElementById('detail-pic').src = objs.data;
    },function(arguments){
      
    },[param.url]);
    document.getElementById('mainbtn').ontouchend = function() {
      moduleJs.showView('moduleMainView',{});
    }
  }
});