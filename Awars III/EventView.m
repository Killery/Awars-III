//
//  EventView.m
//  Awars III
//
//  Created by Killery on 2013/02/18.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "EventView.h"

@implementation EventView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.001f
                 target:self
                 selector:@selector(EventLoopEV:)
                 userInfo:nil
                 repeats:YES
                 ];
        charaImage = [[self LoadImage:@"立ち絵.png"] retain];
    }
    
    return self;
}

-(void)EventLoopEV:(NSTimer*)time{
    [self setNeedsDisplay:YES];
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    //[image setFlipped:[self isFlipped]];
    
    return image;
}
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y w:(float)w h:(float)h{
    NSRect frRect;
    frRect.size.height = image.size.height;
    frRect.size.width = image.size.width;
    frRect.origin.x = 0;
    frRect.origin.y = 0;
    
    NSRect drRect;
    drRect.origin.x = x;
    drRect.origin.y = y;
    drRect.size.height = h;
    drRect.size.width = w;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f respectFlipped:YES hints:nil];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    evMouseDowned = true;
    evMouseClicked = true;
}




-(void)mouseUp:(NSEvent *)theEvent{
    evMouseHolding = false;
    evMouseDowned = false;
}

- (void)drawRect:(NSRect)dirtyRect
{
    ST = evSTtop;
    if(!evSTtop){
        return;
    }
    int dCount = 0;
    while(dialogNumber > dCount) {dCount++;
        ST = ST->next;
    }
    
    if(!ST) return;
    if(ST->standPossition == 0) [self DrawImage:ST->imgStand x:200 y:0 w:302 h:456];
    else if(ST->standPossition == 1) [self DrawImage:ST->imgStand x:350 y:0 w:302 h:456];
    else if(ST->standPossition == 2) [self DrawImage:ST->imgStand x:100 y:0 w:302 h:456];
}

@end
