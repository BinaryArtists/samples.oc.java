
/*!
 *  @header BAKit.h
 *          BABaseProject
 *
 *  @brief  BAKit
 *
 *  @author 博爱
 *  @copyright    Copyright © 2016年 博爱. All rights reserved.
 *  @version    V1.0
 */

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

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
 * 博客    : http://boai.github.io
 
 *********************************************************************************
 
 */

#import "BAHomeViewModel.h"
#import "BAHomeVCModel.h"

@implementation BAHomeViewModel

- (void)setViewModel:(BAHomeVCModel *)viewModel
{
    _viewModel = viewModel;
    
    /*! 计算frame */
    [self setupCellFrame];
}

- (void)setupCellFrame
{
    /*! 标题Frame */
    CGFloat titleX = BAStatusCellMargin;
    CGFloat titleY = titleX;
    CGFloat titleW = BA_SCREEN_WIDTH - 2 * BAStatusCellMargin;
    CGSize titleSize = [BAAutoSizeWithWH BA_AutoSizeOfHeghtWithText:_viewModel.titleLabel font:[UIFont boldSystemFontOfSize:15] width:titleW];
    _titleLabelFrame = (CGRect){{titleX, titleY}, {titleSize.width, titleSize.height}};

    /*! 内容Frame */
    CGFloat contentLabelX = titleX;
    CGFloat contentLabelY = CGRectGetMaxY(_titleLabelFrame) + BAStatusCellMargin;
    CGFloat contentLabelW = BA_SCREEN_WIDTH - 2 * BAStatusCellMargin;
    CGSize contentLabelSize = [BAAutoSizeWithWH BA_AutoSizeOfHeghtWithText:_viewModel.contentLabel font:BA_FontSize(15) width:titleW];
    _contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, {contentLabelSize.width, contentLabelSize.height}};

    /*! 计算cell高度 */
    self.cellHeight = CGRectGetMaxY(_contentLabelFrame) + BAStatusCellMargin * 0.5;
}

@end
