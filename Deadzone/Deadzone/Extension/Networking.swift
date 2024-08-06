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
            
            // 신규 계정 생성 성공 시 - 키체인에 이메일과 비밀번호 저장
            guard let authEmail = authResult?.user.email else { return }
            KeyChain.shared.create(email: authEmail, password: password)
            completion(.success(authEmail))
        }
        
            // 토큰 받아오기
//            let currentUser = Auth.auth().currentUser
//            currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
//                if let error = error {
//                    return
//                }
//                print(idToken)
//            })
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
            guard let userID = authResult?.user.uid else { return }
            UserDefaults.standard.setValue(userID, forKey: "userId")
            // NOTE: 기기변경과 같은 예외상황일때 KeyChain 값 설정
            if KeyChain.shared.getUserData(email: email) == nil {
                KeyChain.shared.create(email: email, password: password)
            }
            completion(.success("성공"))
        }
    }
    
    // 사용자 재인증
    func isExistUser(completion: @escaping (String) -> Void) {
        var credential: AuthCredential
        guard let email = firebaseAuth.currentUser?.email else { return }
        guard let password = KeyChain.shared.getUserData(email: email) else { return }
        credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        firebaseAuth.currentUser?.reauthenticate(with: credential, completion: { result, error in
            if let error = error {
                // An error happened.
                print(error.localizedDescription)
                return
            }
            // User re-authenticated.
            if let user = result?.user.email {
                print(result?.user)
                print("재인증이 완료되었습니다.")
                completion(email)
            } else {
                print("재인증에 실패하였습니다.")
                return
            }
            
//            return true
        })
    }
    
    // MARK: 비밀번호 설정하기
    func setPassword(newPassword: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.isExistUser { email in
            // NOTE: 재인증 후 파이어베이스 비밀번호 업데이트
            self.firebaseAuth.currentUser?.updatePassword(to: newPassword, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                // NOTE: 키체인 비밀번호 업데이트
                // 기존 키체인 삭제 후 재등록
                KeyChain.shared.delete(email: email)
                KeyChain.shared.create(email: email, password: newPassword)
                completion(.success("비밀번호 변경에 성공하였습니다."))
            })
        }
        // 기존의 비밀번호 필요
//        var credential: AuthCredential
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
            UserDefaults.standard.removeObject(forKey: "userId")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: 사용자 계정 삭제하기 (탈퇴하기)
    func deleteAccount() {
        // NOTE: 탈퇴하는 사용자 uid와 날짜 저장
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let deleteUser = ["uid": uid, "deletedAt": Date().stringFormat]
        self.ref.child("RecentDeleteAccountUsers").child(UUID().uuidString).updateChildValues(deleteUser)
        // NOTE: 최근 로그인(로그인 후 5분)이 지나면 사용자 재인증 필요
        // 1. 사용자 재인증
        self.isExistUser { email in
            self.firebaseAuth.currentUser?.delete(completion: { error in
                if let error = error {
                    // An error happened.
                    print(error.localizedDescription)
                } else {
                    // NOTE: 키체인에 저장된 비밀번호 삭제 및 UserDefaults에 저장된 uid 삭제
                    KeyChain.shared.delete(email: email)
                    // 2. 사용자 정보 데이터 삭제
//                    self.deleteUserInfo()
                    // 3. 스토리지에 저장되어 있는 사진 데이터 삭제
//                    self.deleteArchiveData(firstArchiveName: <#T##String#>, secondArchiveName: <#T##String?#>)
                    // 4. 폰에 저장되어 있는 uid/email/pw 삭제
                    UserDefaults.standard.removeObject(forKey: "userId")
                    print(KeyChain.shared.getUserData(email: email) ?? "이메일 없음")
                }
            })
        }
    }
    
    // MARK: [Create, Post] 데이터 쓰기
    // 사용자 생성
    func createUserInfo(email: String) {
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
    
    // 사용자 활동 생성
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
    
    // 활동에 대한 요청
    func postNewActivityRequest(data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let request: [String: String] = ["request": data, "createdAt": Date().stringFormat]
        self.ref.child("Request").child(uid).child(UUID().uuidString).setValue(request)
    }
    
    // 1:1 문의 생성
    func postNewAsk(data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let ask: AskAndAnswer = AskAndAnswer(ask: data, askCreatedAt: Date().stringFormat, answer: "", answerCreatedAt: "")
        self.ref.child("Ask").child(uid).child(UUID().uuidString).setValue(ask.toDictionary)
    }
    
    // 회원탈퇴에 대한 이유
    func postLeaveReason(data: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let request: [String: String] = ["reason": data, "createdAt": Date().stringFormat]
        self.ref.child("LeaveReason").child(uid).child(UUID().uuidString).setValue(request)
    }
    
    enum UserInformation {
        case nickname
        case feeling
//        case reason // DB에 저장하지 않음
        case archiveName
    }
    
    // MARK: [Update] 데이터 업데이트
    // 사용자 정보 업데이트
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
                childUpdates = ["archive": [archive.first!]]
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
    
    // 활동에 대한 사진 업데이트
    func updateArchive(name: String, imageUrl: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let archive = Archive(imageUrl: imageUrl, content: "", createdAt: Date().stringFormat)
        let data = [archive.id: archive.toDictionary]
        self.ref.child("users").child(uid).child("Archive").child(name).updateChildValues(data)
    }
    
    // 활동에 올린 사진에 대한 글 업데이트
    func updateArchiveContent(name: String, archive: Archive, content: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let updateArchive = Archive(id: archive.id, imageUrl: archive.imageUrl, content: content, createdAt: archive.createdAt)
        let data = [archive.id: updateArchive.toDictionary]
        self.ref.child("users").child(uid).child("Archive").child(name).updateChildValues(data)
    }
    
    // MARK: [Read] 데이터 읽기
    // 사용자의 email 가져오기
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
    
    // 사용자 정보 가져오기
    func getUserInfo(completion: @escaping (User) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("userInfo").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let userInfo: User = try decoder.decode(User.self, from: data)
                    completion(userInfo)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 사용자의 활동 가져오기
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
    
    // 사용자의 활동에 대한 데이터 가져오기
    func getArchive(completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("Archive").observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    func getAsk(completion: @escaping ([AskAndAnswer]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("Ask").child(uid).getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    var askList: [AskAndAnswer] = []
                    for ask in snapshot.values {
                        let data = try JSONSerialization.data(withJSONObject: ask, options: [])
                        let decoder = JSONDecoder()
                        let userInfo: AskAndAnswer = try decoder.decode(AskAndAnswer.self, from: data)
                        askList.append(userInfo)
                    }
                    let sortedAskList = askList.sorted { $0.askCreatedAt < $1.askCreatedAt }
                    completion(sortedAskList)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
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
    // MARK: [Delete] 데이터 삭제
    // 사용자 데이터 삭제
    func deleteUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(uid).removeAllObservers()
        // 1. 스토리지에 저장되어 있는 사진 데이터 삭제
//        self.deleteArchiveData(firstArchiveName: <#T##String#>, secondArchiveName: <#T##String?#>)
        // 2. 사용자 정보 데이터 삭제
        // 3. 사용자 재인증 후 사용자 삭제
    }
    
    // 활동 삭제
    func deleteArchiveData(firstArchiveName: String, secondArchiveName: String? = nil) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(uid).child("Archive").child(firstArchiveName).removeValue()
        deleteImageAndData(storageName: firstArchiveName)
        
        guard let secondArchiveName else { return }
        self.ref.child("users").child(uid).child("Archive").child(secondArchiveName).removeValue()
        deleteImageAndData(storageName: secondArchiveName)
    }
    
    // 이미지 삭제
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
