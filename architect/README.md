## 分层架构

1. 干净架构
	* 参考：
		1. [iOS-CleanArchitecture](https://github.com/koutalou/iOS-CleanArchitecture)


还没去看：
	* [iOS 架构模式--解密 MVC，MVP，MVVM以及VIPER架构](http://www.cocoachina.com/ios/20160108/14916.html)
	* [MVC---Android App的设计架构：MVC,MVP,MVVM与架构经验谈](http://blog.csdn.net/it1039871366/article/details/50673192)
	* [被误解的MVC和被神化的MVVM](http://kb.cnblogs.com/page/532236/)
	* [一个简单登陆示例的MVC和MVP实现](http://blog.csdn.net/cloudybird/article/details/51190596)

### 提问？

1. 为什么会出现 MVC，为什么演变出MVP？

2. 如何来聊 三层架构？
	* 有人说MVVM比MVC好，我认为不妥，两个实际上都是三层架构，只是在角色设定和组织方式上的不同；所以，我认为架构分层和社会分工一样，它对应用架构的具体设计提供了基本模型，同时遵循良好的分层架构规则；因此，MVC三层架构下，对象设计可以有变种，根据团队配置、应用体量，进行合理的类设计和人员分工协作。
	* 

### Model-View-Controller

1. 看苹果的MVC架构图：
	![apple mvc](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/apple-mvc.jpg)

	* （模型 Model） - 程序员编写程序应有的功能（实现算法等等）、数据库专家进行数据管理和数据库设计(可以实现具体的功能)。
	* （视图 View） - 屏幕上显示的UI，响应用户事件，接受用户输入。
	* （控制器 Controller）- 负责转发请求，对请求进行处理。(这里很重要的一定是：Controller 不是必须要负责DAO的工作，也不是必须要负责数据处理工作)
2. 

### Model-View-Presenter


### Model-ViewModel-View

1. View与ViewModel一一对应
	* ViewModel 是视图数据模型，此时的分层结构，可以参考：[猿题库 iOS 客户端架构设计](http://www.jianshu.com/p/dc0aeec7dbc2) ，形成下面的架构图
	![mvvm-yuantiku](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/mvvm-yuantiku.png)
		> 上图的中间节点是
	* Controller 是视图容器scene、scene切换控制、部分视图逻辑
	* View Action-Handler
2. View与ViewController一一对应
	* ViewModel 是视图控制器数据模型，应该是ViewControllerModel
	* Controller 是视图容器scene, scene切换控制（也有人将这一步移入ViewModel，相当于Presenter），Action-Handler
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
