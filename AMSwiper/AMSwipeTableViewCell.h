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
    SideDirectionRight=0,
    SideDirectionLeft
};

@interface AMSwipeTableViewCell : UITableViewCell

@property (nonatomic, readonly)NSArray<UIButton *> * rightButtons;
@property (nonatomic, readonly)NSArray<UIButton *> * leftButtons;

-(void)addButton:(UIButton *)button forDirection:(SideDirection)direction;

@end
