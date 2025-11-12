# 今日灵感 (Today Inspiration) — Minimal SwiftUI Notes App

这个仓库是一个**最小可运行的 iOS SwiftUI 项目骨架**，特点：
- 轻量图文便签（title/body/image）
- 分类标签（tags，以逗号分隔储存）
- Core Data 本地存储 + 使用 `NSPersistentCloudKitContainer` 的 iCloud 同步（需要在 Xcode 中开启 iCloud/CloudKit 能力）
- 支持照片选择、录音与语音识别（将录音转文字）
- 适配深色模式
- 极简 UI，聚焦快速记录场景

**如何使用**
1. 在你的 macOS 上打开 Xcode，File → Open，选择 `TodayInspiration.xcodeproj`（本项目为最小化示例，已包含源代码）。
2. 进入 Xcode 项目后，请在 Signing & Capabilities 添加：
   - iCloud → CloudKit（以启用 iCloud 同步；需要 Apple Developer 帐号）
3. 在 `Info.plist` 中已包含必要的权限说明（相机/相册/麦克风/语音识别）。运行前请确保允许这些权限。
4. 运行到真机（录音与照片在模拟器上受限），或在模拟器里测试基本 UI。

**注意**
- 为了避免 .xcdatamodeld，我们在代码中以**运行时创建** Core Data 模型。因此，你不需要手动编辑数据模型文件。
- iCloud 同步需要在 Xcode 中为目标 app 打开 iCloud capability 并配置合适的 container。
- 这个示例旨在快速交付功能原型；在生产环境下请补充更完善的错误处理、UI/UX 和数据迁移策略。

