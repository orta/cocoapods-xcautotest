#import "XCAutoTest.h"
#import "fishhook.h"
#import <dlfcn.h>

// Keep a reference to the origin exit function
static int (*orig_exit)(int);

static BOOL connectToAutoServer = YES;

// Our replacement Exit which starts looking to see if the server is active.
int xc_auto_exit(int code) {
#ifdef DEBUG

    /// Start up the server
    XCAutoTest *autoTest = [[XCAutoTest alloc] init];
    [autoTest connect];

    /// Keep this thread alive, until `connectToAutoServer` becomes `NO`
    [autoTest startRunloop];
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
    });
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
    
}

#endif
@end
