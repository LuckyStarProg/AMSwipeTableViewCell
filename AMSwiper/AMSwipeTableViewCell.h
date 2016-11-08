//
//  AMSwipeTableViewCell.h
//  AMSwiper
//
//  Created by Амин on 07.11.16.
//  Copyright © 2016 singl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SideDirection)
{
    SideDirectionNone=0,
    SideDirectionRight,
    SideDirectionLeft
};

@interface AMSwipeTableViewCell : UITableViewCell

@property (nonatomic, readonly)NSArray<UIView *> * rightButtons;
@property (nonatomic, readonly)NSArray<UIView *> * leftButtons;

-(void)addView:(UIView *)view forDirection:(SideDirection)direction;

@end
