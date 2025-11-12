import SwiftUI
import PhotosUI
import AVFoundation
import Speech

struct NoteEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var note: Note?

    @State private var title: String = ""
    @State private var body: String = ""
    @State private var tagsText: String = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem? = nil

    @StateObject private var recorder = AudioRecorder()
    @StateObject private var recognizer = SpeechRecognizer()

    init(note: Note? = nil) {
        self.note = note
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("标题", text: $title)
                    TextEditor(text: $body).frame(minHeight: 120)
                }
                Section(header: Text("图片")) {
                    if let img = image {
                        Image(uiImage: img).resizable().scaledToFit().frame(maxHeight:200)
                    }
                    HStack {
                        Button("从相册选图") { showImagePicker = true }
                        Spacer()
                        Button("清除") {
                            image = nil
                        }
                    }
                }
                Section(header: Text("标签（逗号分隔）")) {
                    TextField("工作,生活,学习", text: $tagsText)
                }
                Section(header: Text("语音记录")) {
                    if recorder.isRecording {
                        Button("停止录音") {
                            recorder.stopRecording()
                            Task {
                                if let url = recorder.lastFileURL {
                                    let text = await recognizer.recognize(url: url)
                                    if !text.isEmpty {
                                        body += (body.isEmpty ? "" : "\n") + text
                                    }
                                }
                            }
                        }
                    } else {
                        Button("开始录音") {
                            recorder.startRecording()
                        }
                    }
                }
            }
            .navigationTitle(note == nil ? "新建便签" : "编辑便签")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let ui = data.flatMap({ UIImage(data: $0) }) {
                        image = ui
                    }
                }
            }
            .onAppear {
                if let n = note {
                    title = n.title ?? ""
                    body = n.body ?? ""
                    tagsText = n.tagsCSV ?? ""
                    image = n.uiImage
                }
            }
        }
    }

    private func save() {
        let n = note ?? Note(context: viewContext)
        if n.id == nil { n.id = UUID() }
        n.title = title
        n.body = body
        n.setTags(tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
        if n.createdAt.timeIntervalSince1970 == 0 {
            n.createdAt = Date()
        }
        if let ui = image, let d = ui.jpegData(compressionQuality: 0.8) {
            n.imageData = d
        }
        do {
            try viewContext.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
