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
@property (nonatomic)CGPoint tapPoint;
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
@property (nonatomic)NSMutableArray * leftViewsWidth;
@property (nonatomic)NSMutableArray * rightViewsWidth;
@end

@implementation AMSwipeTableViewCell

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.pan==gestureRecognizer)
    {
        self.startOffset=self.contentView.frame.origin.x;
        self.tapPoint=[gestureRecognizer locationInView:self];
        
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    return YES;
}

-(void)setConstraintsForView:(UIView *)rootView forDirection:(SideDirection)direction
{
    NSArray<UIView *> * views=direction==SideDirectionLeft?self.rightButtons:self.leftButtons;
    NSArray * viewsWidth=direction==SideDirectionLeft?self.rightViewsWidth:self.leftViewsWidth;
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
            CGFloat del=[viewsWidth[i] doubleValue]?[viewsWidth[i+1] doubleValue]/[viewsWidth[i] doubleValue]:1;
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
    if(!self.backView)
    {
        [self initialize];
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initialize];
    }
    return self;
}

-(instancetype)init
{
    if(self=[super init])
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    _rightButtons=[NSArray array];
    _leftButtons=[NSArray array];
    self.leftViewsWidth=[NSMutableArray array];
    self.rightViewsWidth=[NSMutableArray array];
    self.backgroundView=[[UIView alloc] initWithFrame:self.contentView.frame];
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
    //self.pan.enabled=NO;
    self.currentDirection=SideDirectionNone;
    [self.contentView addGestureRecognizer:self.pan];
}

-(void)moveFrontViewOnPosition:(CGFloat)position
{
    self.leftContentConstraint.constant=position;
    self.rightContentConstraint.constant=position;
    self.leftButtonsConstraint.constant=self.currentDirection==SideDirectionRight?position:-position;
    [self.backView layoutSubviews];
}

-(CGFloat)calculateViewsWidth
{
    CGFloat result=0;
    if(self.currentDirection==SideDirectionLeft)
    {
        for(NSNumber * num in self.rightViewsWidth)
        {
            result+=num.doubleValue;
        }
    }
    else
    {
        for(NSNumber * num in self.leftViewsWidth)
        {
            result+=num.doubleValue;
        }
    }
    return result;
}

-(void)setCurrentDirection:(SideDirection)currentDirection
{
    _currentDirection=currentDirection;
    [self setSelected:NO];
    if(currentDirection!=SideDirectionNone)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else
    {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
    }
}

-(void)gesturePan
{
    CGPoint currentPoint=[self.pan locationInView:self];
    CGFloat height=currentPoint.y-self.tapPoint.y;
    height=height<0?-height:height;
    CGFloat width=currentPoint.x-self.tapPoint.x;
    width=width<0?-width:width;
    
//    if(height>width)
//    {
//        self.pan.enabled=NO;
//        [self.pan setValue:[NSNumber numberWithLong:UIGestureRecognizerStateEnded] forKey:@"state"];
//        NSLog(@"%lu",self.pan.state);
//        NSLog(@"%lu",UIGestureRecognizerStateEnded);
//        return;
//    }
//    
    if(self.currentDirection==SideDirectionLeft && self.startOffset+(currentPoint.x-self.tapPoint.x)<1 && self.rightButtons.count)
    {
        [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapPoint.x)];
    }
    else if(self.currentDirection==SideDirectionRight && self.startOffset+(currentPoint.x-self.tapPoint.x)>1  && self.leftButtons.count)
    {
        [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapPoint.x)];
    }
    else if(self.currentDirection==SideDirectionNone)
    {
        if(currentPoint.x>self.tapPoint.x)
        {
            self.currentDirection=SideDirectionRight;
            self.maxWidth=[self calculateViewsWidth];
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
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.backView
                                          attribute:NSLayoutAttributeLeading
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
            
            [self setConstraintsForView:self.buttonsView forDirection:SideDirectionRight];
        }
        else if(currentPoint.x<self.tapPoint.x)
        {
            self.currentDirection=SideDirectionLeft;
            self.maxWidth=[self calculateViewsWidth];
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
            
            [self setConstraintsForView:self.buttonsView forDirection:SideDirectionLeft];
        }
        else
        {
            self.currentDirection=SideDirectionNone;
        }
        
        if((self.currentDirection==SideDirectionLeft && self.rightButtons.count) || (self.currentDirection==SideDirectionRight && self.leftButtons.count))
        {
            [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapPoint.x)];
        }
    }
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        if(currentPoint.x>self.tapPoint.x)
        {
            self.panDirection=SideDirectionRight;
        }
        else
        {
            self.panDirection=SideDirectionLeft;
        }
        
        if(self.time>=0.2)
        {
            CGFloat temp=self.leftButtonsConstraint.constant;
            if(temp>self.maxWidth/2)
            {
                self.panDirection=self.currentDirection==SideDirectionRight?SideDirectionRight:SideDirectionLeft;
            }
            else
            {
                self.panDirection=self.currentDirection==SideDirectionLeft?SideDirectionRight:SideDirectionLeft;
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
            } completion:^(BOOL finished)
            {
                if(finished)
                {
                    self.currentDirection=SideDirectionLeft;
                }
            }];
        }
        else if(self.panDirection==SideDirectionRight)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=-self.maxWidth;
            self.rightContentConstraint.constant=-self.maxWidth;
            self.leftButtonsConstraint.constant=self.maxWidth;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.backView layoutIfNeeded];
             } completion:^(BOOL finished)
             {
                 if(finished)
                 {
                     self.currentDirection=SideDirectionRight;
                     [self.buttonsView removeFromSuperview];
                 }
             }];
        }
    }
    else if(self.currentDirection==SideDirectionLeft)
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
             } completion:^(BOOL finished)
             {
                 if(finished)
                 {
                     self.currentDirection=SideDirectionLeft;
                 }
             }];
        }
        else if(self.panDirection==SideDirectionRight)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=0;
            self.rightContentConstraint.constant=0;
            self.leftButtonsConstraint.constant=0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.backView layoutIfNeeded];
             } completion:^(BOOL finished)
             {
                 if(finished)
                 {
                     self.currentDirection=SideDirectionNone;
                     [self.buttonsView removeFromSuperview];
                 }
             }];
        }
    }
    else if(self.currentDirection==SideDirectionRight)
    {
        if(self.panDirection==SideDirectionLeft)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FrontViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=0;
            self.rightContentConstraint.constant=0;
            self.leftButtonsConstraint.constant=0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.backView layoutIfNeeded];
             } completion:^(BOOL finished)
             {
                 if(finished)
                 {
                     self.currentDirection=SideDirectionNone;
                     [self.buttonsView removeFromSuperview];
                 }
             }];
        }
        else if(self.panDirection==SideDirectionRight)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
            self.leftContentConstraint.constant=self.maxWidth;
            self.rightContentConstraint.constant=self.maxWidth;
            self.leftButtonsConstraint.constant=self.maxWidth;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.backView layoutIfNeeded];
             } completion:^(BOOL finished)
             {
                 if(finished)
                 {
                     self.currentDirection=SideDirectionRight;
                 }
             }];
        }
    }
}

-(void)setClipsForAllViewsForView:(UIView *)view
{
    [view setClipsToBounds:YES];
    NSArray * subViews=view.subviews;
    for(UIView * subView in subViews)
    {
        [self setClipsForAllViewsForView:subView];
    }
}

-(void)close
{
    if(self.currentDirection)
    {
        if(self.currentDirection==SideDirectionLeft)
        {
            self.panDirection=SideDirectionRight;
            [self gestureSwipe];
        }
        else
        {
            self.panDirection=SideDirectionLeft;
            [self gestureSwipe];
        }
    }
}


-(void)addView:(UIView *)view forDirection:(SideDirection)direction widthAction:(void (^)(void))action
{
    if(direction==SideDirectionLeft)
    {
        _leftButtons=[self.leftButtons arrayByAddingObject:view];
        [self.leftViewsWidth addObject:[NSNumber numberWithDouble:view.frame.size.width]];
    }
    else if(direction==SideDirectionRight)
    {
        _rightButtons=[self.rightButtons arrayByAddingObject:view];
        [self.rightViewsWidth addObject:[NSNumber numberWithDouble:view.frame.size.width]];
    }
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setClipsForAllViewsForView:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if(selected)
//    {
//        self.pan.enabled=YES;
//    }
    // Configure the view for the selected state
}

@end
