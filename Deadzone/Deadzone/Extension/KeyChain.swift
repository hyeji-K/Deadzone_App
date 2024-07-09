//
//  KeyChain.swift
//  Deadzone
//
//  Created by heyji on 2024/05/16.
//

import Foundation
import Security

final class KeyChain {
    static let shared = KeyChain()
    private init() { }
    
    func create(email: String, password: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email,
            kSecValueData: password.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)    // Keychain은 Key값에 중복이 생기면, 저장할 수 없기 때문에 먼저 Delete해줌
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }
    
    func getUserData(email: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email,
            kSecReturnData: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne       // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    func delete(email: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
