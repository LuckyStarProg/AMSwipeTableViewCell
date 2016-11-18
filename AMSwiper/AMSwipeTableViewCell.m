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
@property (nonatomic)NSMutableArray<AMActionObject *> * leftObjects;
@property (nonatomic)NSMutableArray<AMActionObject *> * rightObjects;
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

-(NSArray<UIView *> *)rightButtons
{
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:self.rightObjects.count];
    for(NSUInteger i=0;i<self.rightObjects.count;++i)
    {
        array[i]=self.rightObjects[i].button;
    }
    return array;
}

-(NSArray<UIView *> *)leftButtons
{
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:self.leftObjects.count];
    for(NSUInteger i=0;i<self.leftObjects.count;++i)
    {
        array[i]=self.leftObjects[i].button;
    }
    return array;
}

-(void)setConstraintsForView:(UIView *)rootView forDirection:(SideDirection)direction
{
    NSArray<AMActionObject *> * array=direction==SideDirectionLeft?self.rightObjects:self.leftObjects;
    for(NSUInteger i=0;i<array.count;++i)
    {
        [rootView addSubview:array[i].button];
    }
    
    for(NSUInteger i=0;i<array.count;++i)
    {
        [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:array[i].button
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:rootView
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0f
                                         constant:0.0]];
        
        [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:array[i].button
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:rootView
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0f
                                         constant:0.0]];
        if(array.count>0 && i+1!=array.count)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:array[i].button
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:array[i+1].button
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:1.0f
                                         constant:0.0]];
            CGFloat del=array[i].width?array[i+1].width/array[i].width:1;
            del=del?del:1;
            [rootView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:array[i].button
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:array[i+1].button
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1.0f/del
                                         constant:0.0]];
        }
    }
    
    for(NSInteger i=0;i<array.count;++i)
    {
        if(i-1<0)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:array[i].button
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
                                     constraintWithItem:array[i].button
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:array[i-1].button
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:0.0]];
        }
        
        if(i+1==array.count)
        {
            [rootView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:array[i].button
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
                                     constraintWithItem:array[i].button
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:array[i+1].button
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

-(void)initialize
{
    self.leftObjects=[NSMutableArray array];
    self.rightObjects=[NSMutableArray array];
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
        for(AMActionObject * obj in self.rightObjects)
        {
            result+=obj.width;
        }
    }
    else
    {
        for(AMActionObject * obj in self.leftObjects)
        {
            result+=obj.width;
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

    if(self.currentDirection==SideDirectionLeft && self.startOffset+(currentPoint.x-self.tapPoint.x)<1 && self.rightObjects.count)
    {
        [self moveFrontViewOnPosition:self.startOffset+(currentPoint.x-self.tapPoint.x)];
    }
    else if(self.currentDirection==SideDirectionRight && self.startOffset+(currentPoint.x-self.tapPoint.x)>1  && self.leftObjects.count)
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
        
        if((self.currentDirection==SideDirectionLeft && self.rightObjects.count) || (self.currentDirection==SideDirectionRight && self.leftObjects.count))
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

-(void)buttonTrigered:(UIView *)view
{
        if(self.currentDirection==SideDirectionLeft)
        {
            for(NSUInteger i=0;i<self.rightObjects.count;++i)
            {
                if(view==self.rightObjects[i].button.subviews.lastObject)
                {
                    if(self.rightObjects[i].action) self.rightObjects[i].action();
                }
            }
        }
        else
        {
            for(NSUInteger i=0;i<self.leftObjects.count;++i)
            {
                if(view==self.leftObjects[i].button.subviews.lastObject)
                {
                    if(self.leftObjects[i].action) self.leftObjects[i].action();
                }
            }
        }
}

-(void)addButtonWithLabel:(UILabel *)label andBackgroundColor:(UIColor *)color forDirection:(SideDirection)direction withAction:(void (^)(void))action
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width, 0)];
    view.backgroundColor=color;
    label.translatesAutoresizingMaskIntoConstraints=NO;
    [view addSubview:label];
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:label
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1.0f
                         constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:label
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1.0f
                         constant:0.0]];
    
    [label addConstraint:[NSLayoutConstraint
                         constraintWithItem:label
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1.0f
                         constant:label.frame.size.width]];
    
    [label addConstraint:[NSLayoutConstraint
                         constraintWithItem:label
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1.0f
                         constant:label.frame.size.height]];
    [self addView:view forDirection:direction withAction:action];
}

-(void)addView:(UIView *)view forDirection:(SideDirection)direction withAction:(void (^)(void))action
{
    AMActionObject *obj=[AMActionObject new];
    obj.button=view;
    obj.width=view.frame.size.width;
    obj.action=action;
    if(direction==SideDirectionLeft)
    {
        [self.leftObjects addObject:obj];
    }
    else if(direction==SideDirectionRight)
    {
        [self.rightObjects addObject:obj];
    }
    
    UIControl * control=[[UIControl alloc] initWithFrame:view.frame];
    [control addTarget:self action:@selector(buttonTrigered:) forControlEvents:UIControlEventTouchUpInside];
    control.translatesAutoresizingMaskIntoConstraints=NO;
  
    [view addSubview:control];
    [view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:control
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:view
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0f
                                  constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:control
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:view
                                  attribute:NSLayoutAttributeLeading
                                  multiplier:1.0f
                                  constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:control
                         attribute:NSLayoutAttributeTrailing
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeTrailing
                         multiplier:1.0f
                         constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:control
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeTop
                         multiplier:1.0f
                         constant:0.0]];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setClipsForAllViewsForView:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
