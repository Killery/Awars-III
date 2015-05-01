//
//  SChipView.h
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapChipList.h"
#import "BuildChipList.h"
#import "UnitChipList.h"

@interface SChipView : NSView
{
    NSImage *chip;
}
-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy;

@end
