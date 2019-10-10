//
//  User.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/29.
//  Copyright © 2019 Jun Takahashi. All rights reserved.
//

import Foundation
import Firebase

// 授業では全てLoginVCに書いていきましたが
// DelegateやSingleton等を使ってこんな感じの実装もできます
// FirebaseAuthを色々なな場所でインポートしないでできます

//protocol UserDelegate: class {
//    func didSignUp(error: Error?)
//    func didSignIn(error: Error?)
//}
//
//class User {
//    // シングルトン実装
//    static let shared = User()
//
//    weak var delegate: UserDelegate?
//
//    private init(){}
//
//    var user: FirebaseAuth.User? {
//        get {
//            return Auth.auth().currentUser
//        }
//    }
//
//    func emailSignUp (email: String, password: String){
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            self.delegate?.didSignUp(error: error)
//        }
//    }
//
//    func emailSignIn (email: String, password: String){
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            self.delegate?.didSignIn(error: error)
//        }
//    }
//
//    func logout() {
//        try! Auth.auth().signOut()
//    }
//
//    func isLogin() -> Bool{
//        if user != nil {
//            return true
//        }
//        return false
//    }
//}

