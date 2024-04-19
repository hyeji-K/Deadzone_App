//
//  Networking.swift
//  Deadzone
//
//  Created by heyji on 2024/04/08.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum NetworkError: Error {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
}

final class Networking {
    
    static let shared = Networking()
    
    // MARK: 인증
    private let firebaseAuth = Auth.auth()
    private var credential: AuthCredential?
    
    // MARK: 실시간 데이터베이스
    private var ref: DatabaseReference! = Database.database().reference()
    
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
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                if let error = error {
                    return
                }
                print(idToken)
            })
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
        var credential: AuthCredential
//        credential = EmailAuthProvider.credential(withEmail: (firebaseAuth.currentUser?.email)!, password: <#T##String#>)
//        firebaseAuth.currentUser?.reauthenticate(with: credential, completion: { result, error in
//            if let error = error {
//                return
//            } else {
//                self.firebaseAuth.currentUser?.updatePassword(to: password) { error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        completion(.failure(error))
//                        return
//                    }
//                    completion(.success("성공"))
//                }
//            }
//        })
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
    
    // MARK: 데이터 쓰기
    func createUser(email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = User(email: email, nickname: "", feeling: "", reason: "", createdAt: Date().stringFormat)
        UserDefaults.standard.setValue(userID, forKey: "userId")
        self.ref.child("users").child(userID).child("userInfo").setValue(user.toDictionary)
    }
    
    enum Activity {
        case music
        case cafe
        case meditation
        case reading
        case drinking
        case fashion
    }
    
    func createActivity(activityCount: Int, activitys: [String]) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        var room = MyRoom(cdplayer: false, wasted: false, meditation: false, table: false, iceCoffee: false, reading: false, fashion01: false, fashion02: false)
        
        for activity in activitys {
            switch activity {
            case "음악":
                room.cdplayer = true
            case "카페":
                room.table = true
                room.iceCoffee = true
            case "명상":
                room.meditation = true
            case "독서":
                room.table = true
                room.reading = true
            case "음주":
                room.wasted = true
            case "패션":
                room.fashion01 = true
                room.fashion02 = true
            default:
                return
            }            
        }
        
        self.ref.child("users").child(uid).child("myRoom").setValue(room.toDictionary)
    }
    
    func postNewActivityRequest(data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let request: [String: String] = ["request": data, "createdAt": Date().stringFormat]
        self.ref.child("Request").child(uid).child(UUID().uuidString).setValue(request)
    }
    
    enum UserInformation {
        case nickname
        case feeling
        case reason
    }
    
    func updateUserInfo(dataName: UserInformation, data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        switch dataName {
        case .nickname:
            let childUpdates = ["nickname": data]
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        case .feeling:
            let childUpdates = ["feeling": data]
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        case .reason:
            let childUpdates = ["reason": data]
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        }
    }
    
    // MARK: 데이터 읽기
    func getUserEmail(completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("userInfo").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            completion(snapshot)
        }
    }
    
    func getUserInfo(completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("userInfo").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            completion(snapshot)
        }
    }
    
    func getActivity(completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("myRoom").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            completion(snapshot)
        }
    }
}
