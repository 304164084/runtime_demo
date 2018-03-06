//
//  ViewController.m
//  Runtime_testing
//
//  Created by ZTL_Sui on 2018/2/28.
//  Copyright © 2018年 ZTL_Sui. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
/// 动态添加方法
#import "UsrModel.h"
/// 动态关联一个弱引用的对象
#import "BSWeakLabel.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testMethod];
//    [self objc_associatedMethod];
//    [self checkMemoryIsContainWeakLabel];
}
#pragma mark - 动态添加方法
- (void)testMethod
{
    UsrModel *uModel = [[UsrModel alloc] init];
    id run = [uModel performSelector:@selector(run:) withObject:@1];
    NSLog(@"run -->%@",run);
    if ([uModel respondsToSelector:@selector(eat)])
    {
        id result;
        result = [uModel performSelector:@selector(eat)];
        /// performSelector:方法返回值为id类型, 此id类型必须是OC所有的数据类型（结构体类型）
        /// 如果返回的是C语音的数据类型会crash
        NSString *string = [result stringValue];
        NSLog(@"%@",string);
    }
    
    
}

- (void)objc_associatedMethod
{
    NSArray *array = [NSArray arrayWithObjects:@"one", @"two", @"three", @"four", nil];
    NSString *keyWord = [NSString stringWithFormat:@"%@, %@",@"five", @"six"];
    
    /// 将keyword作为子分支, 关联到array主分支上。
    objc_setAssociatedObject(array, &keyWord, keyWord, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /// 通过关键字, 在主分支上获取子分支
    NSString *result = objc_getAssociatedObject(array, &keyWord);
    NSLog(@"result is ->%@",result); // 打印 result is -> five, six
    
    /// 释放关联对象
    //第三个参数设为 nil, 则将 array 与 nil 相关联, 等同于没有关联对象;
    objc_setAssociatedObject(array, &keyWord, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_removeAssociatedObjects(array);
}


- (void)checkMemoryIsContainWeakLabel
{
    BSWeakLabel *weakLabel = [[BSWeakLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    NSLog(@"%p",weakLabel.weakLabel);
    weakLabel.weakLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:weakLabel];
}



@end
