### Testing can get harder to do as you get grow. 

This project aims to address that flaw, by using the Objective-C runtime in your favour. It's inspired by the idea that code can be injected at runtime, and you can iterate significantly faster inside your application.

### v1.0.0

Version one should be able to have a command line app, that would compile new tests as they are saved and run them into the long-running `XCTest` runner.

### v2.0.0

Version two should build off the infrastructure that Facebook has been building [around multi-sim](https://github.com/facebook/FBSimulatorControl#fbsimulatorcontrol). This means that the server can run it's own headless simulator. So you can constantly have tests running when they're saved.

## v3.0.0

Version three should ideally look at being able to inject application changes as well as testing changes. 

Until now, there is an assumption that you are only changing your test suite, but real-world usage is that you would also want to trigger related tests when you press save on any source file.

This would effectively mean replicating all of Injection for Xcode, and is not something I'd take lightly.

## Notes

Ideally at some point, we can move this off the CocoaPods Plugin infrastructure. This infrastructure is in place so that we can execute code on both the host OS, and the sim.

Injection for Xcode works around this problem by being an Xcode plugin. I'm not sure that's tenable on the long term. So this project will always be looking for ways in which we can work around this. [Smuggler](https://github.com/johnno1962/Smuggler) looks the most feasible alternative.
