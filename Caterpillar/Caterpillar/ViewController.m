//
//  ViewController.m
//  Caterpillar
//
//  Created by lihonggui on 2016/12/14.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIView *bodyView;
@property(nonatomic,strong) UIDynamicAnimator *dynamic;
@property(nonatomic,strong) NSMutableArray *mutb;
@property(nonatomic,strong) UIAttachmentBehavior *attachment;
@end

@implementation ViewController
 int count = 9;
-(NSMutableArray *)mutb
{
    if (_mutb == nil) {
        _mutb = [NSMutableArray array];
    }
    return _mutb;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
/*******设置毛毛虫******/
   //身体
   
    for (int i = 0; i < count; i++) {
        
        UIView *viewMao = [[UIView alloc]init];
        [self.view addSubview:viewMao];
        [self.mutb addObject:viewMao];
        CGFloat margin = 10;
        CGFloat width = 2*margin;
        CGFloat x = margin +i*width;
        CGFloat y = 50;
        viewMao.frame = CGRectMake(x, y, width, width);
        viewMao.layer.cornerRadius = width/2;
        [viewMao setBackgroundColor:[UIColor blueColor]];
        
        //判断----设置头,最后一个view
        if (i == count -1) {
            [viewMao setBackgroundColor:[UIColor redColor]];
            CGFloat headViewX  = x;
            CGFloat headViewY = y - width/2;
            CGFloat headViewWidth = 2*width;
            viewMao.frame = CGRectMake(headViewX, headViewY, headViewWidth, headViewWidth);
            viewMao.layer.cornerRadius = headViewWidth/2;
            
        }
    }
//    for (int i = 0; i < count -1; i++) {
//        
//        //    设置附着行为
//        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:self.mutb[i] attachedToItem:self.mutb[i+1]];
//        [self.dynamic addBehavior:attachment];
//    }
//    
    
    [self physical];
}

#pragma mark
#pragma mark -  设置物理行为
-(void)physical
{
    //设置物理仿真行为
//    UIDynamicAnimator *dynamic = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.dynamic = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
//    _dynamic = dynamic;
    
    //设置重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:self.mutb];
    //设置重力矢量---方向崔垂直向下
    gravity.gravityDirection = CGVectorMake(0, 1);
    //重力
    gravity.magnitude = 1;
//    gravity.angle = 2;
    [self.dynamic addBehavior:gravity];
    
    //设置边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:self.mutb];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeEverything;
    [self.dynamic addBehavior:collision];
    
    for (int i = 0; i < count -1; i++) {
//
        //    设置附着行为
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:self.mutb[i] attachedToItem:self.mutb[i+1]];
        [self.dynamic addBehavior:attachment];
    }

}
#pragma mark
#pragma mark -  点击屏幕,脑袋附着鼠标移动
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //脑袋随着点击的点移动
    //取出脑袋---数组中最后一个
    #warning 遍历----只有脑袋才可以被附着-----点在脑袋内
    UIView *headView = [self.mutb lastObject];
    if (CGRectContainsPoint(headView.frame, point)) {
        
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:headView attachedToAnchor:point];
        self.attachment = attachment;
        [self.dynamic addBehavior:attachment];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //更改锚点
    _attachment.anchorPoint = point;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //删除附着
    [self.dynamic removeBehavior:self.attachment];
}
@end
