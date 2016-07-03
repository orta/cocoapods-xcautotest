/// The class that represents an XCAutoTest client.

@interface XCAutoTest: NSObject

/// As this needs to talk to global c-functions, this is the
/// best way to pass along a single instance.
+ (XCAutoTest *)sharedDriver;

/// Starts a runloop to continue execution until the server has closed,
/// or a developer does a `cmd + r` or `cmd + u`
- (void)startRunloop;

/// Starts up the Web Socket between the Auto Test server, and
/// this client.
- (void)connect;

@end
