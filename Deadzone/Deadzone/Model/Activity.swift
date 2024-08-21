//
//  Activity.swift
//  Deadzone
//
//  Created by heyji on 2024/08/08.
//

import UIKit

struct ActivityList {
    let image: UIImage
    let title: String
}

extension ActivityList {
    static let list = [ActivityList(image: DZImage.music01, title: "음악"),
                       ActivityList(image: DZImage.cafe02, title: "카페"),
                       ActivityList(image: DZImage.meditation03, title: "명상"),
                       ActivityList(image: DZImage.reading04, title: "독서"),
                       ActivityList(image: DZImage.drinking05, title: "음주"),
                       ActivityList(image: DZImage.fashion06, title: "패션"),]
    
    func changeCatagotyName(name: String) -> String {
        switch name {
        case "음악":
            return "music"
        case "카페":
            return "cafe"
        case "명상":
            return "meditation"
        case "독서":
            return "reading"
        case "음주":
            return "drinking"
        case "패션":
            return "fashion01"
        default:
            return ""
        }
    }
}

struct ActivityReport: Codable {
    let cafe: Int
    let drinking: Int
    let meditation: Int
    let music: Int
    let reading: Int
    let fashion01: Int
    
    var toDictionary: [String: Any] {
        let activityReport: [String: Any] = ["cafe": cafe, "drinking": drinking, "meditation": meditation, "music": music, "reading": reading, "fashion01": fashion01]
        return activityReport
    }
}
