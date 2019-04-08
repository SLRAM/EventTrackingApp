//
//  UIViewController+Navigation.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/8/19.
//

import UIKit

extension UIViewController {
    public func showLoginView() {
        if let _ = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? UIViewController {
            let loginViewStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
            if let loginViewController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
