//
//  CustomObject.m
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/7/22.
//

#import <Foundation/Foundation.h>
#import "CustomObject.h"

#import <LTSupportAutomotive/LTSupportAutomotive.h>

#import <CoreBluetooth/CoreBluetooth.h>

typedef enum : NSUInteger {
    PageCurrentData,
    PageComponentMonitors,
    PageDTC,
} Page;

//static const CGFloat animationDuration = 0.15;


@implementation CustomObject
{
    LTBTLESerialTransporter* _transporter;
    LTOBD2Adapter* _obd2Adapter;

    NSArray<CBUUID*>* _serviceUUIDs;
    NSArray<LTOBD2PID*>* _pids;
    NSArray<LTOBD2MonitorResult*>* _monitors;
    NSArray<LTOBD2DTC*>* _dtcs;

    NSTimer* _timer;

    Page _selectedPage;

    LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01* _statusPID;
}

- (void) onStartup {
    NSMutableArray<CBUUID*>* ma = [NSMutableArray array];
    [@[ @"FFF0", @"FFE0", @"BEEF" , @"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"] enumerateObjectsUsingBlock:^(NSString* _Nonnull uuid, NSUInteger idx, BOOL * _Nonnull stop) {
        [ma addObject:[CBUUID UUIDWithString:uuid]];
    }];
    _serviceUUIDs = [NSArray arrayWithArray:ma];

//    UISegmentedControl* sc = [[UISegmentedControl alloc] initWithItems:@[ @"Current", @"Monitors", @"DTC" ]];
//    sc.selectedSegmentIndex = _selectedPage = 0;
//    [sc addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = sc;
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshClicked:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdapterChangedState:) name:LTOBD2AdapterDidUpdateState object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTransporterDidUpdateSignalStrength:) name:LTBTLESerialTransporterDidUpdateSignalStrength object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdapterDidSendBytes:) name:LTOBD2AdapterDidSend object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdapterDidReceiveBytes:) name:LTOBD2AdapterDidReceive object:nil];

    [self connect];
}

-(void)connect
{
    NSMutableArray<LTOBD2PID*>* ma = @[

                                       [LTOBD2CommandELM327_IDENTIFY command],
                                       [LTOBD2CommandELM327_IGNITION_STATUS command],
                                       [LTOBD2CommandELM327_READ_VOLTAGE command],
                                       [LTOBD2CommandELM327_DESCRIBE_PROTOCOL command],

                                       [LTOBD2PID_VIN_CODE_0902 pid],
                                       [LTOBD2PID_FUEL_SYSTEM_STATUS_03 pidForMode1],
                                       [LTOBD2PID_OBD_STANDARDS_1C pidForMode1],
                                       [LTOBD2PID_FUEL_TYPE_51 pidForMode1],

                                       [LTOBD2PID_ENGINE_LOAD_04 pidForMode1],
                                       [LTOBD2PID_COOLANT_TEMP_05 pidForMode1],
                                       [LTOBD2PID_SHORT_TERM_FUEL_TRIM_1_06 pidForMode1],
                                       [LTOBD2PID_LONG_TERM_FUEL_TRIM_1_07 pidForMode1],
                                       [LTOBD2PID_SHORT_TERM_FUEL_TRIM_2_08 pidForMode1],
                                       [LTOBD2PID_LONG_TERM_FUEL_TRIM_2_09 pidForMode1],
                                       [LTOBD2PID_FUEL_PRESSURE_0A pidForMode1],
                                       [LTOBD2PID_INTAKE_MAP_0B pidForMode1],

                                       [LTOBD2PID_ENGINE_RPM_0C pidForMode1],
                                       [LTOBD2PID_VEHICLE_SPEED_0D pidForMode1],
                                       [LTOBD2PID_TIMING_ADVANCE_0E pidForMode1],
                                       [LTOBD2PID_INTAKE_TEMP_0F pidForMode1],
                                       [LTOBD2PID_MAF_FLOW_10 pidForMode1],
                                       [LTOBD2PID_THROTTLE_11 pidForMode1],

                                       [LTOBD2PID_SECONDARY_AIR_STATUS_12 pidForMode1],
                                       [LTOBD2PID_OXYGEN_SENSORS_PRESENT_2_BANKS_13 pidForMode1],

                                       ].mutableCopy;
    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_1 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_OXYGEN_SENSORS_PRESENT_4_BANKS_1D pidForMode1],
                              [LTOBD2PID_AUX_INPUT_1E pidForMode1],
                              [LTOBD2PID_RUNTIME_1F pidForMode1],
                              [LTOBD2PID_DISTANCE_WITH_MIL_21 pidForMode1],
                              [LTOBD2PID_FUEL_RAIL_PRESSURE_22 pidForMode1],
                              [LTOBD2PID_FUEL_RAIL_GAUGE_PRESSURE_23 pidForMode1],
                              ]];

    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_2 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_COMMANDED_EGR_2C pidForMode1],
                              [LTOBD2PID_EGR_ERROR_2D pidForMode1],
                              [LTOBD2PID_COMMANDED_EVAPORATIVE_PURGE_2E pidForMode1],
                              [LTOBD2PID_FUEL_TANK_LEVEL_2F pidForMode1],
                              [LTOBD2PID_WARMUPS_SINCE_DTC_CLEARED_30 pidForMode1],
                              [LTOBD2PID_DISTANCE_SINCE_DTC_CLEARED_31 pidForMode1],
                              [LTOBD2PID_EVAP_SYS_VAPOR_PRESSURE_32 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_BAROMETRIC_PRESSURE_33 pidForMode1],
                              ]];

    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_3 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_CATALYST_TEMP_B1S1_3C pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B2S1_3D pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B1S2_3E pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B2S2_3F pidForMode1],
                              [LTOBD2PID_CONTROL_MODULE_VOLTAGE_42 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_ENGINE_LOAD_43 pidForMode1],
                              [LTOBD2PID_AIR_FUEL_EQUIV_RATIO_44 pidForMode1],
                              [LTOBD2PID_RELATIVE_THROTTLE_POS_45 pidForMode1],
                              [LTOBD2PID_AMBIENT_TEMP_46 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_THROTTLE_POS_B_47 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_THROTTLE_POS_C_48 pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_D_49 pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_E_4A pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_F_4B pidForMode1],
                              [LTOBD2PID_COMMANDED_THROTTLE_ACTUATOR_4C pidForMode1],
                              [LTOBD2PID_TIME_WITH_MIL_4D pidForMode1],
                              [LTOBD2PID_TIME_SINCE_DTC_CLEARED_4E pidForMode1],
                              [LTOBD2PID_MAX_VALUE_FUEL_AIR_EQUIVALENCE_RATIO_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_VOLTAGE_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_CURRENT_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_INTAKE_MAP_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_MAF_AIR_FLOW_RATE_50 pidForMode1],
                              ]];

    _pids = [NSArray arrayWithArray:ma];

    _adapterStatusLabel = @"Looking for adapter...";
    _rpmLabel = _speedLabel = _tempLabel = @"";
    _rssiLabel = @"";
//    _incomingBytesNotification.alpha = 0.3;
//    _outgoingBytesNotification.alpha = 0.3;

    _transporter = [LTBTLESerialTransporter transporterWithIdentifier:nil serviceUUIDs:_serviceUUIDs];
    [_transporter connectWithBlock:^(NSInputStream * _Nullable inputStream, NSOutputStream * _Nullable outputStream) {

        if ( !inputStream )
        {
            LOG( @"Could not connect to OBD2 adapter" );
            return;
        }

        self->_obd2Adapter = [LTOBD2AdapterELM327 adapterWithInputStream:inputStream outputStream:outputStream];
        [self->_obd2Adapter connect];
    }];

    [_transporter startUpdatingSignalStrengthWithInterval:1.0];
}

-(void)disconnect
{
    [_obd2Adapter disconnect];
    [_transporter disconnect];
}

-(void)onConnectAdapterClicked
{
    [self connect];
}

-(void)onDisconnectAdapterClicked
{
    [self disconnect];
}

#pragma mark -
#pragma mark NSTimer

-(void)updateSensorData
{
    LTOBD2PID_ENGINE_RPM_0C* rpm = [LTOBD2PID_ENGINE_RPM_0C pidForMode1];
    LTOBD2PID_VEHICLE_SPEED_0D* speed = [LTOBD2PID_VEHICLE_SPEED_0D pidForMode1];
    LTOBD2PID_COOLANT_TEMP_05* temp = [LTOBD2PID_COOLANT_TEMP_05 pidForMode1];
    
    LTOBD2PID_COOLANT_TEMP_05* coolantTemperature = [LTOBD2PID_COOLANT_TEMP_05 pidForMode1];
    LTOBD2PID_FUEL_TYPE_51* fuelType = [LTOBD2PID_FUEL_TYPE_51 pidForMode1];
    LTOBD2PID_VIN_CODE_0902* vincode = [LTOBD2PID_VIN_CODE_0902 pid];
    
//
//    LTOBD2PID_ENGINE_RPM_0C* fueltype = [LTOBD2PID_ENGINE_RPM_0C pidForMode1];
//    LTOBD2PID_VEHICLE_SPEED_0D* engineloa = [LTOBD2PID_VEHICLE_SPEED_0D pidForMode1];
//    LTOBD2PID_COOLANT_TEMP_05* throttle = [LTOBD2PID_COOLANT_TEMP_05 pidForMode1];
    

    [_obd2Adapter transmitMultipleCommands:@[ rpm, speed, temp , vincode, fuelType] completionHandler:^(NSArray<LTOBD2Command *> * _Nonnull commands) {

        dispatch_async( dispatch_get_main_queue(), ^{

            self->_rpmLabel = rpm.formattedResponse;
            self->_speedLabel = speed.formattedResponse;
            self->_tempLabel = temp.formattedResponse;
            self->_vinLabel = vincode.formattedResponse;
            self->_fuelLabel = fuelType.formattedResponse;
            

            NSLog(@"%@", rpm.formattedResponse);
            NSLog(@"%@", speed.formattedResponse);
            NSLog(@"%@", temp.formattedResponse);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateSensorData];
            });

        } );

    }];
}

#pragma mark -
#pragma mark NSNotificationCenter

-(void)onAdapterChangedState:(NSNotification*)notification
{
    dispatch_async( dispatch_get_main_queue(), ^{

        self->_adapterStatusLabel = self->_obd2Adapter.friendlyAdapterState;

        switch ( self->_obd2Adapter.adapterState )
        {
            case OBD2AdapterStateDiscovering: /* fallthrough intended */

            case OBD2AdapterStateConnected:
            {
                [self updateSensorData];
                break;
            }

            case OBD2AdapterStateGone:
            {

                self->_rpmLabel = self->_speedLabel = self->_tempLabel = @"";
                self->_rssiLabel = @"";
                break;
            }

            case OBD2AdapterStateUnsupportedProtocol:
            {
                NSString* message = [NSString stringWithFormat:@"Adapter ready, but vehicle uses an unsupported protocol – %@", self->_obd2Adapter.friendlyVehicleProtocol];
                self->_adapterStatusLabel = message;
                break;
            }

            default:
            {
                NSLog( @"Unhandeld adapter state %@", self->_obd2Adapter.friendlyAdapterState );
                break;
            }
        }

    } );
}





NSString *testString = @"test";
//_totalCoins2 = 10;

- (void) someMethod {
    NSLog(@"SomeMethod Ran");
    _testLabel = @"test";
//    NSLog(@"MyOb.someProperty: %ld", (long)TestClassManager.new.textTest);
//    int a;
//    for( a = 10; a < 20; a = a + 1 ) {
//        [NSThread sleepForTimeInterval:0.1];
////      NSLog(@"value of a: %d\n", a);
    
    _totalCoins ++;
    NSLog(@"value of a: %ld\n",(long)_totalCoins);
//    NSString* myNewString = [NSString stringWithFormat:@"%li", (long)_totalCoins];
//    TestClassManager.new.speedLabel.text = myNewString;

//    _totalCoins2 ++;
    NSLog(@"value of a: %ld\n",(long)_totalCoins);
}



- (void)getHour:(int *)hour minute:(int *)minute second:(int *)second {
    *hour = 1;
    *minute = 2;
    *second = 3;
}

@end
