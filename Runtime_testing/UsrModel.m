//
//  UsrModel.m
//  Runtime_testing
//
//  Created by ZTL_Sui on 2018/2/28.
//  Copyright © 2018年 ZTL_Sui. All rights reserved.
//

#import "UsrModel.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UsrModel
#pragma clang diagnostie pop

/// 此处方法可以改写为OC实例方法
NSString * _c_method (id self, SEL _cmd, NSNumber *meter)
{
    NSLog(@"跑了 %@米", meter);
    return @"333";
}
/**
 * OC底层是通过消息机制来实现的。
 * objc_msgSend(id,SEL)来实现的。首先会在对象的类对象中查找方法的IMP(方法实现implementation)，若没有该方法的实现
 *
 * 1. 首先看是否为该 selector 提供了动态方法决议机制, 如果提供了则转到第2步，否则转第3步。
 * 2. 如果动态方法决议真的实现了该 selector 的IMP(implementation)，那么就会调用该实现，完成消息发送l流程。消息转发机制就不会进行；如果没有实现，则转到第3步(消息转发)
 * 3. 其次，看是否为该 selector 实现了消息转发机制。如果实现了消息转发，此时，无论消息转发如何实现的，程序均不会 crash。（因为消息调用的控制权完全交给消息转发机制处理。即使消息转发并没有实现做任何事情，运行也不会报错，编译器也不会有错误提示）；如果没有提供消息转发机制，则跳转第4步
 * 4. 运行报错：无法识别的 selector，程序crash。
 *
 *
 **/
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == NSSelectorFromString(@"run:"))
    {
        /// type: 解释 "s@:@" \
        /// s@:表示函数返回值;其中s表示返回字符串类型,v表示void,i表示int,以此类推;
        ///返回值类型后面的@表示参数,有几个参数就有几个@;
        class_addMethod(self, sel, (IMP)_c_method, "s@:@");

        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL name = [anInvocation selector];
    NSLog(@" >> forwardInvocation for selector %@", NSStringFromSelector(name));
    
    UsrModel * proxy = [[UsrModel alloc] init];
    if ([proxy respondsToSelector:name]) {
        [anInvocation invokeWithTarget:proxy];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

+(BOOL)resolveClassMethod:(SEL)name
{
    NSLog(@" >> Class resolving %@", NSStringFromSelector(name));
    return [super resolveClassMethod:name];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [UsrModel instanceMethodSignatureForSelector:aSelector];
}

-(void)Bar
{
    NSLog(@" >> Bar() in Foo.");
}
- (NSNumber *)eat
{
    NSLog(@"我吃了");
    return @43;
}

@end
