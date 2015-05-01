//
//  Title.m
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//0120-001-144

#import "Title.h"

@implementation Title

-(void)awakeFromNib{
    [IVTitle setImageScaling:NSScaleToFit];
}

-(IBAction)Start:(id)sender{
    [StartWindow makeKeyAndOrderFront:nil];
    [NSApp runModalForWindow:StartWindow];
}
-(IBAction)Continue:(id)sender{
    [ContinueWindow makeKeyAndOrderFront:nil];
    [NSApp runModalForWindow:ContinueWindow];
}
-(IBAction)Gallery:(id)sender{
    [GalleryWindow makeKeyAndOrderFront:nil];
    windowPoint.x = [TitleWindow frame].origin.x;
    windowPoint.y = [TitleWindow frame].origin.y;
    [GalleryWindow setFrameOrigin:windowPoint];
    [TitleWindow close];
    
}
-(IBAction)Option:(id)sender{
    [OptionWindow makeKeyAndOrderFront:nil];
}
-(IBAction)MapEditor:(id)sender{
    [MapEditorWindow makeKeyAndOrderFront:nil];
    windowPoint.x = [TitleWindow frame].origin.x;
    windowPoint.y = [TitleWindow frame].origin.y;
    [MapEditorWindow setFrameOrigin:windowPoint];
    [TitleWindow close];
}
-(IBAction)ScenarioEditor:(id)sender{
    [ScenarioEditorWindow makeKeyAndOrderFront:nil];
}
-(IBAction)Quit:(id)sender{
    [NSApp terminate:self];
}

@end
