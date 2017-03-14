## 架构

还没去看：
	* [iOS 架构模式--解密 MVC，MVP，MVVM以及VIPER架构](http://www.cocoachina.com/ios/20160108/14916.html)
	* [MVC---Android App的设计架构：MVC,MVP,MVVM与架构经验谈](http://blog.csdn.net/it1039871366/article/details/50673192)
	* [被误解的MVC和被神化的MVVM](http://kb.cnblogs.com/page/532236/)
	* [一个简单登陆示例的MVC和MVP实现](http://blog.csdn.net/cloudybird/article/details/51190596)

### 提问？

	* 为什么会出现 MVC，为什么演变出MVP？
	* 如何来聊 三层架构？


### 干净架构

	* 参考：
		1. [iOS-CleanArchitecture](https://github.com/koutalou/iOS-CleanArchitecture)

### Model-View-Controller

1. 
2. 

### Model-View-Presenter


### Model-ViewModel-View

1. View与ViewModel一一对应
	* ViewModel 是视图数据模型，此时的分层结构，可以参考：[猿题库 iOS 客户端架构设计](http://www.jianshu.com/p/dc0aeec7dbc2) ，形成下面的架构图
	![mvvm-yuantiku](mvvm-yuantiku.png)
	* Controller 是视图容器scene、scene切换控制、部分视图逻辑
	* View 
2. View与ViewController一一对应
	* ViewModel 是视图控制器数据模型，应该是ViewControllerModel，有人也会将
	* 
3. 数据绑定（非必须）
	* ReactCocoa 是数据绑定的首选框架
	* ObjectChain 也可以选择使用，它基于ReactCocoa的思想，在语义层做了可读性优化

### View-Interacter-Presenter-Entity-Rooting

	* 参考：
		1. [使用VIPER构建iOS应用](http://www.cocoachina.com/ios/20140703/9016.html)

## 上面说的是不同的分层架构模式，下面选读了一些思想，它设定了架构的风格（

### 数据流驱动


### Context（上下文）驱动


### 面相接口（协议）设计
