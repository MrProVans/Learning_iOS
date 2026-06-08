import AudioToolbox
import Combine
import UIKit

final class AppFeedbackManager: ObservableObject {
    static let shared = AppFeedbackManager()

    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: hapticsKey) }
    }

    @Published var soundEffectsEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEffectsEnabled, forKey: soundsKey) }
    }

    private let hapticsKey = "haptics_enabled"
    private let soundsKey = "sound_effects_enabled"

    private init() {
        hapticsEnabled = UserDefaults.standard.object(forKey: hapticsKey) as? Bool ?? true
        soundEffectsEnabled = UserDefaults.standard.object(forKey: soundsKey) as? Bool ?? true
    }

    func tap() {
        impact(.light)
        playSystemSound(1104)
    }

    func success() {
        notification(.success)
        playSystemSound(1057)
    }

    func warning() {
        notification(.warning)
        playSystemSound(1103)
    }

    func error() {
        notification(.error)
        playSystemSound(1006)
    }

    func selectionChanged() {
        guard hapticsEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    private func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard hapticsEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    private func playSystemSound(_ id: SystemSoundID) {
        guard soundEffectsEnabled else { return }
        AudioServicesPlaySystemSound(id)
    }
}
