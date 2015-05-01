//
//  DialogView.h
//  Awars III
//
//  Created by Killery on 2013/01/03.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StringText.h"

@interface DialogView : NSView
{
    NSTimer *time;
    
    NSImage *charaImage;
}

-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y w:(float)w h:(float)h;

@end
