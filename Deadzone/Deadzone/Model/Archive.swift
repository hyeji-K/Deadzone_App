//
//  Archive.swift
//  Deadzone
//
//  Created by heyji on 2024/05/09.
//

import Foundation

struct Archive: Codable, Hashable {
    var id: String = UUID().uuidString
    var imageUrl: String
    var content: String
    var createdAt: String
    
    var toDictionary: [String: Any] {
        let archiveList: [String: Any] = ["id": id, "imageUrl": imageUrl, "content": content, "createdAt": createdAt]
        return archiveList
    }
}
