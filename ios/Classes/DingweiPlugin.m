#import "DingweiPlugin.h"
@implementation DingweiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"dingwei"
            binaryMessenger:[registrar messenger]];
  DingweiPlugin* instance = [[DingweiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];


  






  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"qy/eventChannel" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance]; //设置事件处理
}




- (void)initLocationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        
        [_locationManager startUpdatingLocation];
    }
}






- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"纬度=======%f,经度=========%f",latitude,longitude);
    _coordinate = CLLocationCoordinate2DMake(latitude, longitude);

    if(_eventSink){
        _eventSink(@{@"eventid":@"0",@"data":@[@(latitude),@(longitude)]});
    }
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    [self initLocationManager];
    return nil;
}


- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.eventSink = nil;
    return nil;
}

@end
