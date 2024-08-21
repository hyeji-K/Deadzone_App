//
//  User.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import Foundation

struct User: Codable {
    //이메일, 비밀번호, 활성화상태, 닉네임, 생성일, 수정일, 감정, 이유
    var id: String = UUID().uuidString
    var email: String
    var nickname: String
    var feeling: String
//    var reason: String
    var archive: [String]
    var activate: Bool = true
    var createdAt: String
    var updatedAt: String = Date().stringFormat
    
    var toDictionary: [String: Any] {
        let user: [String: Any] = ["id": id, "email": email, "nickname": nickname, "feeling": feeling, "archive": archive, "activate": activate, "createdAt": createdAt, "updatedAt": updatedAt]
        return user
    }
}
