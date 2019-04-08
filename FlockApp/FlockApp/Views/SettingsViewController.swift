//
//  SettingsViewController.swift
//  
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit
import Firebase
import CoreLocation

class SettingsViewController: UIViewController {
    
    private var authservice = AppDelegate.authservice


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func menuPressed(_ sender: UIButton) {
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.present(menuVC, animated: true, completion: nil)
    }
    @IBAction func SignOutPressed(_ sender: UIButton) {
        authservice.signOutAccount()
        showLoginView()
    }
    
}
