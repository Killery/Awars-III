//
//  BattleView.m
//  Awars III
//
//  Created by Killery on 2013/03/23.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "BattleView.h"

@implementation BattleView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent{
    
    bLoopFlag = false;


}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
