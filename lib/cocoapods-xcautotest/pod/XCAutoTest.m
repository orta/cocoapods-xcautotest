#import "XCAutoTest.h"
#import "XCASocketCommunicator.h"

#import "fishhook.h"
#import <dlfcn.h>

@interface XCAutoTest() <XCASocketDelegate>
@property (strong) XCASocketCommunicator *socket;
@end


// Keep a reference to the origin exit function
static int (*orig_exit)(int);

static BOOL connectToAutoServer = YES;

// Our replacement Exit which starts looking to see if the server is active.
int xc_auto_exit(int code) {
#ifdef DEBUG

    /// Start up the server
    XCAutoTest *autoTest = [XCAutoTest sharedDriver];
    if (autoTest.socket.connecting || autoTest.socket.connected) {
        /// Keep this thread alive, until `connectToAutoServer` becomes `NO`
        [autoTest startRunloop];
    } else {
        /// Pass straight on by
        orig_exit(code);
    }
#endif
}

@implementation XCAutoTest
#ifdef DEBUG

/// As the class heirarchy is being set up, in DEBUG mode, hook in our testing infrastructure

+ (void)load
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        // Re-bind the `exit` function to a custom c-function we control.
        //
        // XCTest calls `exit` when it has finished working, as otherwise the app would continue 
        // to run indefinitely. Thus in re-binding we can halt the closing of the test runner. 
        rebind_symbols((struct rebinding[1]){{"exit", xc_auto_exit, (void *)&orig_exit}}, 1);

        /// Setup the shared driver.
        [self sharedDriver];
    });
}

+ (XCAutoTest *)sharedDriver
{
    static XCAutoTest *_sharedController = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedController = [[XCAutoTest alloc] init];

        /// Wait until the app is ready to go before starting to work with
        /// any of the web socket work, just feels better than doing it in here.
        [[NSNotificationCenter defaultCenter] addObserver:_sharedController
                                                  selector:@selector(connect)
                                                      name:UIApplicationDidBecomeActiveNotification object:nil];

    });

    return _sharedController;
}


- (void)startRunloop 
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    while (connectToAutoServer && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // Pass through to the original exit function 
    orig_exit(1);
}

- (void)connect
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.socket = [[XCASocketCommunicator alloc] init];
    self.socket.delegate = self;
    [self.socket connect];
}

- (void)socketHasChangedConnected:(BOOL)connected
{
    connectToAutoServer = connected;
}

#endif
@end
