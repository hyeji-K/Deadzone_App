//
//  MyRoom.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import Foundation

struct MyRoom: Codable {
    var cdplayer: Bool
    var wasted: Bool
    var meditation: Bool
    var table: Bool
    var iceCoffee: Bool
    var reading: Bool
    var fashion01: Bool
    var fashion02: Bool
    
    var toDictionary: [String: Any] {
        let myRoom: [String: Any] = ["cdplayer": cdplayer, "wasted": wasted, "meditation": meditation, "table": table, "iceCoffee": iceCoffee, "reading": reading, "fashion01": fashion01, "fashion02": fashion02]
        return myRoom
    }
}
