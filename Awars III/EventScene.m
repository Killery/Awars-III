//
//  EventScene.m
//  Awars III
//
//  Created by Killery on 2013/02/18.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "EventScene.h"

@implementation EventScene
-(void)awakeFromNib{

}
-(id)init
{
    [super init];
    if (self) {
        timer = [NSTimer
                 scheduledTimerWithTimeInterval:0.1
                 target:self selector:@selector(EventLoopES:)
                 userInfo:nil repeats:YES
                 ];
        dialogLengh = 1;
        dialogNumber = 1;
    }
    return self;
}


-(void)EventLoopES:(NSTimer *)timer{
    
    if(!startES) return;
    ST = NULL;
    static bool seFlag;
    
    if(startOrEndFlag){
        if(!seFlag){
            stringInitFlag = true;
            StringText *stringText = [[StringText alloc] init];
            [stringText InitStringList];
            stringInitFlag = false;
            seFlag = true;
        }
    }
    
   int dCount = 0;
    ST = evSTtop;
    
    if(!ST){
        if(!startOrEndFlag){
            mapInitFlag = true;
            MapView *mapInit = [[MapView alloc] init];
            [mapInit loadMapChip];
            mapInitFlag = false;
            [fsWindow makeKeyAndOrderFront:nil];
            [esWindow close];
            if(MF[MFselectedRow+1].MS.battleSetMode){
                setBattleModeFlag = true;
                NSPoint windowPoint;
                windowPoint.x = [esWindow frame].origin.x;
                windowPoint.y = [esWindow frame].origin.y;
                [bsWindow setFrameOrigin:windowPoint];
                [bsWindow makeKeyAndOrderFront:nil];
            }
            startOrEndFlag = true;
            startES = false;
            return;
        }else{
            seFlag = false;
            startES = false;
            startOrEndFlag = false;
            [titleWindow makeKeyAndOrderFront:nil];
            [esWindow close];
            return;
        }
    }
    
    if(jumpFlag){
        dialogNumber = 1;
        while(![jumpName isEqualToString:ST->labelName]) {
            dialogNumber++;
            ST = ST->next;
            if(!ST){
                break;
                dialogNumber -=1;
            }
        }
        dialogNumber--;
        jumpFlag = false;
        ST = evSTtop;
    }
    
    while(dialogNumber > dCount) {dCount++;
        ST = ST->next;
    }

    int textMax;
    NSString *text;
    NSString *tName;
    
    static float fiValue = 0;
    static float foValue = 1.0;
    static bool fadeFlag;
    static bool fadeOutRdy;
    static bool fadeInRdy;
    static bool omankoFlag;
    static bool ochinchinFlag;
    static bool blackGroundFlag;
    static NSImage *postImageWall;
    static int cnt = 0;
    if(cnt == 0){
        postImageWall = ST->imgWall;
        cnt++;
        if(!ST->imgWall){
            blackGroundFlag = true;
        }
    }
    
    if(evActiveEnd){evActiveEnd = false;
        
        if(startOrEndFlag){
            
            dialogNumber = 1;
            fiValue = 0;
            foValue = 1.0;
            fadeFlag = false;
            fadeOutRdy = false;
            fadeInRdy = false;
            omankoFlag = false;
            ochinchinFlag = false;
            blackGroundFlag = false;
            postImageWall = NULL;
            evActive = false;
            
            startOrEndFlag = false;
            cnt = 0;
            seFlag = false;
            startES = false;
            [titleWindow makeKeyAndOrderFront:nil];
            [esWindow close];
            return;
        }
        
        fadeFlag = false;
        mapInitFlag = true;
        MapView *mapInit = [[MapView alloc] init];
        [mapInit loadMapChip];
        mapInitFlag = false;
        [fsWindow makeKeyAndOrderFront:nil];
        [esWindow close];
        if(MF[MFselectedRow+1].MS.battleSetMode){
            setBattleModeFlag = true;
            NSPoint windowPoint;
            windowPoint.x = [esWindow frame].origin.x;
            windowPoint.y = [esWindow frame].origin.y;
            [bsWindow setFrameOrigin:windowPoint];
            [bsWindow makeKeyAndOrderFront:nil];
        }
        dialogNumber = 1;
        fiValue = 0;
        foValue = 1.0;
        fadeFlag = false;
        fadeOutRdy = false;
        fadeInRdy = false;
        omankoFlag = false;
        ochinchinFlag = false;
        blackGroundFlag = false;
        postImageWall = NULL;
        evActive = true;
        
        startOrEndFlag = true;
        cnt = 0;
        seFlag = false;
        startES = false;
        return;
    }
    
    
    if(namingFlag){
        [selectionDialog makeKeyAndOrderFront:nil];
        return;
    }
    
    if(selectionFlag){
        [trueSelectionDialog makeKeyAndOrderFront:nil];
        return;
    }
    
    NSString *oopsString = @"";
    //任意文字列置換
    NSArray *oopsArray = [ST->string componentsSeparatedByString:@"$$"];
    if([oopsArray count] > 1){
        NVALUE *NVtop = ST->N;
        while (ST->N) {
                if([[oopsArray objectAtIndex:1] isEqualToString:ST->N->key]){
                    oopsString = [oopsString stringByAppendingString:ST->N->value];
                break;
            }
            ST->N = ST->N->next;
        }
        oopsString = [oopsString stringByAppendingString:[oopsArray objectAtIndex:2]];
        ST->string = [[NSString stringWithString:oopsString] retain];
        //NSLog(@"%@", oopsString);
        ST->N = NVtop;
    }
    
    NSString *omfgString = @"";
    //任意文字列置換
    NSArray *omfgArray = [ST->name componentsSeparatedByString:@"$$"];
    if([omfgArray count] > 1){
        NVALUE *NVtop = ST->N;
        while (ST->N) {
            if([[omfgArray objectAtIndex:1] isEqualToString:ST->N->key] ){
                omfgString = [omfgString stringByAppendingString:ST->N->value];
                break;
            }
            ST->N = ST->N->next;
        }
        ST->name = [[NSString stringWithString:omfgString] retain];
        //NSLog(@"%@", omfgString);
        ST->N = NVtop;
    }
    
    if(ST->imgWall){
        blackGroundFlag = false;
        if(ST->wallFadeIn && fiValue == 0){
            fadeInRdy = true;
        }
        
        if(foValue == 0){
            fadeOutRdy = false;
        }
        postImageWall = ST->imgWall;
    }
    
    if(evActive && !evActiveEnd){
        textMax = (int)[ST->string length];
        text = ST->string;
        tName = ST->name;
        [nameTF setStringValue:tName];
        [dialogTF setStringValue:[text substringToIndex:dialogLengh - 1]];
        [faceIV setImage:ST->img];
        [faceIV setImageScaling:NSScaleToFit];
        [wallIV setImage:ST->imgWall];
        [wallIV setImageScaling:NSScaleToFit];
        [backIV setImageScaling:NSScaleToFit];
        
        if(fadeInRdy && fiValue < 1.0){fadeFlag = true;
            fiValue += 0.1;
            if(fiValue > 1.0) fiValue = 1.0;
            [wallIV setAlphaValue:fiValue];
            return;
        }
        
        if(dialogLengh < textMax) dialogLengh++;
        
        if(ST->next)
        if(evMouseClicked && dialogLengh == textMax && postImageWall != ST->next->imgWall && ST->wallFadeOut){
            fadeOutRdy = true;
            omankoFlag = true;
        }
        if(ST->next)
        if(evMouseClicked && dialogLengh == textMax && postImageWall != ST->next->imgWall && ST->next->wallFadeIn){
            fadeInRdy = true;
            ochinchinFlag = true;
        }
        
        if(ST->next)
        if(evMouseClicked && dialogLengh == textMax && postImageWall != ST->next->imgWall){
            omankoFlag = true;
        }
        
        if(fadeOutRdy && foValue > 0){fadeFlag = true;
            
            foValue -= 0.1;
            if(foValue < 0) foValue = 0;
            [wallIV setAlphaValue:foValue];
            return;
        }
        
        if(!fadeInRdy && !fadeOutRdy && ST->wallChanged){
            [wallIV setAlphaValue:1.0];
        }
        
        if(omankoFlag){omankoFlag = false;
            foValue = 1.0;
        }if(ochinchinFlag){ochinchinFlag = false;
            fiValue = 0;
            fadeInRdy = true;
        }
        
        fadeOutRdy = false;
        
        if(blackGroundFlag) {
            [wallIV setAlphaValue:0];
        }
        
        if(evMouseClicked){evMouseClicked = false;//マウスかグリックされたとき
            
            if(dialogNumber <= evDialogMax && dialogLengh == [text length]) {//テキストがマックスのとき
                dialogNumber++;
                dialogLengh = 1;
                
                if(ST->jumpName){
                    jumpFlag = true;
                    jumpName = [ST->jumpName retain];
                }
                if(ST->N){
                    
                    NSArray *omgArray = [ST->namingName componentsSeparatedByString:@"≠≠"];
                    if([omgArray count] > 1){
                    
                        if(ST->N->title){
                        namingFlag = true;
                        namingName = [ST->N->title retain];
                        }
                    }
                }
                
                
                if(namingFlag && ST->N){
                    if(ST->N->title)
                        [selectionDialog setTitle:ST->N->title];
                    else
                        [selectionDialog setTitle:@""];
                    [selectionDialog makeKeyAndOrderFront:nil];
                    
                }
                
                
                if(ST->S){
                    selectionFlag = true;
                    Slists = calloc(1, sizeof(SVALUE));
                    *Slists = *ST->S;
                    SlistsTop = Slists;
                    
                    [BTN1 setTransparent:YES];
                    [BTN1 setEnabled:NO];
                    [BTN2 setTransparent:YES];
                    [BTN2 setEnabled:NO];
                    [BTN3 setTransparent:YES];
                    [BTN3 setEnabled:NO];
                    [BTN4 setTransparent:YES];
                    [BTN4 setEnabled:NO];
                    [BTN5 setTransparent:YES];
                    [BTN5 setEnabled:NO];
                    [BTN6 setTransparent:YES];
                    [BTN6 setEnabled:NO];
                    [BTN7 setTransparent:YES];
                    [BTN7 setEnabled:NO];
                    [BTN8 setTransparent:YES];
                    [BTN8 setEnabled:NO];
                    [BTN9 setTransparent:YES];
                    [BTN9 setEnabled:NO];
                    
                    SVALUE *STStop = ST->S;
                    while (1) {
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN1 setTitle:ST->S->slct];
                            [BTN1 setTransparent:NO];
                            [BTN1 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 80) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN2 setTitle:ST->S->slct];
                            [BTN2 setTransparent:NO];
                            [BTN2 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 105) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN3 setTitle:ST->S->slct];
                            [BTN3 setTransparent:NO];
                            [BTN3 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 140) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN4 setTitle:ST->S->slct];
                            [BTN4 setTransparent:NO];
                            [BTN4 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 155) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN5 setTitle:ST->S->slct];
                            [BTN5 setTransparent:NO];
                            [BTN5 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 180) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN6 setTitle:ST->S->slct];
                            [BTN6 setTransparent:NO];
                            [BTN6 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 205) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN7 setTitle:ST->S->slct];
                            [BTN7 setTransparent:NO];
                            [BTN7 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 230) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN8 setTitle:ST->S->slct];
                            [BTN8 setTransparent:NO];
                            [BTN8 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 255) display:YES];
                        }ST->S = ST->S->next;
                        if(!ST->S) break;
                        if(ST->S) {
                            Slists->next = calloc(1, sizeof(SVALUE));
                            Slists = Slists->next;
                            *Slists = *ST->S;
                            
                            [BTN9 setTitle:ST->S->slct];
                            [BTN9 setTransparent:NO];
                            [BTN9 setEnabled:YES];
                            [trueSelectionDialog setFrame:NSMakeRect([NSScreen mainScreen].frame.size.width/2-200, [NSScreen mainScreen].frame.size.height/2, 400, 280) display:YES];
                        }ST->S = ST->S->next;
                        break;
                    }ST->S = STStop;
                    [trueSelectionDialog makeKeyAndOrderFront:nil];
                    
                    Slists = SlistsTop;
                    
                }
                
            }else if(dialogLengh != [text length]){//テキストが途中のとき
                dialogLengh = (int)[text length];
            }
        }
        
        if(dialogNumber > evDialogMax){
            evActive = false;
            evActiveEnd = true;
            evInitMap = true;
        }
    }
}

-(IBAction)selectionSubmit:(id)sender{
    
    if(ST->N)
    ST->N->value = [[NSString stringWithString:[selectionTF stringValue]] retain];
    
    namingFlag = false;
    [selectionDialog close];
}

-(IBAction)btn1:(id)sender{

    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
    
}
-(IBAction)btn2:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn3:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn4:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn5:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn6:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn7:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn8:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
-(IBAction)btn9:(id)sender{
    jumpName = [[NSString stringWithString:Slists->jump] retain];
    jumpFlag = true;
    selectionFlag = false;
    [trueSelectionDialog close];
}
@end
