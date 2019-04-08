//
//  MenuViewController.swift
//  FlockApp
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func homeButton(_ sender: UIButton) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        present(homeVC, animated: true, completion: nil)
    }
    @IBAction func myEventButton(_ sender: UIButton) {
        let myEventVC = self.storyboard?.instantiateViewController(withIdentifier: "UserEventsViewController") as! UserEventsViewController
       present(myEventVC, animated: true, completion: nil)
    }
    @IBAction func friendsButton(_ sender: UIButton) {
        let friendsVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        present(friendsVC, animated: true, completion: nil)
    }
    @IBAction func profileButton(_ sender: UIButton) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        present(profileVC, animated: true, completion: nil)
    }
    @IBAction func settingsButton(_ sender: UIButton) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        present(settingsVC, animated: true, completion: nil)
    }
    @IBAction func searchButton(_ sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchFriendsViewController") as! SearchFriendsViewController
        present(searchVC, animated: true, completion: nil)
    }
    

    @IBAction func signOutButton(_ sender: UIButton) {
    }
}
