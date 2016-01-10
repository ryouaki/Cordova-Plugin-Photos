这个是用于从设备读取图片缩略图和原始图片。

具体使用方法下载该项目并解压，然后在你的工程目录执行

cordova plugin add [path of plugin]

##E.X.
#获取缩略图：
Photos.getThumbPhotos(function(arguments){
      var objs = JSON.parse(arguments);
      。。。。。。
    }.bind(this),function(arguments){
      。。。。。。
    },[index,max]);

Data format:
[{url:pic_id,data:...},...]

#获取原图：
Photos.getRealPhoto(function(arguments){
      var objs = JSON.parse(arguments);
      。。。。。。
    },function(arguments){
      。。。。。。
    },[param.url]);
{data:......}

目前仅支持ios，android版本会陆续更新。
![image](https://github.com/ryouaki/Cordova-Plugin-Photos/blob/master/21B8E8ED5D4358FFBB5F5B7FD3C59D60.png)
![image](https://github.com/ryouaki/Cordova-Plugin-Photos/blob/master/2FEB64EF6D6D57AE001A15E5C06A21BE.png)

#----------------------Author----------------------
46517115@qq.com