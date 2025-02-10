//
//  TutorialManager.swift
//  Deadzone
//
//  Created by heyji on 1/16/25.
//

import Foundation

final class TutorialManager {
    private let userDefaults = UserDefaults.standard
    private let tutorialKey = "tutorialShown"
    
    var isTutorialNeeded: Bool {
        !userDefaults.bool(forKey: tutorialKey)
    }
    
    func markTutorialAsShown() {
        userDefaults.set(true, forKey: tutorialKey)
    }
    
    // 튜토리얼 리셋 메소드
    func resetTutorial() {
        userDefaults.set(false, forKey: tutorialKey)
    }
}
