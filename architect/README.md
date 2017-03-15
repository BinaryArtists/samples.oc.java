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
2. 看苹果的MVC架构图：(注意中间的双黄线)
	![apple mvc](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/apple-mvc.jpg)

	* （模型 Model） - 程序员编写程序应有的功能（实现算法等等）、数据库专家进行数据管理和数据库设计(可以实现具体的功能)。
	* （视图 View） - 屏幕上显示的UI，响应用户事件，接受用户输入。
	* （控制器 Controller）- 负责转发请求，对请求进行处理。(这里很重要的一定是：Controller 不是必须要负责DAO的工作，也不是必须要负责数据处理工作)
2. 

### Model-View-Presenter

1. 看一张图，他绘出了基本模型：
	![basic mvp model](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/mvp-1.png)

2. 再看一张，他加入了接口：
	![protocol mvp model](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/mvp-2.jpg)

3. 耐心点，最后一张，他对应了实际的解决域：
	![related to answer domain mvp model](https://github.com/BinaryArtists/samples.oc.java/blob/master/architect/res/mvp-3.jpg)

4. 职责
	* View:负责绘制UI元素、与用户进行交互;
	* View interface:需要View实现的接口，View通过View interface与Presenter进行交互，降低耦合，方便进行单元测试;
	* Model:负责存储、检索、操纵数据(有时也实现一个Model interface用来降低耦合)，为UI层提供的数据，或者保存UI层传下来的数据;
	* Presenter:作为View与Model交互的中间纽带，处理与用户交互的负责逻辑；逻辑控制层，从Model处取数据，运算和转化，最后用View来展示；并处理View传过来的用户事件，并做处理。
	* 因此，Presenter 层是连接 Model 层和 View 层的中间层，因此持有 View 层的接口和 Model 层的接口。

	* 可选：实际操作的时候，你可以按需给Presenter赋予职责。他可以是DAO+Data加工、而VC做路由，也可以是DAO+DATA加工+路由，就看谁来驱动谁了～

	* 一般还是会吧View层的Action-handler与Presenter直接对接，如果在ViewController中相应，再传递到Presenter, 那么传递链过长，会有很多胶水代码！

5. 规则
	* Model与View不能直接通信，只能通过Presenter
	* Presenter类似于中间人的角色进行协调和调度
	* Model和View是接口，Presenter持有的是一个Model接口和一个View接口
	* Model和View都应该是被动的，一切都由Presenter来主导
	* Model应该把与业务逻辑层的交互封装掉，换句话说Presenter和View不应该知道业务逻辑层
	* View的逻辑应该尽可能的简单，不应该有状态。当事件发生时，调用Presenter来处理，并且不传参数，Presenter处理时再调用View的方法来获取。

5. 代码分析 看 [architect/mvp](https://github.com/BinaryArtists/samples.oc.java/tree/master/architect/mvp)

6. 引用：
	* [架构思维系列之MVP架构](http://www.jianshu.com/p/419b3f6a108a)

### 插播广告 Model-View-Protocol

在[基于面向协议MVP模式下的软件设计－iOS篇](http://www.cocoachina.com/ios/20151223/14768.html)中，提高了这个模式，它的实现思想是 下面讲到的面相接口，面向接口本质上是对流程、行为模型进行抽象，然后调用、实现。

上文中的实现：[SkyOldLee/MVP](https://github.com/SkyOldLee/MVP)

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

4. 其他
	* 基于KVO的绑定库如 RZDataBinding 和 SwiftBond
	* 完全的函数响应式编程，比如像ReactiveCocoa、RxSwift或者 PromiseKit

### View-Interacter-Presenter-Entity-Rooting

1. 职责划分
	* 交互器 -- 包括关于数据和网络请求的业务逻辑，例如创建一个实体（数据），或者从服务器中获取一些数据。为了实现这些功能，需要使用服务、管理器，但是他们并不被认为是VIPER架构内的模块，而是外部依赖。
	* 展示器 -- 包含UI层面的业务逻辑以及在交互器层面的方法调用。
	* 实体 -- 普通的数据对象，不属于数据访问层次，因为数据访问属于交互器的职责。
	* 路由器 -- 用来连接VIPER的各个模块。

2. 问题
	* “找到一个适合的方法来实现路由对于iOS应用是一个挑战，MV(X)系列避开了这个问题。”
	* 参考：
		1. [使用VIPER构建iOS应用](http://www.cocoachina.com/ios/20140703/9016.html)

## 上面说的是不同的分层架构模式，下面选读了一些思想，它设定了架构的风格

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
	* 基于上一段，面向接口提供了“可装配”的能力！
	
3. 

## 上面说了架构模式（原理）和架构风格因子（形式），下面说说，为什么要“架构”？

### 分布式

### 易测性(Unit Testing)


### 易用性(包含可复用性的意思么？)


## 本文参考：

*总而言之，模糊的职责划分是非常糟糕的，你要善用这些思想工具*

1. [iOS 架构模式--解密 MVC，MVP，MVVM以及VIPER架构](http://www.cocoachina.com/ios/20160108/14916.html)


### 最后谈谈自己的实际操作经验吧

1. 1～3人小组，完全不考虑面向接口
	* View层：ViewContoller+View
	* Dao层：数据获取（Dao	层，有时候会考虑扩充，做成实实在在的业务逻辑层，整合业务流程）
	* Model\Entity\DTO（备注：DTO通常用于不同层（UI层、服务层或者域模型层）直接的数据传输，以隔离不同层，降低层间耦合）（有时候，贫血NetModel和DTO都会省略，直接使用）
2. 3～8人组，考虑层间接口、但尽量通用（也就是template接口抽象），考虑组件化，考虑Mock+单元测试等等