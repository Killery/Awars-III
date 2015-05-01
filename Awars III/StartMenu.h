//
//  StartMenu.h
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartMenu : NSObject
{
    IBOutlet NSWindow* StartMenuWindow;
}

-(IBAction)Start:(id)sender;
-(IBAction)Back:(id)sender;


@end
