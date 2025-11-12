import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("enableCloudSync") var enableCloudSync: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("同步")) {
                    Toggle(isOn: $enableCloudSync) {
                        VStack(alignment: .leading) {
                            Text("iCloud 同步")
                            Text("启用后将使用 iCloud (CloudKit) 同步便签数据").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("关于")) {
                    Text("应用：今日灵感").font(.body)
                    Text("版本：1.0").font(.caption)
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}
