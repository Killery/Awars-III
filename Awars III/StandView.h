//
//  StandView.h
//  Awars III
//
//  Created by Killery on 2013/11/07.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScenarioEditor.h"

int imgGx;
int imgGy;

@interface StandView : NSView
{
    NSTimer *time;
    NSImage *testImage;
    
    NSPoint startPoint;
    NSPoint endPoint;
}
@end
