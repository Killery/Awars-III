//
//  StandView.m
//  Awars III
//
//  Created by Killery on 2013/11/07.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "StandView.h"

@implementation StandView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time  = [NSTimer
                  scheduledTimerWithTimeInterval:0.05f
                  target:self
                  selector:@selector(EventLoopSV:)
                  userInfo:nil
                  repeats:YES
                  ];
        
        testImage = [self LoadImage:@"ucb1"];
        
    }
    
    return self;
}
-(void)EventLoopSV:(NSTimer*)time{
    
    [self setNeedsDisplay:YES];
}


-(BOOL)isFlipped{
    return YES;
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    
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
    drRect.size.height = cy;
    drRect.size.width = cx;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f respectFlipped:YES hints:nil];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    startPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if(IBLrow < 0)
    if(I){
        I = Itop;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
        
        if(I->B){
            IBtop = I->B;
            for (int i = 0;i < IBrow;i++) {
                I->B = I->B->next;
            }
            
            if(I->B){
                imgGx = I->B->x;
                imgGy = I->B->y;
                
                if(I->B->L){
                    IBLtop = I->B->L;
                    
                    
                    I->B->L = IBLtop;
                }
            }
            I->B = IBtop;
        }
        I = Itop;
    }
    
    if(IBLrow >= 0)
        if(I){
            I = Itop;
            for (int i = 0;i < Irow;i++) {
                I = I->next;
            }
            
            if(I->B){
                IBtop = I->B;
                for (int i = 0;i < IBrow;i++) {
                    I->B = I->B->next;
                }
                
                if(I->B->L){
                    IBLtop = I->B->L;
                    for (int i = 0;i < IBLrow;i++) {
                        I->B->L = I->B->L->next;
                    }
                    
                    if(I->B->L){
                        imgGx = I->B->L->x;
                        imgGy = I->B->L->y;
                    }
                    I->B->L = IBLtop;
                }
                I->B = IBtop;
            }
            I = Itop;
        }
    
    startPoint.x = startPoint.x - imgGx;
    startPoint.y = startPoint.y - imgGy;
}


-(void)mouseDragged:(NSEvent *)theEvent{

    endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    imgGx = endPoint.x - startPoint.x;
    imgGy = endPoint.y - startPoint.y;
    
    if(IBLrow < 0)
    if(I){
        I = Itop;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
        
        if(I->B){
            IBtop = I->B;
            for (int i = 0;i < IBrow;i++) {
                I->B = I->B->next;
            }
            
            if(I->B){
                I->B->x = imgGx;
                I->B->y = imgGy;
                
                if(I->B->L){
                    IBLtop = I->B->L;
                    
                    
                    I->B->L = IBLtop;
                }
            }
            I->B = IBtop;
        }
        I = Itop;
    }

    if(IBLrow >= 0)
        if(I){
            I = Itop;
            for (int i = 0;i < Irow;i++) {
                I = I->next;
            }
            
            if(I)
            if(I->B){
                IBtop = I->B;
                for (int i = 0;i < IBrow;i++) {
                    I->B = I->B->next;
                }
                
                if(I)
                if(I->B->L){
                    IBLtop = I->B->L;
                    for (int i = 0;i < IBLrow;i++) {
                        I->B->L = I->B->L->next;
                    }
                    
                    if(I)
                    if(I->B->L){
                        I->B->L->x = imgGx;
                        I->B->L->y = imgGy;
                    }
                    I->B->L = IBLtop;
                }
                I->B = IBtop;
            }
            I = Itop;
        }
    
    
}

-(void)mouseUp:(NSEvent *)theEvent{
 
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    int layerIndex = 0;
    
    
    
    if(IBrow >= 0)
    if(I){
        while(layerIndex <= 999){
            Itop = I;
            for (int i = 0;i < Irow;i++) {
                I = I->next;
            }
            if(!I) return;
            if(I->B){
                IBtop = I->B;
                for (int i = 0;i < IBrow;i++) {
                    I->B = I->B->next;
                }
                
                if(I->B){
                    if(I->B->prefer == layerIndex)
                    [self DrawImage:I->B->img x:I->B->x y:I->B->y cx:I->B->img.size.width cy:I->B->img.size.height];
            
            
                    if(I->B->L){
                        IBLtop = I->B->L;
                        while (I->B->L) {
                            if(I->B->L && I->B->L->visible && I->B->L->prefer == layerIndex){
                                [self DrawImage:I->B->L->img x:I->B->L->x y:I->B->L->y cx:I->B->L->img.size.width cy:I->B->L->img.size.height];
                            }
                            I->B->L = I->B->L->next;
                        }
                
                        I->B->L = IBLtop;
                    }
                }
                I->B = IBtop;
            }
            I = Itop;
            layerIndex++;
        }
    }
}

@end
