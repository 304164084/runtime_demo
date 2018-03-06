//
//  BSWeakLabel.m
//  Runtime_testing
//
//  Created by ZTL_Sui on 2018/3/2.
//  Copyright © 2018年 ZTL_Sui. All rights reserved.
//

#import "BSWeakLabel.h"
#import <objc/runtime.h>


/**
  此份代码，是验证弱引用一个对象。然后通过runtime的关联方法，进行关联绑定。
  然后检测弱引用的对象是否分配内存，存在于内存中
 **/


@implementation BSWeakLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
        self.weakLabel = [[UILabel alloc] initWithFrame:self.bounds];
#pragma clang diagnostic pop
        NSLog(@"内存地址->%p",self.weakLabel);
        [self addSubview:self.weakLabel];
    }
    return self;
}

#pragma mark - 将weakLabel 与 self.view关联
static NSString const *weakLabelKey = @"weakLabelKey";
- (void)setWeakLabel:(UILabel *)weakLabel
{
    /// 将self.view 与 self.weakLabel 相关联。 self.view作为主分支, self.weakLabel作为子分支;
    objc_setAssociatedObject(self, @selector(weakLabel), self.weakLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)weakLabel
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
