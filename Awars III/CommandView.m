//
//  CommandView.m
//  Awars III
//
//  Created by Killery on 2013/02/05.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "CommandView.h"

@implementation CommandView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop:)
                 userInfo:nil
                 repeats:YES
                 ];
        
        chip = [[self LoadImage:@"マス.png"] retain];
        chip2 = [[self LoadImage:@"ccなし.png"] retain];
        chip3 = [[self LoadImage:@"cc建物.png"] retain];
        chip4 = [[self LoadImage:@"cc駒.png"] retain];
        chip5 = [[self LoadImage:@"セレクター.png"] retain];
        NSRect seRect;
        seRect.size.height = 1*32;
        seRect.size.width = 1*32;
    }
    
    return self;
}

-(void)EventLoop:(NSTimer*)time{
    
    [self setNeedsDisplay:YES];
}


-(BOOL)isFlipped{
    return YES;
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    //[image setFlipped:[self isFlipped]];
    
    return image;
}
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy{
    NSRect frRect;
    frRect.size.height = image.size.height;
    frRect.size.width = image.size.width;
    
    frRect.origin.x = 0;
    frRect.origin.y = 0;
    
    NSRect drRect;
    drRect.origin.x = x;
    drRect.origin.y = y;
    drRect.size.height = 32;
    drRect.size.width = 32;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f respectFlipped:YES hints:nil];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    selectPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    SLCx = (int)selectPoint.x/32;
    SLCy = (int)selectPoint.y/32;
    
    CommandSelected = true;
}

-(void)mouseUp:(NSEvent *)theEvent{
    if([theEvent clickCount] == 2) {
        DoubleClickedC = true;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self DrawImage:chip2 x:0 y:0 cx:0 cy:0];
    [self DrawImage:chip3 x:0 y:1*32 cx:1 cy:0];
    [self DrawImage:chip4 x:0 y:2*32 cx:2 cy:0];
    
    if(CommandSelected) [self DrawImage:chip5 x:0 y:SLCy*32 cx:0 cy:0];
}

@end
