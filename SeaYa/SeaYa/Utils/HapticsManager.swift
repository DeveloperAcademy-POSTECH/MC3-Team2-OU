//
//  HapticsManager.swift
//  SeaYa
//
//  Created by xnoag on 2023/07/17.
//

import Foundation
import UIKit
import SwiftUI

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

class HapticManager {
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
