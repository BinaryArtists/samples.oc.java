
/*!
 *  @header BAKit
 *          demoTest
 *
 *  @brief  BAKit
 *
 *  @author 博爱
 *  @copyright    Copyright © 2016年 博爱. All rights reserved.
 *  @version    V1.0
 */

/*!
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */

/*
 
 *********************************************************************************
 *
 * 在使用BAKit的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ     : 可以添加SDAutoLayout群 497140713 在这里找到我(博爱1616【137361770】)
 * 微博    : 博爱1616
 * Email  : 137361770@qq.com
 * GitHub : https://github.com/boai
 * 博客园  : http://www.cnblogs.com/boai/
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>

/**
 *  给UIDevice类添加许多有用的方法
 */
@interface UIDevice (BAKit)

/**
 *  获取iOS版本
 */
#define IOS_VERSION [UIDevice currentDevice].systemVersion

/**
 *  获取屏幕宽度和高度
 */
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

/**
 *  系统版本号对比
 *  @param v Version, like @"8.0"
 */
// 系统版本等于
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
// 系统版本大于
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// 系统版本大于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// 系统版本小于
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
// 系统版本小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  返回平台设备
 */
+ (NSString *)devicePlatform;

/**
 *  返回平台设备字符串
 */
+ (NSString *)devicePlatformString;

/**
 *  检查是否是IPAD
 */
+ (BOOL)isiPad;

/**
 *  检查是否是iPhone
 */
+ (BOOL)isiPhone;

/**
 *  检查是否是iPod
 */
+ (BOOL)isiPod;

/**
 *  检查是否是simulator
 */
+ (BOOL)isSimulator;

/**
 *  检查是否是a Retina display
 */
+ (BOOL)isRetina;

/**
 *  检查是否是a Retina HD display
 */
+ (BOOL)isRetinaHD;

/**
 *  返回IOS版本号
 */
+ (NSInteger)iOSVersion;

/**
 *  返回CPU频率
 */
+ (NSUInteger)cpuFrequency;

/**
 *  返回总线频率
 */
+ (NSUInteger)busFrequency;

/**
 *  返回物理内存大小
 */
+ (NSUInteger)ramSize;

/**
 *  返回CPU数
 */
+ (NSUInteger)cpuNumber;

/**
 *  返回总内存
 */
+ (NSUInteger)totalMemory;

/**
 *  返回非内核内存
 */
+ (NSUInteger)userMemory;

/**
 *  返回文件系统空间
 */
+ (NSNumber *)totalDiskSpace;

/**
 *  返回文件系统剩余空间
 */
+ (NSNumber *)freeDiskSpace;

/**
 *  返回当前设备的mac地址
 */
+ (NSString *)macAddress;

/**
 *  返回唯一标识符
 */
+ (NSString *)uniqueIdentifier;
@end
