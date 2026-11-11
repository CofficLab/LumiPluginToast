# LumiPluginToast

📖 [中文版](README_zh.md) | [English](README.md)

`LumiPluginToast` 是 Lumi 系列应用共享的 Toast 实现。它把 `ProviderToast`
契约转化为可在 macOS 与 iOS 上工作的可复用 UI 插件。

## 能力

- 替换式 Toast 展示，时长可配置；
- 自动消失，默认三秒；
- 通过 `ProviderRootView` 挂载到顶层根覆盖层；
- 持久错误通知，支持滚动、文本选择、复制与显式关闭操作；
- 通过 `ProviderDocsView` 注册可选的文档/关于页；
- LumiUI 主题、动效、间距与状态横幅集成；
- 包本地化以英文为先，回退到 LumiLocalization。

插件保持与任何应用专属根布局解耦。如果宿主未注册 `RootViewProviding`，
它仍会收到可用的 `ToastProviding` 实现；只是跳过了自动 UI 挂载。

## 用法

添加包，并在宿主的插件工厂中注册 `ToastSuperPlugin`：

```swift
.package(url: "https://github.com/lumi-softworks/LumiPluginToast.git", from: "1.0.0")
```

```swift
import PluginToast

ToastSuperPlugin()
```

应用插件应依赖 `ProviderToast`，而不是这个 UI 插件。这样它们可以通过
provider 契约调用 `show`、`presentError` 与 `dismissError`，而无需与
渲染器耦合。

## Development

```sh
swift test
```
