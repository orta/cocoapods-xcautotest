#import <Foundation/Foundation.h>

@protocol XCASocketDelegate <NSObject>

- (void)socketHasChangedConnected:(BOOL)connected;

@end

@interface XCASocketCommunicator : NSObject

/// Is the socket connected to a local Auto Test server?
@property BOOL connected;

/// Is the socket still connecting to the Auto Test server?
@property BOOL connecting;


@property (weak) id <XCASocketDelegate> delegate;

/// Starts the socket connection
- (void)connect;

@end

