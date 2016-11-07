//
//  AMSwipeTableViewCell.m
//  AMSwiper
//
//  Created by Амин on 07.11.16.
//  Copyright © 2016 singl. All rights reserved.
//

#import "AMSwipeTableViewCell.h"

@interface AMSwipeTableViewCell()
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)CGFloat startOffset;
@property (nonatomic)CGFloat tapOffset;
@property (nonatomic)SideDirection direction;
@end

@implementation AMSwipeTableViewCell

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.pan==gestureRecognizer)
    {
        self.startOffset=self.contentView.frame.origin.x;
        self.tapOffset=[gestureRecognizer locationInView:self.contentView].x;
    }
    return YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor redColor];
}

-(instancetype)init
{
    if(self=[super init])
    {
        self.backgroundView=[[UIView alloc] initWithFrame:self.contentView.frame];
        self.backgroundView.backgroundColor=[UIColor redColor];
        self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
        self.pan.delegate=self;
        [self.contentView addGestureRecognizer:self.pan];
        NSLog(@"%@",self.backgroundView);
    }
    return self;
}

-(void)moveFrontViewOnPosition:(CGFloat)position
{
    self.contentView.frame=
    CGRectMake(position,
               self.contentView.frame.origin.y,
               self.contentView.frame.size.width,
               self.contentView.frame.size.height);
}

-(void)gesturePan
{
    CGPoint currentPoint=[self.pan locationInView:self.contentView];
    
    [self moveFrontViewOnPosition:(currentPoint.x-self.tapOffset)];
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        
        if(currentPoint.x>self.tapOffset)
        {
            self.direction=SideDirectionRight;
        }
        else
        {
            self.direction=SideDirectionLeft;
        }
        
//        if(self.time>=0.2)
//        {
//            if(self.startPoint.x+(currentPoint.x-self.tapPoint.x)<MAX_OFFSET/2)
//            {
//                self.direction=SideDirectionLeft;
//            }
//            else
//            {
//                self.direction=SideDirectionRight;
//            }
//        }
//        
//        [self.timer invalidate];
//        [self gestureSwipe];
    }
}

-(void)addButton:(UIButton *)button forDirection:(SideDirection)direction
{
    if(direction)
    {
        _leftButtons=[self.leftButtons arrayByAddingObject:button];
    }
    else
    {
        _rightButtons=[self.leftButtons arrayByAddingObject:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
