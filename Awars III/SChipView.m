//
//  SChipView.m
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "SChipView.h"

@implementation SChipView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        chip = [[self LoadImage:@"マス.png"] retain];
        NSRect seRect;
        seRect.size.height = 1*32;
        seRect.size.width = 1*32;
    }
    
    return self;
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

- (void)drawRect:(NSRect)dirtyRect
{
    int bx, by;
    for(bx=0;bx<1;bx++){
        for(by=0;by<1;by++){
            [self DrawImage:chip x:bx*32 y:by*32 cx:bx cy:by];
        }
        
    }
}


@end
