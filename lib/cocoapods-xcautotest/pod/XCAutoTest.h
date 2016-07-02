/// The class that represents an XCAutoTest client.

@interface XCAutoTest

/// Starts a runloop to continue execution until the server has closed,
/// or a developer does a `cmd + r` or `cmd + u`
- (void)startRunloop;

/// Starts up the Web Socket between the Auto Test server, and
/// this client.
- (void)connect;
@end
