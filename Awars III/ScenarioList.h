//
//  ScenarioList.h
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventScene.h"
#import "StringText.h"

typedef struct _SCENARIO{
    NSString *name;
    
    NSImage *img;
    NSString *iName;
    
    NSMutableArray *sName;
    NSMutableArray *nameSceneStart;
    NSMutableArray *nameMAP;
    NSMutableArray *nameSceneEnd;
    
}SCENARIO;

SCENARIO SC[255];
int scenarioNumb;
int storyNumb;

@interface ScenarioList : NSObject
{
    NSTimer *time;
    
    IBOutlet NSWindow *titleWindow;
    
    IBOutlet NSPanel* SLPanel;
    NSPoint SLPpoint;
    
    NSMutableArray *scenarioListMA;
    IBOutlet NSArrayController *scenarioListAC;
    IBOutlet NSTableView *scenarioListTV;
    
    IBOutlet NSImageView *IVscene;
    IBOutlet NSPopUpButton *PUBscenario;
    
    NSArray *fileDataArray;
    NSInteger sceneNumb;
    
    int SCarray;
    
    IBOutlet NSWindow *eventSceneWindow;
}

-(IBAction)startButton:(id)sender;
-(IBAction)backButton:(id)sender;
-(IBAction)listButton:(id)sender;
-(IBAction)windowMove:(id)sender;
@end
