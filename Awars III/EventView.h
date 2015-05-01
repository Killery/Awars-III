//
//  EventView.h
//  Awars III
//
//  Created by Killery on 2013/02/18.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EventScene.h"


@interface EventView : NSView
{
    NSTimer *time;
    
    NSImage *charaImage;
}

-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y w:(float)w h:(float)h;
@end
