//
//  User.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import Foundation

struct User {
    //이메일, 비밀번호, 활성화상태, 닉네임, 생성일, 수정일, 감정, 이유
    var email: String
    var password: String
    var nickname: String
    var feeling: String
    var reason: String
    var activate: Bool
    var createdAt: String
    var updatedAt: String
}
