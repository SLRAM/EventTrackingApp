//
//  LoginViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        authservice.authserviceExistingAccountDelegate = self
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }

}

extension LoginViewController: AuthServiceExistingAccountDelegate {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Signin Error", message: error.localizedDescription)
    }
    
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! UIViewController
        homeViewController.modalTransitionStyle = .crossDissolve
        homeViewController.modalPresentationStyle = .overFullScreen
        present(homeViewController, animated: true)
    }
}
