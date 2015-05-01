//
//  ChipView.m
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "ChipView.h"

@implementation ChipView

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
        chip2 = [[self LoadImage:@"セレクター.png"] retain];
        chipA = [[self LoadImage:@"cc旗青.png"] retain];
        chipB = [[self LoadImage:@"cc旗青2.png"] retain];
        chipC = [[self LoadImage:@"cc旗赤.png"] retain];
        chipD = [[self LoadImage:@"cc旗赤2.png"] retain];
        chipE = [[self LoadImage:@"cc旗黄.png"] retain];
        chipF = [[self LoadImage:@"cc旗黄2.png"] retain];
        chipa = [[self LoadImage:@"ccはた青.png"] retain];
        chipb = [[self LoadImage:@"ccはた青2.png"] retain];
        chipc = [[self LoadImage:@"ccはた赤.png"] retain];
        chipd = [[self LoadImage:@"ccはた赤2.png"] retain];
        chipe = [[self LoadImage:@"ccはた黄.png"] retain];
        chipf = [[self LoadImage:@"ccはた黄2.png"] retain];
        
        NSRect seRect;
        seRect.size.height = 20*32;
        seRect.size.width = 20*32;
    }
    
    return self;
}

-(void)EventLoop:(NSTimer*)time{
    
    SLindex = (SLy*3 + SLx)+(MapChipListIndex-1)*24;
    SLindexB = (SLy*3 + SLx)+(BuildChipListIndex-1)*24;
    SLindexU = (SLy*3 + SLx)+(UnitChipListIndex-1)*24;
    SLindexL = (SLy*3 + SLx)+(LoadChipListIndex-1)*24;
    
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
    
    SLx = (int)selectPoint.x/32;
    SLy = (int)selectPoint.y/32;
    
    CommandSelected = false;
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    int bx, by;
    
    
    if(SLCy == 1 && SLSx == 0){
        for(bx=0;bx<3;bx++){
            for(by=0;by<8;by++){
                [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
                [self DrawImage:chipa x:0*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipb x:1*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipc x:2*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipd x:0*32 y:1*32 cx:bx cy:by];
                [self DrawImage:chipe x:1*32 y:1*32 cx:bx cy:by];
                [self DrawImage:chipf x:2*32 y:1*32 cx:bx cy:by];
            }
        }
    }else if(SLCy == 2 && SLSx == 0){
        for(bx=0;bx<3;bx++){
            for(by=0;by<8;by++){
                [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
                [self DrawImage:chipA x:0*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipB x:1*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipC x:2*32 y:0*32 cx:bx cy:by];
                [self DrawImage:chipD x:0*32 y:1*32 cx:bx cy:by];
                [self DrawImage:chipE x:1*32 y:1*32 cx:bx cy:by];
                [self DrawImage:chipF x:2*32 y:1*32 cx:bx cy:by];
            }
        }
    }else if (SLSx == 0) {
    for(bx=0;bx<3;bx++){
        for(by=0;by<8;by++){
            [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
            NSImage *MCI = MC[(by*3 + bx)+(MapChipListIndex-1)*24].img;
            //[MCI setFlipped:[self isFlipped]];
            [self DrawImage:MCI x:bx*32 y:by*32 cx:bx cy:by];
        }
    }
    }else if(SLSx == 1){
        for(bx=0;bx<3;bx++){
            for(by=0;by<8;by++){
                [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
                NSImage *BCI = BC[(by*3 + bx)+(BuildChipListIndex-1)*24].img;
                [BCI setFlipped:NO];
                [self DrawImage:BCI x:bx*32 y:by*32 cx:bx cy:by];
            }
        }
    }else if(SLSx == 2){
        for(bx=0;bx<3;bx++){
            for(by=0;by<8;by++){
                [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
                NSImage *UCI = UC[(by*3 + bx)+(UnitChipListIndex-1)*24].img;
                [UCI setFlipped:NO];
                [self DrawImage:UCI x:bx*32 y:by*32 cx:bx cy:by];
            }
        }
    }else if(SLSx == 3){
    for(bx=0;bx<3;bx++){
        for(by=0;by<8;by++){
            [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
            NSImage *LCI = LC[(by*3 + bx)+(LoadChipListIndex-1)*24].img;
            //[UCI setFlipped:true];
            [self DrawImage:LCI x:bx*32 y:by*32 cx:bx cy:by];
            }
        }
    }


    if(!CommandSelected) [self DrawImage:chip2 x:SLx*32 y:SLy*32 cx:SLx cy:SLy];
}

@end
