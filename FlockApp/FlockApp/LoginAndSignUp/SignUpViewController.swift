//
//  SignUpViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceCreateNewAccountDelegate = self
        
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                print("missing fields") // TODO: add alert
                return
        }
        authservice.createNewAccount(username: username, email: email, password: password)
    }
    
    @IBAction func showLoginView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }


}

extension SignUpViewController: AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user userModel: UserModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! UIViewController
        homeViewController.modalTransitionStyle = .crossDissolve
        homeViewController.modalPresentationStyle = .overFullScreen
        present(homeViewController, animated: true)
    }
}
