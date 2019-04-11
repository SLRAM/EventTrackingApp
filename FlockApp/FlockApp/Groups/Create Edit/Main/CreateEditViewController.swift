//
//  CreateEditViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase

class CreateEditViewController: UIViewController {
    
    private let createEditView = CreateEditView()
    let titlePlaceholder = "Enter the event title"

    
    var friendsArray = [UserModel]()
    var selectedLocation = String()
    var selectedCoordinates = CLLocationCoordinate2D()
    var selectedStartDate = Date()
    var selectedEndDate = Date()
    
    private var authservice = AppDelegate.authservice

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(createEditView)
        createEditView.titleTextView.delegate = self
        createEditView.delegate = self
        createEditView.myTableView.dataSource = self
        createEditView.myTableView.delegate = self
        navigationItem.rightBarButtonItem = createEditView.createButton
        navigationItem.leftBarButtonItem = createEditView.cancelButton
    }
    override func viewDidAppear(_ animated: Bool) {
    }
}
extension CreateEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        createEditView.titleTextView.becomeFirstResponder()
        if createEditView.titleTextView.text == self.titlePlaceholder {
            createEditView.titleTextView.text = ""
            createEditView.titleTextView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        createEditView.titleTextView.resignFirstResponder()
    }
}
extension CreateEditViewController: CreateViewDelegate {
    func cancelPressed() {
        dismiss(animated: true)
    }
    
    func friendsPressed() {
        print("friends pressed")
        let detailVC = FriendsViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func trackingPressed() {
        print("tracking pressed")
    }
    
    func datePressed() {
        print("date pressed")

        let detailVC = DateViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func addressPressed() {
        let detailVC = LocationSearchViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func createPressed() {
        if createEditView.addressButton.titleLabel?.text == "Event Address" {
            let alertController = UIAlertController(title: "Unable to post. Choose a location.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return}
        guard let user = authservice.getCurrentUser() else {
            let alertController = UIAlertController(title: "Unable to post. Please login to post.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return}

        let docRef = DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document()
        
        guard let eventName = createEditView.titleTextView.text else {return}
        var friendIds = [String]()
        for friends in friendsArray {
            friendIds.append(friends.userId)
        }
        let event = Event(eventName: eventName, createdDate: Date.getISOTimestamp(), userID: user.uid, imageURL: nil, eventDescription: "Event Description", documentId: docRef.documentID, startDate: selectedStartDate, endDate: selectedEndDate, locationString: selectedLocation, locationLat: selectedCoordinates.latitude, locationLong: selectedCoordinates.longitude, invited: friendIds)
        
        
        DBService.postEvent(event: event, completion: { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Posting Event Error", message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Event Posted", message: nil) { action in
//                    self?.dismiss(animated: true)//code here to segue to detail
                    let detailVC = EventViewController()
//                    detailVC.delegate = self
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        })
    }
}

extension CreateEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let friend = friendsArray[indexPath.row]
        cell.textLabel?.text = friend.displayName
        return cell
    }
    
    
}

extension CreateEditViewController: LocationSearchViewControllerDelegate {
    func getLocation(locationTuple: (String, CLLocationCoordinate2D)) {
            print("tuple printout of string: \(locationTuple.0)")
            print("tuple printout of coordinates: \(locationTuple.1)")
            createEditView.addressButton.setTitle(locationTuple.0, for: .normal)
            createEditView.addressButton.titleLabel?.text = locationTuple.0
        selectedLocation = locationTuple.0
        selectedCoordinates = locationTuple.1
    }
}
extension CreateEditViewController: FriendsViewControllerDelegate {
    func selectedFriends(friends: [UserModel]) {
        print("Friends selected")
        friendsArray = friends
        createEditView.myTableView.reloadData()
    }
    
    
}
extension CreateEditViewController: DateViewControllerDelegate {
    func selectedDate(startDate: Date, endDate: Date) {
        selectedStartDate = startDate
        selectedEndDate = endDate

    }

}
