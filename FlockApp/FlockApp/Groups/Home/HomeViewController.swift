//
//  HomeViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore


class HomeViewController: UIViewController {
    
    let color = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
    var homeView = HomeView()
    var currentDate = Date.getISOTimestamp()
    var newUser = false
    private var pendingEventListener: ListenerRegistration!
    private var acceptedEventListener: ListenerRegistration!
    private var authService = AppDelegate.authservice
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        homeView.usersCollectionView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchEvents), for: .valueChanged)
        return rc
    }()
    
    var pendingEvents = [Event]()
    var acceptedEvents = [Event]()

    var tag = 0
    
    var filteredAcceptedEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
                
            }
        }
    }
    
    var filteredPastEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
            }
        }
    }
    
    
    var filteredPendingEvents  = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.homeView.usersCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = color
        self.navigationController?.navigationBar.barTintColor = color

        view.addSubview(homeView)
//        view.addShadow()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9568627451, blue: 0.9764705882, alpha: 1)
        fetchEvents()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateEditEvent))
        title = "Home"
        homeView.segmentedControl.selectedSegmentIndex = 0

        homeView.delegate = self

        homeView.dateLabel.text = currentDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        homeView.dayLabel.text = currentDate.formatISODateString(dateFormat: "EEEE")
        
        homeView.segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        
        indexChanged(homeView.segmentedControl)

    }
    func acceptEventPressed(eventCell: Event) {
        guard let user = authService.getCurrentUser() else {
            print("no logged user")
            return
        }
        DBService.postAcceptedEventToUser(user: user, event: eventCell, completion: { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Posting Event To Accepted Error", message: error.localizedDescription)
            } else {
                print("posted to accepted list")
                
                DBService.deleteEventFromPending(user: user, event: eventCell, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Deleting Event from Pending Error", message: error.localizedDescription)
                    } else {
                        print("Deleted Event from Pending list")
                        
                        let index = self?.filteredPendingEvents.firstIndex { $0.documentId == eventCell.documentId }
                        if let foundIndex = index {
                            self?.filteredPendingEvents.remove(at: foundIndex)
                        }
                        
                        //self?.homeView.usersCollectionView.reloadData()
                    }
                })
            }
        })
        homeView.usersCollectionView.reloadData()

    }
    
    
    @objc func showCreateEditEvent() {
        
        let optionMenu = UIAlertController(title: nil, message: "Create:", preferredStyle: .actionSheet)
        let  eventAction = UIAlertAction(title: "Event", style: .default, handler: { (action) -> Void in
            let createEditVC = CreateEditViewController()
            let createNav = UINavigationController.init(rootViewController: createEditVC)
            self.present(createNav, animated: true)
        })
        let  quickEventAction = UIAlertAction(title: "Quick Event", style: .default, handler: { (action) -> Void in
            
            let quickEditVC = QuickEventViewController()
            let createNav = UINavigationController.init(rootViewController: quickEditVC)
            self.present(createNav, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(eventAction)
        optionMenu.addAction(quickEventAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)

  
    }
  
    
    @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("Current Events")
            tag = 0

            homeView.delegate?.segmentedEventsPressed()

        case 1:
            print("Past Event")
            tag = 1

            homeView.delegate?.segmentedPastEventPressed()

        case 2:
            print("Join Event")
            tag = 2

            homeView.delegate?.pendingJoinEventPressed()

    
            
        default:
            break
        }
    }

    @objc func fetchEvents(){
        
        guard let user = authService.getCurrentUser() else {
            print("no logged user")
            return
        }
        
        refreshControl.beginRefreshing()
        pendingEventListener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.EventPendingKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    
                    self?.pendingEvents = snapshot.documents.map{Event(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
        
        
        acceptedEventListener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.EventAcceptedKey)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch events with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot{
                    
                    
                    self?.acceptedEvents = snapshot.documents.map{Event(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date()}
                    
                }
                DispatchQueue.main.async {
                    self!.homeView.delegate?.segmentedEventsPressed()
                    self!.homeView.usersCollectionView.dataSource = self
                    self!.homeView.usersCollectionView.delegate = self
                    self?.refreshControl.endRefreshing()
                }
            })
    }
    
 
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch tag {
        case 0:
            return filteredAcceptedEvents.count
            
        case 1:
            return filteredPastEvents.count

        case 2:
            return filteredPendingEvents.count

        default:
            return 0
        }
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventHomeCollectionViewCell", for: indexPath) as? EventHomeCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        
        collectionViewCell.contentView.layer.masksToBounds = true
        collectionViewCell.backgroundColor = .clear // very important
        collectionViewCell.layer.masksToBounds = false
        collectionViewCell.layer.shadowOpacity = 0.25
        collectionViewCell.layer.shadowRadius = 10
        collectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
        collectionViewCell.layer.shadowColor = UIColor.black.cgColor
        
        let radius = collectionViewCell.contentView.layer.cornerRadius
        collectionViewCell.layer.shadowPath = UIBezierPath(roundedRect: collectionViewCell.bounds, cornerRadius: radius).cgPath

        
        var eventToSet = Event()
        
        switch tag {
        case 0:
            eventToSet = filteredAcceptedEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = true
            collectionViewCell.goingButton.isHidden = true
            collectionViewCell.declineButton.isHidden = true
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            collectionViewCell.eventImage.alpha = 0.8
            

            
        case 1:
            eventToSet = filteredPastEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = true
            collectionViewCell.goingButton.isHidden = true
            collectionViewCell.declineButton.isHidden = true
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            collectionViewCell.eventImage.alpha = 0.8
            
        

            
        case 2:
            eventToSet = filteredPendingEvents[indexPath.row]
            collectionViewCell.joinEventButton.isHidden = false
            collectionViewCell.joinEventButton.isEnabled = true
            //collectionViewCell.joinEventButton.alpha = 1
            //collectionViewCell.joinEventButton.layer.cornerRadius = 50
            collectionViewCell.goingButton.isHidden = false
            collectionViewCell.declineButton.isHidden = false
            collectionViewCell.eventLabel.isHidden = false
            collectionViewCell.startDateLabel.isHidden = false
            
            
        default:
            print("you good fam?")
        }
        
        collectionViewCell.delegate = self
        collectionViewCell.goingButton.tag = indexPath.row
        collectionViewCell.declineButton.tag = indexPath.row
        collectionViewCell.eventLabel.text = eventToSet.eventName
        

    
        let startDate = eventToSet.startDate
        collectionViewCell.startDateLabel.text = startDate
        collectionViewCell.startDateLabel.text = eventToSet.startDate.formatISODateString(dateFormat: "MMM d, h:mm a")
        collectionViewCell.eventImage.kf.setImage(with: URL(string: eventToSet.imageURL ?? "no image available"), placeholder: #imageLiteral(resourceName: "pitons"))
        
        return collectionViewCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //when a user clicks on the cell's button call acceptEventPressed
        let detailVC = EventTableViewController()
        var event = Event()

        switch tag {
        case 0:
            event = filteredAcceptedEvents[indexPath.row]
            detailVC.tag = 0
            
            
        case 1:
            event = filteredPastEvents[indexPath.row]
            detailVC.tag = 1
            
            
        case 2:
            event = filteredPendingEvents[indexPath.row]
            detailVC.tag = 2
            
        default:
            print("you good fam")
        }
        detailVC.event = event
        let detailNav = UINavigationController.init(rootViewController: detailVC)
        
        present(detailNav, animated: true)
    }
    
}


extension HomeViewController: UserEventCollectionViewDelegate {
    
    func segmentedEventsPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        //this should be events that you've accepted
        filteredAcceptedEvents =  acceptedEvents.filter {
            $0.endDate.date() > currentDate
        }
    }
    
    func segmentedPastEventPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        filteredPastEvents =  acceptedEvents.filter {
            $0.endDate.date() < currentDate
        }
    }
    
    func pendingJoinEventPressed() {
        let formatter = ISO8601DateFormatter()
        guard let currentDate = formatter.date(from: self.currentDate) else { return }
        filteredPendingEvents =  pendingEvents.filter {
            $0.endDate.date() > currentDate
        }
    }
    
  
    
    
    
}
extension HomeViewController: EventHomeCollectionViewCellDelegate {
    func declinePressed(tag: Int) {
        print(tag)
        let event = filteredPendingEvents[tag]
        acceptEventPressed(eventCell: event)
    }

    func acceptedPressed(tag: Int) {
        print(tag)
        let event = filteredPendingEvents[tag]
        acceptEventPressed(eventCell: event)
    }



}
