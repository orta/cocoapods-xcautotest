#import "XCASocketCommunicator.h"
@import WebKit;

@interface XCASocketCommunicator()
@property (strong) WKWebView *headlessWebView;
@end

@implementation XCASocketCommunicator

- (void)connect
{
    self.connecting = true;

    /// So, we don't want to be adding a lot of dependencies, but a lot of the work
    /// involved in writing Auto Test is about the communication between client and server.
    NSString *path = [[NSBundle bundleForClass:XCASocketCommunicator.class] pathForResource:@"xcautotest_server" ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    /// By using a WKWebView, we can use their web-socket to sanely connect to a web socket
    /// generated by the command-line tool. This reduces overhead, but also can avoid
    /// issues with:
    ///     XPC's private iOS API usage,
    ///     Raw Socket's hard to follow code,
    ///     and REST's ability to bypass ATS.
    /// Credit goes to Mike Lazer-Walker for this one, was not an idea I would have come to.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];

    [controller addScriptMessageHandler:self name:@"host"];
    configuration.userContentController = controller;

    self.headlessWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) configuration:configuration];
    [self.headlessWebView evaluateJavaScript:javascript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) { NSLog(@"Error in parsing script:\n%@", error.localizedDescription); }
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    self.connecting = false;

    BOOL connected = [message.body[@"connected"] boolValue];
    if (self.connected != connected) {
        [self.delegate socketHasChangedConnected:connected];
    }

    self.connected = connected;
}

@end
