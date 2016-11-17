//
//  AMActionObject.h
//  AMSwiper
//
//  Created by Амин on 09.11.16.
//  Copyright © 2016 singl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMActionObject : NSObject
@property (nonatomic)UIView * button;
@property (nonatomic)CGFloat width;
@property (nonatomic)void (^action)(void);
@end
