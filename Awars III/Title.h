//
//  Title.h
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Title : NSObject
{
    IBOutlet NSWindow* TitleWindow;
    
    IBOutlet NSWindow* StartWindow;
    IBOutlet NSWindow* ContinueWindow;
    IBOutlet NSWindow* GalleryWindow;
    IBOutlet NSWindow* OptionWindow;
    IBOutlet NSWindow* MapEditorWindow;
    IBOutlet NSWindow* ScenarioEditorWindow;
    
    IBOutlet NSImageView *IVTitle;
    NSPoint windowPoint;
}


-(IBAction)Start:(id)sender;
-(IBAction)Continue:(id)sender;
-(IBAction)Gallery:(id)sender;
-(IBAction)Option:(id)sender;
-(IBAction)MapEditor:(id)sender;
-(IBAction)ScenarioEditor:(id)sender;
-(IBAction)Quit:(id)sender;


@end
