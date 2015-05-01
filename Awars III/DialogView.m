//
//  DialogView.m
//  Awars III
//
//  Created by Killery on 2013/01/03.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop0:)
                 userInfo:nil
                 repeats:YES
                 ];
       charaImage = [[self LoadImage:@"立ち絵.png"] retain];
    }
    
    return self;
}

-(void)EventLoop0:(NSTimer*)time{
    [self setNeedsDisplay:YES];
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    [image setFlipped:[self isFlipped]];
    
    return image;
}
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y w:(float)w h:(float)h{
    NSRect frRect;
    frRect.size.height = 0;
    frRect.size.width = 0;
    
    frRect.origin.x = 0;
    frRect.origin.y = 0;
    
    NSRect drRect;
    drRect.origin.x = x;
    drRect.origin.y = y;
    drRect.size.height = h;
    drRect.size.width = w;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    mouseDowned = true;
    mouseClicked = true;
}




-(void)mouseUp:(NSEvent *)theEvent{
    mouseHolding = false;
    mouseDowned = false;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(ST->standPossition == 0) [self DrawImage:ST->imgStand x:200 y:0 w:302 h:456];
    else if(ST->standPossition == 1) [self DrawImage:ST->imgStand x:350 y:0 w:302 h:456];
    else if(ST->standPossition == 2) [self DrawImage:ST->imgStand x:100 y:0 w:302 h:456];
}


@end
