//
//  Ask.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import Foundation

struct AskAndAnswer: Codable {
    let ask: String
    let askCreatedAt: String
    let answer: String
    let answerCreatedAt: String
    
    var toDictionary: [String: Any] {
        let askAndAnswer: [String: Any] = ["ask": ask, "askCreatedAt": askCreatedAt, "answer": answer, "answerCreatedAt": answerCreatedAt]
        return askAndAnswer
    }
}

struct Ask {
    let ask: String
    let date: String
}

struct Answer {
    let answer: String
    let date: String
}
