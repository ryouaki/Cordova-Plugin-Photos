/*
 * Module : moduleMainView.js
 * Auther : Ryou(46517115@qq.com)
 */
moduleJs.createModule('moduleMainView',{

  // optional property  
  moduleName : 'moduleMainView',
  
  currentIndex : 0,
  allPhotos:[],
  /*
   * onShowView will be invoked at the first time you call the api moduleJs.showView
   * You can do something like initialize UI or others.
   */
  onShowView : function(param) {
    this.currentIndex = 0;
    document.getElementById('morebtn').ontouchend = function() {
      this.getPhotos(this.currentIndex,2);
      this.currentIndex++;
    }.bind(this);
    
    document.getElementById('allbtn').ontouchend = function() {
      Photos.getMultiRealPhotos(function(arguments){
        var objs = JSON.parse(arguments);
        var parent = document.getElementById('imgs');
        objs.forEach(function(item){
          var img = document.createElement('img');
          img.src = item.data;
          img.style.width = "100%";
          parent.appendChild(img);
        });
      }.bind(this),function(arguments){
        console.log(arguments);
      },[this.allPhotos]);
    }.bind(this);
  },

  getPhotos : function(index,max) {
    Photos.getThumbPhotos(function(arguments){
      var objs = JSON.parse(arguments);
      var parent = document.getElementById('imgs');
      objs.forEach(function(item){
        this.allPhotos.push(item.url);
        var img = document.createElement('img');
        img.src = item.data;
        img.onclick = function(){
          moduleJs.showView('moduleDetailView',{url:item.url});
        };
        parent.appendChild(img);
      }.bind(this));
    }.bind(this),function(arguments){
      console.log(arguments);
    },[index,max]);
  }
});