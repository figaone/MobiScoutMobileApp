//
//  CustomObject.h
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/7/22.
//

#ifndef CustomObject_h
#define CustomObject_h


#endif /* CustomObject_h */
#import <Foundation/Foundation.h>

@class TestClassManager;
@interface CustomObject : NSObject


@property (strong, nonatomic) id someProperty;
@property (strong, nonatomic) id testLabel;
@property (strong, nonatomic) id adapterStatusLabel;
@property (strong, nonatomic) id rpmLabel;
@property (strong, nonatomic) id speedLabel;
@property (strong, nonatomic) id tempLabel;
@property (strong, nonatomic) id rssiLabel;
@property (strong, nonatomic) id vinLabel;
@property (strong, nonatomic) id fuelLabel;
@property (nonatomic) NSInteger totalCoins;


-(void)updateSensorData;
- (void) someMethod;
- (void)disconnect;
- (void)connect;
- (void)onConnectAdapterClicked;
- (void)onDisconnectAdapterClicked;
- (void) onStartup;


@end
