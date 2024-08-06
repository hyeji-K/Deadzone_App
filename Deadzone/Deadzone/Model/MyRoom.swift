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
