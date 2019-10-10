//
//  LoginViewController.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/29.
//  Copyright © 2019 Jun Takahashi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var twitterProvider : OAuthProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Twitterの認証用プロバイダー
        self.twitterProvider = OAuthProvider(providerID:"twitter.com");
    }
    
    @IBAction func twitterAuthButton(_ sender: Any) {

        
        self.twitterProvider?.getCredentialWith(_: nil) { credential, error in
            if error != nil {
                // Handle error.
                print("error")
            }

            if let credential = credential {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let _error = error {
                        self.signInErrAlert(_error)
                    } else {
                        self.presentTaskList()
                    }
                    // User is signed in.
                    // IdP data available in authResult.additionalUserInfo.profile.
                    // Twitter OAuth access token can also be retrieved by:
                    // authResult.credential.accessToken
                    // Twitter OAuth ID token can be retrieved by calling:
                    // authResult.credential.idToken
                    // Twitter OAuth secret can be retrieved by calling:
                    // authResult.credential.secret
                }
            }
        }
    }
    
    @IBAction func signUpTappedBtn(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passTextField.text else { return }
        if email.isEmpty {
            self.singleAlert(title: "エラー", message: "メールアドレスを入力して下さい")
            return
        }
        if password.isEmpty {
            self.singleAlert(title: "エラー", message: "パスワードを入力して下さい")
            return
        }
        self.emailSignUp(email: email, password: password)
    }
    
    @IBAction func signInTappedBtn(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passTextField.text else { return }
        if email.isEmpty {
            self.singleAlert(title: "エラー", message: "メールアドレスを入力して下さい")
            return
        }
        if password.isEmpty {
            self.singleAlert(title: "エラー", message: "パスワードを入力して下さい")
            return
        }
        self.emailSignIn(email: email, password: password)
    }
    
    func emailSignUp (email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _error = error {
                self.signUpErrAlert(_error)
            } else {
                self.presentTaskList()
            }
        }
    }
    
    func emailSignIn (email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _error = error {
                self.signInErrAlert(_error)
            } else {
                self.presentTaskList()
            }
        }
    }
    
    func signUpErrAlert(_ error: Error){
        if let errCode = AuthErrorCode(rawValue: error._code) {
            var message = ""
            switch errCode {
            case .invalidEmail:      message =  "有効なメールアドレスを入力してください"
            case .emailAlreadyInUse: message = "既に登録されているメールアドレスです"
            case .weakPassword:      message = "パスワードは６文字以上で入力してください"
            default:                 message = "エラー: \(error.localizedDescription)"
            }
            self.singleAlert(title: "登録できません", message: message)
        }
    }
    
    func signInErrAlert(_ error: Error){
        if let errCode = AuthErrorCode(rawValue: error._code) {
            var message = ""
            switch errCode {
            case .userNotFound:  message = "アカウントが見つかりませんでした"
            case .wrongPassword: message = "パスワードを確認してください"
            case .userDisabled:  message = "アカウントが無効になっています"
            case .invalidEmail:  message = "Eメールが無効な形式です"
            default:             message = "エラー: \(error.localizedDescription)"
            }
            self.singleAlert(title: "ログインできません", message: message)
        }
    }
    
    @IBAction func termsTappedBtn(_ sender: Any) {
        if let termsVC = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") {
            self.present(termsVC, animated: true, completion: nil)
        }
    }
    
    func presentTaskList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let taskNavi = storyboard.instantiateViewController(withIdentifier: "TaskNavigationController")
        self.present(taskNavi, animated: true, completion: nil)
    }

}
