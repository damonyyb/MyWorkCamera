//
//  CameraObject.m
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "CameraObject.h"

@implementation CameraObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uid forKey:@"UID"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_quality forKey:@"quality"];
    [aCoder encodeObject:_turnVideo forKey:@"turnVideo"];
    [aCoder encodeObject:_placeMode forKey:@"placeMode"];
    [aCoder encodeObject:_motionDetect forKey:@"motionDetect"];
    [aCoder encodeObject:_recordMode forKey:@"recordMode"];
    [aCoder encodeObject:_videoMode forKey:@"videoMode"];
    [aCoder encodeObject:_cameraVersion forKey:@"cameraVersion"];
    [aCoder encodeObject:_firm forKey:@"firm"];
    [aCoder encodeObject:_reduceRom forKey:@"reduceRom"];
    [aCoder encodeObject:_rom forKey:@"rom"];
    [aCoder encodeObject:_model forKey:@"model"];
    [aCoder encodeObject:_ssid forKey:@"ssid"];
    [aCoder encodeObject:_connectStatus forKey:@"connectStatus"];
    [aCoder encodeObject:_push forKey:@"push"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _uid = [aDecoder decodeObjectForKey:@"UID"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _quality = [aDecoder decodeObjectForKey:@"quality"];
        _turnVideo = [aDecoder decodeObjectForKey:@"turnVideo"];
        _placeMode = [aDecoder decodeObjectForKey:@"placeMode"];
        _motionDetect = [aDecoder decodeObjectForKey:@"motionDetect"];
        _recordMode = [aDecoder decodeObjectForKey:@"recordMode"];
        _videoMode = [aDecoder decodeObjectForKey:@"videoMode"];
        _cameraVersion = [aDecoder decodeObjectForKey:@"cameraVersion"];
        _firm = [aDecoder decodeObjectForKey:@"firm"];
        _reduceRom = [aDecoder decodeObjectForKey:@"reduceRom"];
        _rom = [aDecoder decodeObjectForKey:@"rom"];
        _model = [aDecoder decodeObjectForKey:@"model"];
        _ssid = [aDecoder decodeObjectForKey:@"ssid"];
        _connectStatus = [aDecoder decodeObjectForKey:@"connectStatus"];
        _push = [aDecoder decodeObjectForKey:@"push"];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uid = @"";
        self.password = @"";
        self.name = @"摄像头";
        self.quality = @0;
        self.turnVideo = @0;
        self.placeMode = @0;
        self.motionDetect = @0;
        self.recordMode = @0;
        self.videoMode = @"Camera";
        self.cameraVersion = @"";
        self.firm = @"";
        self.reduceRom = @0;
        self.rom = @0;
        self.model = @"";
        self.ssid = @"";
        self.connectStatus = @"0";
        self.tutkManager = [[TutkP2PAVClient alloc]init];
        self.push = @"0";
    }
    return self;
}

@end

/*
 
 @property (nonatomic,assign) int turnVideo;                 //画面翻转
 @property (nonatomic,assign) int placeMode;                 //环境模式
 @property (nonatomic,assign) BOOL motionDetect;             //移动侦测
 @property (nonatomic,assign) BOOL recordMode;               //录像模式
 
 
 @property (nonnull,nonatomic,copy) NSString *firm;          //厂商
 
 */