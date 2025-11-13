# 今日灵感 (TodayInspiration) — Minimal SwiftUI Notes App
这个项目是一个基于 SwiftUI 的 iOS 便签应用（今日灵感），主要功能包括创建、编辑、删除便签，支持添加图片、标签和语音转文字输入，还提供了 iCloud 同步选项。以下是其实现方式的详细说明：
1. 项目结构
项目采用模块化组织，核心文件分布如下：
界面相关：ContentView（主界面）、NoteEditorView（编辑界面）、NoteRowView（便签列表项）、SettingsView（设置界面）
数据模型：Note+CoreDataClass.swift（CoreData 实体类）
数据持久化：PersistenceController.swift（CoreData 配置）
功能模块：AudioRecorder.swift（录音）、SpeechRecognizer.swift（语音识别）
配置文件：Info.plist（权限配置）、codemagic.yaml（CI 构建配置）
2. 核心功能实现
（1）数据模型与持久化
数据模型：通过 Note 类定义便签属性，包括标题（title）、内容（body）、标签（tagsCSV，以逗号分隔的字符串存储）、创建时间（createdAt）、图片数据（imageData）等。
CoreData 配置：PersistenceController 负责初始化 CoreData 容器，支持本地存储和 iCloud 同步（通过 enableCloudSync 开关控制）：
本地存储使用 SQLite 数据库。
iCloud 同步启用时，配置 NSPersistentCloudKitContainer 并开启历史追踪。
（2）主界面（ContentView）
功能：展示便签列表、标签筛选、跳转编辑页和设置页。
实现：
使用 @FetchRequest 从 CoreData 获取便签数据，按创建时间倒序排列。
顶部水平滚动的标签栏，通过 allTags() 提取所有标签并去重，点击标签可筛选对应便签（filteredNotes()）。
列表项通过 NoteRowView 展示，支持左滑删除（onDelete）。
（3）便签编辑（NoteEditorView）
功能：创建 / 编辑便签，支持输入标题、内容、标签，添加图片，语音转文字。
实现：
图片选择：通过 PhotosPicker 从相册选取图片，转换为 UIImage 后存储为二进制数据（imageData）。
标签处理：输入框按逗号分隔标签，保存时通过 setTags() 转换为字符串存储。
语音转文字：
用 AudioRecorder 录制音频（存储为临时文件）。
调用 SpeechRecognizer 将音频文件转为文字，追加到内容中（body）。
（4）iCloud 同步
开关控制：在 SettingsView 中通过 @AppStorage("enableCloudSync") 存储用户是否启用同步的偏好。
动态配置：PersistenceController 初始化时读取 enableCloudSync 状态，动态切换本地存储或 CloudKit 容器。
（5）权限管理
Info.plist 中声明了必要的权限：
相册访问（NSPhotoLibraryUsageDescription）
相机使用（NSCameraUsageDescription）
麦克风使用（NSMicrophoneUsageDescription）
语音识别（NSSpeechRecognitionUsageDescription）
3. 构建与部署
本地构建：通过 Xcode 打开 TodayInspiration.xcodeproj 直接运行。
CI 构建：配置 codemagic.yaml，使用 Codemagic 自动构建，禁用签名（CODE_SIGNING_REQUIRED=NO），输出 .app 或 .ipa 用于测试。
总结
该项目基于 SwiftUI + CoreData 实现，通过模块化设计分离界面、数据和功能逻辑，支持本地存储与 iCloud 同步，提供了便捷的便签管理和多媒体输入功能，整体结构清晰，易于扩展。

说明：
- 这个仓库是一个可直接用于 Codemagic 构建的最小 iOS SwiftUI 项目。
- iCloud 同步为可选，默认关闭。可在应用内设置打开（仅在设备和已配置的 iCloud 环境下生效）。
- 在 Codemagic 上构建时不需要证书（CODE_SIGNING_REQUIRED=NO），你可以下载 .app/.ipa 作为构建产物用于测试（真机需签名）。

构建：
- 使用 Codemagic（已包含 `codemagic.yaml`），或在 Xcode 中打开 `TodayInspiration.xcodeproj` 并运行。
