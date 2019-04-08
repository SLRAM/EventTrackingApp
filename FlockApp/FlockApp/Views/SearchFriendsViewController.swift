//
//  SearchFriendsViewController.swift
//  
//
//  Created by Nathalie  on 4/8/19.
//

import UIKit

class SearchFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.present(menuVC, animated: true, completion: nil)
    }
}
