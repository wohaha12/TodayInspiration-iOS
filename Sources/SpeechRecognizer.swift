import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechRecognizer: ObservableObject {
    private let recognizer = SFSpeechRecognizer()
    func recognize(url: URL) async -> String {
        let req = SFSpeechURLRecognitionRequest(url: url)
        do {
            let res = try await recognizer?.recognitionTask(with: req) { _, _ in } // placeholder
            // The modern SFSpeechRecognizer does not have async API before iOS 16 in this simplified demo.
        } catch {
            print("Recognition error: \(error)")
        }

        // For simplicity in this demo, use legacy synchronous pattern
        let semaphore = DispatchSemaphore(value: 0)
        var finalText = ""
        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer?.recognitionTask(with: request) { result, error in
            if let r = result, r.isFinal {
                finalText = r.bestTranscription.formattedString
            }
            if error != nil || (result?.isFinal ?? false) {
                semaphore.signal()
            }
        }
        _ = semaphore.wait(timeout: .now() + 15)
        return finalText
    }
}
