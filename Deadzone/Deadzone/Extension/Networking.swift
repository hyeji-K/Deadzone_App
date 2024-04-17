//
//  Networking.swift
//  Deadzone
//
//  Created by heyji on 2024/04/08.
//

import Foundation
import FirebaseAuth

enum NetworkError: Error {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
}

final class Networking {
    
    static let shared = Networking()
    
    private let firebaseAuth = Auth.auth()
    private var credential: AuthCredential?
    
    private init() { }
    
    // MARK: 신규 사용자가 새 계정을 만드는 회원가입 진행
    func createUser(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                switch error {
                case AuthErrorCode.invalidEmail:
                    print("이메일 형식이 잘못되었습니다.")
                    completion(.failure(NetworkError.invalidEmail))
                    return
                case AuthErrorCode.emailAlreadyInUse:
                    print("이미 사용중인 이메일입니다.")
                    completion(.failure(NetworkError.emailAlreadyInUse))
                    return
                case AuthErrorCode.weakPassword:
                    print("암호는 6글자 이상이어야 합니다.")
                    completion(.failure(NetworkError.weakPassword))
                    return
                default:
                    print(error.localizedDescription)
                    return
                }
            }
            
            // 신규 계정 생성 성공 시
//            print(authResult?.additionalUserInfo?.description)
            completion(.success("성공"))
        }
    }
    
    // MARK: 이메일 주소와 비밀번호로 사용자 로그인
    func signInApp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            // 로그인 성공 시
            guard let strongSelf = self else { return }
            completion(.success("성공"))
        }
    }
    
    func isExistUser(email: String) {
        
    }
    
    // MARK: 비밀번호 설정하기
    func setPassword(password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 기존의 비밀번호 필요
//        credential = EmailAuthProvider.credential(withEmail: firebaseAuth.currentUser?.email, password: <#T##String#>)
//        firebaseAuth.currentUser?.reauthenticate(with: credential, completion: { result, error in
//            if let error = error {
//                return
//            }
//        })
        firebaseAuth.currentUser?.updatePassword(to: password) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            completion(.success("성공"))
        }
    }
    
    // MARK: 로그아웃
    func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: 사용자 계정 삭제하기 (탈퇴하기)
    func deleteUser() {
        firebaseAuth.currentUser?.delete(completion: { error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        })
    }
}
