//
//  HomeViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit


class HomeViewController: BaseViewController {
    
    var homeView = HomeView()
    var cellView = EventHomeCollectionViewCell()
    var dummyEvent = "This is a test event"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flock"
        view.addSubview(homeView)
        view.backgroundColor = #colorLiteral(red: 0.995991528, green: 0.9961341023, blue: 0.9959602952, alpha: 1)
        homeView.collectionView.dataSource = self
        homeView.createButton.addTarget(self, action: #selector(showCreateEditEvent), for: .touchUpInside)
        homeView.joinButton.addTarget(self, action: #selector(showJoinEvent), for: .touchUpInside)
        
    
    }
    
    @objc func showCreateEditEvent() {
        let createEditVC = CreateEditViewController()
        let createNav = UINavigationController.init(rootViewController: createEditVC)
        present(createNav, animated: true) 
    }
    @objc func showJoinEvent(){
        let joinVC = EventDetailsViewController()
        present (joinVC, animated: true)
        print("whaddup")
    }
 
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
        }
       _ = [indexPath.row]
        //collectionViewCell.backgroundColor = #colorLiteral(red: 0.755648911, green: 0.06676873565, blue: 0.9596711993, alpha: 1)
        collectionViewCell.backgroundView = UIImageView(image: UIImage(named: "pitons"))
        collectionViewCell.layer.cornerRadius = 15
        return collectionViewCell
    }
    
    
}
