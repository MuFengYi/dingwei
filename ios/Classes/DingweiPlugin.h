#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>
@interface DingweiPlugin : NSObject<FlutterPlugin,FlutterStreamHandler,CLLocationManagerDelegate>
@property (nonatomic, strong) FlutterEventSink eventSink;


@property (nonatomic, strong) CLLocationManager *locationManager;



@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
