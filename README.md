# BeesKingLib

[![CI Status](https://img.shields.io/travis/s18782934812/BeesKingLib.svg?style=flat)](https://travis-ci.org/s18782934812/BeesKingLib)
[![Version](https://img.shields.io/cocoapods/v/BeesKingLib.svg?style=flat)](https://cocoapods.org/pods/BeesKingLib)
[![License](https://img.shields.io/cocoapods/l/BeesKingLib.svg?style=flat)](https://cocoapods.org/pods/BeesKingLib)
[![Platform](https://img.shields.io/cocoapods/p/BeesKingLib.svg?style=flat)](https://cocoapods.org/pods/BeesKingLib)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BeesKingLib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BeesKingLib'
```

## Author

    WJ, 836152122@qq.com
    TY, ktonyreet@gmail.com

## License

    BeesKingLib is available under the MIT license. See the LICENSE file for more info.

## Remark

### 
    1.BKCategory
    主要是常用的分类， BKSafeCategory用于字典、数组安全处理，其中NSMutableArray 编译为MRC模式。
    NSObject+BKCatchException:用于异常捕获，可以在有exception的地方调用里面的方法
    UIControl+BKFixMultiClick:用于UIControl及子类的防止重复点击
    NSObject+BKUnicode:此文件用于打印的时候，将文字转成--utf8输出,无需import
    
    2.BKMediator
    中间组件，目前是用的CTMediator代码
    
    3.BKLargeImage
    大图处理，避免加载大图的时候老机型崩溃的问题
    4.BKNetWork
    基于AFNetworking 二次封装的网络请求库，使用的话，可对BKBaseRequest进行继承扩展
