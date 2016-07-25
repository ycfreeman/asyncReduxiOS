Proof of Concept
using JS redux + hidden UIWebView (JavaScriptCore) + RxSwift

this project illustrate possibility to run "headless" javascript data layer and network operations
to drive a native iOS UI layer, this is to explore the possibility to have a cross-platform core, 
while keeping UI layer native so we can use native stuff like StoryBoard among other good things

RxSwift + RxDataSource is just there to simplify UITableView binding

using hidden UIWebView as oppose to true headless JSContext is for easier debugging and XMLHTTPRequest abilities

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
js part is from https://github.com/reactjs/redux/tree/master/examples/async with only little modifications to index.js and webpack.config.js

---
TODO: need to use true headless JSContext? performance test needed