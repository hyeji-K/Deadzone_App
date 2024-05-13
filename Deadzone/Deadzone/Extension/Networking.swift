//
//  Networking.swift
//  Deadzone
//
//  Created by heyji on 2024/04/08.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

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
    
    // MARK: 저장소
    private let storage = FirebaseStorage.Storage.storage().reference()
    
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
        let user = User(email: email, nickname: "", feeling: "", archive: [""], createdAt: Date().stringFormat)
        UserDefaults.standard.setValue(userID, forKey: "userId")
        self.ref.child("users").child(userID).child("userInfo").setValue(user.toDictionary)
    }
    
    enum Activity {
        case music
        case cafe
        case meditation
        case reading
        case drinking
        case fashion01
    }
    
    func createActivity(activityCount: Int, activitys: [String]) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        var room = MyRoom(music: false, drinking: false, meditation: false, table: false, cafe: false, reading: false, fashion01: false, fashion02: false)
        
        for activity in activitys {
            switch activity {
            case "음악":
                room.music = true
            case "카페":
                room.table = true
                room.cafe = true
            case "명상":
                room.meditation = true
            case "독서":
                room.table = true
                room.reading = true
            case "음주":
                room.drinking = true
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
    
    func postNewAsk(data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let request: [String: String] = ["ask": data, "createdAt": Date().stringFormat]
        self.ref.child("Ask").child(uid).child(UUID().uuidString).setValue(request)
    }
    
    enum UserInformation {
        case nickname
        case feeling
//        case reason // DB에 저장하지 않음
        case archiveName
    }
    
    func updateUserInfo(dataName: UserInformation, data: String, archive: [String]? = nil) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        switch dataName {
        case .nickname:
            let childUpdates = ["nickname": data]
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        case .feeling:
            let childUpdates = ["feeling": data]
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        case .archiveName:
            guard let archive = archive else { return }
            var childUpdates: [String: Any] = [:]
            if archive.count == 1 {
                childUpdates = ["archive": archive.first!]
            } else {
                childUpdates = ["archive": [archive.first!, archive.last!]]
            }
            ref.child("users").child(uid).child("userInfo").updateChildValues(childUpdates)
        }
    }
    
//    func postNewArchive(name: String) {
//        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
//        let dic: [String: String] = ["createdAt": Date().stringFormat]
//        self.ref.child("users").child(uid).child("Archive").child(name).setValue(dic)
//    }
    
    func updateArchive(name: String, imageUrl: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let archive = Archive(imageUrl: imageUrl, content: "", createdAt: Date().stringFormat)
        let data = [archive.id: archive.toDictionary]
        self.ref.child("users").child(uid).child("Archive").child(name).updateChildValues(data)
    }
    
    func updateArchiveContent(name: String, archive: Archive, content: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let updateArchive = Archive(id: archive.id, imageUrl: archive.imageUrl, content: content, createdAt: archive.createdAt)
        let data = [archive.id: updateArchive.toDictionary]
        self.ref.child("users").child(uid).child("Archive").child(name).updateChildValues(data)
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
    
    func getArchive(completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("Archive").observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    // MARK: 이미지 업로드
    func imageUpload(storageName: String, id: String, imageData: Data, completion: @escaping (String) -> Void) {
        // TODO: 활동에 따른 이미지 폴더 만들기
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let imageRef = self.storage.child(uid).child(storageName)
        let imageName = "\(id).jpg"
        let imagefileRef = imageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imagefileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("이미지 올리기 실패! \(error)")
            } else {
                imagefileRef.downloadURL { url, error in
                    if let error = error {
                        print("이미지 다운로드 실패! \(error)")
                    } else {
                        guard let url = url else { return }
                        completion("\(url)")
                    }
                }
            }
        }
    }
    
    // MARK: 데이터 삭제
    func deleteArchiveData(firstArchiveName: String, secondArchiveName: String? = nil) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(uid).child("Archive").child(firstArchiveName).removeValue()
        deleteImageAndData(storageName: firstArchiveName)
        
        guard let secondArchiveName else { return }
        self.ref.child("users").child(uid).child("Archive").child(secondArchiveName).removeValue()
        deleteImageAndData(storageName: secondArchiveName)
    }
    
    private func deleteImageAndData(storageName: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let imageRef = self.storage.child(uid).child(storageName)
        
        // 이미지가 있을 경우 전체 삭제
        imageRef.listAll(completion: { result, error in
            // NOTE: 파일 전체 삭제 안됨 > 파일 이름을 입력하여 하나하나 삭제해야함
            if let error = error {
                print(error)
            }
            guard let result = result else { return }
            if result.items.count > 0 {
                imageRef.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
//            for item in result.items {
//                if item.name == imageName {
//                    imageRef.child(imageName).delete { error in
//                        if let error = error {
//                            print(error)
//                        } else {
//                            print("삭제되었습니다.")
//                        }
//                    }
//                }
//            }
        })
    }
}
