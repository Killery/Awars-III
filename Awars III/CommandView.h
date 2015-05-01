//
//  CommandView.h
//  Awars III
//
//  Created by Killery on 2013/02/05.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int SLCx;
int SLCy;
bool DoubleClickedC;
bool CommandSelected;

@interface CommandView : NSView
{
    NSTimer *time;
    NSImage *chip;
    NSImage *chip2, *chip3, *chip4, *chip5;
    
    NSPoint selectPoint;
}

-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy;

@end
