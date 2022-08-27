//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 홍성범 on 2022/08/27.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach { item in
            item?.layer.borderWidth = 1
            item?.layer.borderColor = UIColor.white.cgColor
            item?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
    }
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
        if let error = error {
            print("ERROR", error.localizedDescription)
            return
        }

        guard let authentication = user?.authentication,
        let idToken = authentication.idToken else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first?.rootViewController
        window?.show(mainViewController, sender: nil)
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증
    }
}

