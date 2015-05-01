//
//  ContinueMenu.h
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinueMenu : NSObject
{
    IBOutlet NSWindow* ContinueMenuWindow;
}

-(IBAction)Load:(id)sender;
-(IBAction)Back:(id)sender;

@end
