# 今日灵感 (TodayInspiration) — Minimal SwiftUI Notes App

说明：
- 这个仓库是一个可直接用于 Codemagic 构建的最小 iOS SwiftUI 项目。
- iCloud 同步为可选，默认关闭。可在应用内设置打开（仅在设备和已配置的 iCloud 环境下生效）。
- 在 Codemagic 上构建时不需要证书（CODE_SIGNING_REQUIRED=NO），你可以下载 .app/.ipa 作为构建产物用于测试（真机需签名）。

构建：
- 使用 Codemagic（已包含 `codemagic.yaml`），或在 Xcode 中打开 `TodayInspiration.xcodeproj` 并运行。
