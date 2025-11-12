import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechRecognizer: ObservableObject {
    private let recognizer = SFSpeechRecognizer()

    func recognize(url: URL) async -> String {
        let request = SFSpeechURLRecognitionRequest(url: url)
        var finalText = ""
        let sem = DispatchSemaphore(value: 0)
        recognizer?.recognitionTask(with: request) { res, err in
            if let r = res, r.isFinal {
                finalText = r.bestTranscription.formattedString
            }
            if err != nil || (res?.isFinal ?? false) {
                sem.signal()
            }
        }
        _ = sem.wait(timeout: .now() + 20)
        return finalText
    }
}
