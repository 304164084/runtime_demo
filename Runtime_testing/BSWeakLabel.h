//
//  BSWeakLabel.h
//  Runtime_testing
//
//  Created by ZTL_Sui on 2018/3/2.
//  Copyright © 2018年 ZTL_Sui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSWeakLabel : UIView
/**
 添加一个弱引用的label, 再使用runtime的关联方法将之与self.view 关联,查看label是否存在于内存中
 */
@property (nonatomic, weak) UILabel *weakLabel;

@end
