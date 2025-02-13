//
//  MyRoom.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import Foundation

struct MyRoom: Codable {
    var music: Bool
    var drinking: Bool
    var meditation: Bool
    var table: Bool
    var cafe: Bool
    var reading: Bool
    var fashion01: Bool
    var fashion02: Bool
    
    var toDictionary: [String: Any] {
        let myRoom: [String: Any] = ["music": music, "drinking": drinking, "meditation": meditation, "table": table, "cafe": cafe, "reading": reading, "fashion01": fashion01, "fashion02": fashion02]
        return myRoom
    }
}

enum ActivityType: String, CaseIterable {
    case music
    case drinking
    case meditation
    case table
    case cafe
    case reading
    case fashion01
    case fashion02
    
    var koreanTitle: String {
        switch self {
        case .music: return "음악"
        case .drinking: return "음주"
        case .meditation: return "명상"
        case .cafe: return "카페"
        case .reading: return "독서"
        case .fashion01: return "패션"
        default:
            return ""
        }
    }
    
    var englishTitle: String {
        return self.rawValue
    }
    
    // 한글 타이틀로부터 ActivityType 생성
    static func from(koreanTitle: String) -> ActivityType? {
        switch koreanTitle {
        case "음악": return .music
        case "음주": return .drinking
        case "명상": return .meditation
        case "카페": return .cafe
        case "독서": return .reading
        case "패션": return .fashion01
        default: return nil
        }
    }
}

// 번역을 위한 struct
struct ActivityTranslator {
    static func toEnglish(_ koreanTitle: String) -> String {
        return ActivityType.from(koreanTitle: koreanTitle)?.englishTitle ?? koreanTitle
    }
    
    static func toKorean(_ englishTitle: String) -> String {
        return ActivityType(rawValue: englishTitle)?.koreanTitle ?? englishTitle
    }
}
