//
//  ChipView.h
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapChipList.h"
#import "BuildChipList.h"
#import "UnitChipList.h"
#import "LoadChipList.h"
#import "MapEditor.h"
#import "SeedView.h"
#import "CommandView.h"

int SLx;
int SLy;
int SLindex;
int SLindexB;
int SLindexU;
int SLindexL;

@interface ChipView : NSView
{
    NSTimer *time;
    
    NSImage *chip;
    NSImage *chip2;
    NSImage *chipA, *chipB, *chipC, *chipD, *chipE, *chipF;
    NSImage *chipa, *chipb, *chipc, *chipd, *chipe, *chipf;
    
    NSPoint selectPoint;
}

-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy;

@end
