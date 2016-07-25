proof of concept
using JS redux + hidden UIWebView (JavaScriptCore) + RxSwift

this project illustrate possibility to run "headless" javascript data layer and network operations
to drive a native iOS UI layer, this is to explore the possibility to have a cross-platform core, 
while keeping UI layer platform specific, RxSwift + RxDataSource is just there to simplify UITableView binding

# Build Instructions

## Build JS
```
npm i
npm build
```

## Build iOS
navigate to iosReduxAsync/
```
rake carthage
```
then open iosReduxAsync.xcodeproj in xcode

---
js part is from https://github.com/reactjs/redux/tree/master/examples/async with minimal modifications