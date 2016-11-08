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
@property (nonatomic)NSLayoutConstraint * leftButtonsConstraint;
@property (nonatomic)UIView * backView;
@property (nonatomic)UIView * buttonsView;
@property (nonatomic)CGFloat maxWidth;
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
        self.maxWidth=[self calculateViewsWidthForArray:self.rightButtons];
        self.buttonsView=[[UIView alloc] init];
        self.buttonsView.backgroundColor=[UIColor greenColor];
        self.buttonsView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.backView addSubview:self.buttonsView];
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.buttonsView
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.backView
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:0.0]];
        
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.buttonsView
                             attribute:NSLayoutAttributeTrailing
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.backView
                             attribute:NSLayoutAttributeTrailing
                             multiplier:1.0f
                             constant:0.0]];
        
        self.leftButtonsConstraint=[NSLayoutConstraint
                                    constraintWithItem:self.buttonsView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0f
                                    constant:0.0];
        [self.buttonsView addConstraint:self.leftButtonsConstraint];
        
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.buttonsView
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.backView
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0f
                             constant:0.0]];
        
        [self setConstraintsForView:self.buttonsView byUsingViewsArray:self.rightButtons];
        self.time=0.0;
        [self.swipeDetectingTimer fire];
    }
    return YES;
}

-(void)setConstraintsForView:(UIView *)rootView byUsingViewsArray:(NSArray<UIView *> *)views
{
    for(NSUInteger i=0;i<views.count;++i)
    {
        [rootView addSubview:views[i]];
    }
    
    for(NSUInteger i=0;i<views.count;++i)
    {
        [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:views[i]
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:rootView
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0f
                                         constant:0.0]];
        
        [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:views[i]
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:rootView
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0f
                                         constant:0.0]];
        if(views.count>0 && i+1!=views.count)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:views[i]
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:views[i+1]
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:1.0f
                                         constant:0.0]];
            
            CGFloat del=views[i].frame.size.width?views[i+1].frame.size.width/views[i].frame.size.width:1;
            del=del?del:1;
            [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:views[i]
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:views[i+1]
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1.0f/del
                                         constant:0.0]];
        }
    }
    
    for(NSInteger i=0;i<views.count;++i)
    {
        if(i-1<0)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:views[i]
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:rootView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f
                                     constant:0.0]];
        }
        else
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:views[i]
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:views[i-1]
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:0.0]];
        }
        
        if(i+1==views.count)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:views[i]
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:rootView
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:0.0]];
        }
        else
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:views[i]
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:views[i+1]
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f
                                     constant:0.0]];
        }
    }
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
        _rightButtons=[NSArray array];
        _leftButtons=[NSArray array];
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
        
        [self.backView addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.backView
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                             multiplier:1.0f
                             constant:self.contentView.frame.size.width]];
        
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
    self.leftButtonsConstraint.constant=-position;
    [self.backView layoutSubviews];
}

-(CGFloat)calculateViewsWidthForArray:(NSArray<UIView *> *)views
{
    CGFloat result=0;
    for(NSInteger i=0; i<views.count; ++i)
    {
        CGFloat currentWidth=views[i].frame.size.width;
        if(!currentWidth && i-1>=0)
        {
            currentWidth=views[i-1].frame.size.width;
        }
        else if(!currentWidth && i+1!=views.count && views[i+1].frame.size.width)
        {
            currentWidth=views[i+1].frame.size.width;
        }
        else if(!currentWidth)
        {
            currentWidth=100.0;
        }
        result+=currentWidth;
    }
    return result;
}

-(void)gesturePan
{
    CGPoint currentPoint=[self.pan locationInView:self];
    [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapOffset)];
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        if(currentPoint.x>self.tapOffset)
        {
            self.panDirection=SideDirectionRight;
        }
        else
        {
            self.panDirection=SideDirectionLeft;
        }
        
        if(self.time>=0.2)
        {
            if(self.startOffset+(currentPoint.x-self.tapOffset)<self.maxWidth/2)
            {
                self.panDirection=SideDirectionLeft;
            }
            else
            {
                self.panDirection=SideDirectionRight;
            }
        }
        
        [self.swipeDetectingTimer invalidate];
        [self gestureSwipe];
    }
}

-(void)gestureSwipe
{
    if(self.currentDirection==SideDirectionNone)
    {
        if(self.panDirection==SideDirectionLeft)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FrontViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=-self.maxWidth;
            self.rightContentConstraint.constant=-self.maxWidth;
            self.leftButtonsConstraint.constant=self.maxWidth;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
            {
                [self.backView layoutIfNeeded];
            } completion:nil];
        }
        else if(self.panDirection==SideDirectionRight)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=self.maxWidth;
            self.rightContentConstraint.constant=self.maxWidth;
            self.leftButtonsConstraint.constant=-self.maxWidth;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.backView layoutIfNeeded];
             } completion:nil];
        }
    }
}

-(void)addView:(UIView *)view forDirection:(SideDirection)direction;
{
    if(direction==SideDirectionLeft)
    {
        _leftButtons=[self.leftButtons arrayByAddingObject:view];
    }
    else if(direction==SideDirectionRight)
    {
        _rightButtons=[self.rightButtons arrayByAddingObject:view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
