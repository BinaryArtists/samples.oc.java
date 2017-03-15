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

1. 看传统的MVC模式
	![tradition mvc](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/tradition-mvc.png)
2. 看苹果的MVC架构图：
	![apple mvc](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/apple-mvc.jpg)

	* （模型 Model） - 程序员编写程序应有的功能（实现算法等等）、数据库专家进行数据管理和数据库设计(可以实现具体的功能)。
	* （视图 View） - 屏幕上显示的UI，响应用户事件，接受用户输入。
	* （控制器 Controller）- 负责转发请求，对请求进行处理。(这里很重要的一定是：Controller 不是必须要负责DAO的工作，也不是必须要负责数据处理工作)
2. 

### Model-View-Presenter

一般还是会吧View层的Action-handler与Presenter直接对接，如果在ViewController中相应，再传递到Presenter, 那么传递链过长，会有很多胶水代码！

http://www.cocoachina.com/ios/20160108/14916.html
https://github.com/search?l=Objective-C&p=5&q=mvp&type=Repositories&utf8=%E2%9C%93
https://github.com/SkyOldLee/MVP
https://github.com/amacou/MVPExample
https://github.com/indexjincieryi/NDMVPProject
https://github.com/MChainZhou/MVP/tree/master/MVP/MVP/Main/Presenter

### 插播广告 Model-View-Protocol

在[基于面向协议MVP模式下的软件设计－iOS篇](http://www.cocoachina.com/ios/20151223/14768.html)中，提高了这个模式，它的实现思想是 下面讲到的面相接口，面向接口本质上是对流程、行为模型进行抽象，然后调用、实现。

* 小团队不建议大规模使用，尤其是迭代速度很快、变化日新月异的情况下。大团队嘛，随便怎么玩，开心就好。*

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

1. 引用一篇文章[面向接口编程的好处分析](http://blog.csdn.net/qq376430645/article/details/9927225)
	* What？接口就是标准规范，就是定死了一个框架，你根据这个框架去执行！有了标准去遵守就容易扩展！我们只需要面向标准编程，而不用针对具体的实现类！
	* 使用面向接口的编程过程中，将具体逻辑与实现分开，减少了各个类之间的相互依赖，当各个类变化时，不需要对已经编写的系统进行改动，添加新的实现类就可以了，不再担心新改动的类对系统的其他模块造成影响。 
	* Why？a. 更加抽象,更加面向对象 b. 提高编程的灵活性 c. 实现高内聚、低耦合，提高可维护性，降低系统维护成本。
	* How？协调者：接口定义，调用者：接口使用，实现者：接口实现.
	* Mean？[什么叫面向接口编程以及面向接口编程的好处](http://www.cnblogs.com/xyqCreator/archive/2012/11/06/2756687.html)面向对象是指，我们考虑问题时，以对象为单位，考虑它的属性及方法；面向过程是指，我们考虑问题时，以一个具体的流程（事务过程）为单位，考虑它的实现（行为模型）。

2. inherit a class is "it likes something",inherit a interface is "doing likes something"
	* 面向接口（更抽象）是实现多态的关键，看个java反射的例子：
		```
		BaseDao dao = (BaseDao)(Class.forName(Config.getDaoName()).newInstance());
		// 其中Config.getDaoName()可以获得配置文件中的配置，比如是：com.bao.dao.impl.MySQLDao。
		// 之后，那些人开始要烧钱了，要改用Oracle了，这样我们只要按BaseDao的定义，再实现一个OracleDao就可以了，再将配置文件中的配置改为：com.bao.dao.impl.OralceDao就可以了
		// 而在已经写好的代码中，我们可以一行不改的进行了数据库移植，这个就是面向对象设计原则中的“开-闭原则”（对增加是开放的，对修改是封闭的）
		```
	* 基于上一段，面向接口提供了“装配”的能力！
	
3. 

## 上面说了架构模式（原理）和架构风格因子（形式），下面说说，为什么要“架构”？

### 分布式

### 易测性


### 易用性


## 本文参考：

1. [iOS 架构模式--解密 MVC，MVP，MVVM以及VIPER架构](http://www.cocoachina.com/ios/20160108/14916.html)
