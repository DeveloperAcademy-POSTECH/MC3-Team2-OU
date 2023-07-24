//
//  HapticsManager.swift
//  SeaYa
//
//  Created by xnoag on 2023/07/17.
//

import Foundation
import UIKit

fileprivate final class HapticsManager {
    static let shared = HapticsManager()
    private let feedback = UINotificationFeedbackGenerator()
    private init() {}
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}

func haptics(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    HapticsManager.shared.trigger(notification)
}
