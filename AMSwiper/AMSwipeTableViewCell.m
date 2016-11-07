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
@property (nonatomic)SideDirection panDirection;
@property (nonatomic)SideDirection currentDirection;
@property (nonatomic)NSTimer * swipeDetectingTimer;
@property (nonatomic)CGFloat time;
@property (nonatomic)NSLayoutConstraint * leftContentConstraint;
@property (nonatomic)NSLayoutConstraint * rightContentConstraint;
@property (nonatomic)UIView * backView;
@end

@implementation AMSwipeTableViewCell

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.pan==gestureRecognizer)
    {
        self.startOffset=self.contentView.frame.origin.x;
        self.tapOffset=[gestureRecognizer locationInView:self.contentView].x;
        
        self.swipeDetectingTimer=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                    target:self
                                                  selector:@selector(timerTick)
                                                  userInfo:nil
                                                   repeats:YES];
        self.time=0.0;
        [self.swipeDetectingTimer fire];
    }
    return YES;
}

-(void)timerTick
{
    self.time+=0.01;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)init
{
    if(self=[super init])
    {
        self.backgroundView=[[UIView alloc] initWithFrame:self.contentView.frame];
        self.backgroundView.backgroundColor=[UIColor redColor];
        self.contentView.backgroundColor=[UIColor blueColor];
        [self.contentView removeFromSuperview];
        
        self.backView=[[UIView alloc] init];
        self.backView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addSubview:self.backView];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.backView
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.backView
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0f
                             constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.backView
                             attribute:NSLayoutAttributeLeading
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeLeading
                             multiplier:1.0f
                             constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.backView
                             attribute:NSLayoutAttributeTrailing
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeTrailing
                             multiplier:1.0f
                             constant:0.0]];
        
        [self.backView addSubview:self.contentView];
        self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
        self.leftContentConstraint=[NSLayoutConstraint
                                    constraintWithItem:self.contentView
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.backView
                                    attribute:NSLayoutAttributeLeading
                                    multiplier:1.0f
                                    constant:0.0];
        [self.backView addConstraint:self.leftContentConstraint];
        
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.contentView
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.backView
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:0.0]];
        
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.contentView
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.backView
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0f
                             constant:0.0]];
        
        self.rightContentConstraint=[NSLayoutConstraint
                                    constraintWithItem:self.contentView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.backView
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.0];
        [self.backView addConstraint:self.rightContentConstraint];
        
        self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
        self.pan.delegate=self;
        self.currentDirection=SideDirectionNone;
        [self.contentView addGestureRecognizer:self.pan];
        NSLog(@"%@",self.constraints);
    }
    return self;
}

-(void)moveFrontViewOnPosition:(CGFloat)position
{
    self.leftContentConstraint.constant=position;
    self.rightContentConstraint.constant=position;
    [self.backView layoutSubviews];
}

-(void)gesturePan
{
    CGPoint currentPoint=[self.pan locationInView:self];
    
    [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapOffset)];
    
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        
        NSLog(@"%@",self.constraints);
        NSLog(@"%@",self.backgroundView.constraints);
        NSLog(@"%@",self.contentView.constraints);
//        if(currentPoint.x>self.tapOffset)
//        {
//            self.panDirection=SideDirectionRight;
//        }
//        else
//        {
//            self.panDirection=SideDirectionLeft;
//        }
//        
//        if(self.time>=0.2)
//        {
//            if(self.startOffset+(currentPoint.x-self.tapOffset)<200/2)
//            {
//                self.panDirection=SideDirectionLeft;
//            }
//            else
//            {
//                self.panDirection=SideDirectionRight;
//            }
//        }
//        
//        [self.swipeDetectingTimer invalidate];
//        [self gestureSwipe];
    }
}

-(void)gestureSwipe
{
    if(self.currentDirection==SideDirectionNone)
    {
        if(self.panDirection==SideDirectionLeft)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FrontViewControllerWillApeared" object:nil];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
            {
                [self moveFrontViewOnPosition:-300.0];
            } completion:nil];
        }
        else if(self.panDirection==SideDirectionRight)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
            {
                [self moveFrontViewOnPosition:300.0];
            } completion:nil];
        }
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
