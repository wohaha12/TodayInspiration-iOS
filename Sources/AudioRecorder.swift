import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    private var recorder: AVAudioRecorder?
    @Published var isRecording = false
    var lastFileURL: URL?

    func startRecording() {
        let fm = FileManager.default
        let dir = fm.temporaryDirectory
        let url = dir.appendingPathComponent("inspiration_\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1
        ]
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            isRecording = true
            lastFileURL = url
        } catch {
            print("Record error: \(error)")
        }
    }

    func stopRecording() {
        recorder?.stop()
        isRecording = false
    }
}
