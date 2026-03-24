import UIKit

class HapticManager {
    static let shared = HapticManager()

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    private init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        selection.prepare()
    }

    func colorPlaced() {
        lightImpact.impactOccurred()
    }

    func colorSelected() {
        selection.selectionChanged()
    }

    func regionCompleted() {
        mediumImpact.impactOccurred()
    }

    func artworkCompleted() {
        notification.notificationOccurred(.success)
    }

    func error() {
        notification.notificationOccurred(.error)
    }

    func buttonTap() {
        lightImpact.impactOccurred(intensity: 0.6)
    }
}
