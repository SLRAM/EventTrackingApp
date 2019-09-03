//
//  CreateEditTableViewController.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 9/2/19.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase
import Toucan
import UserNotifications
import Kingfisher


class CreateEditTableViewController: UITableViewController {

    
    let cellId = "EventCell"
    
    
    let createEditTableView = CreateEditTableView()
    
    public var event: Event?
    public var tag: Int?
    
    
    
    
    let titlePlaceholder = "Enter the Event Title"
    let trackingPlaceholder = "Event Tracking Time"
    var number = 0
    
    var friendsArray = [UserModel]()
    var friendsDictionary : Dictionary<Int,String> = [:]
    var selectedLocation = String()
    var selectedCoordinates = CLLocationCoordinate2D()
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var trackingTime = 0
    var isTextField = false
    private var authservice = AppDelegate.authservice
    
    private var selectedImage: UIImage?
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9665842652, green: 0.9562553763, blue: 0.9781278968, alpha: 1)
        navigationItem.leftBarButtonItem = createEditTableView.cancelButton
//        self.title = event?.eventName
        let frameHeight = view.frame.height
        let frameSection = view.frame.height/3
        self.tableView.sectionHeaderHeight = frameHeight - frameSection
        self.tableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: "personCell")
        
        
        selectedImage = createEditTableView.imageButton.imageView?.image
        viewSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotifications()
        
    }
    deinit {
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc private func willShowKeyboard(notification: Notification) {
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("userInfo is nil")
                return
        }
        if isTextField {
            // this needs to change for tableview ***
            tableView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    @objc private func willHideKeyboard(notification: Notification) {
        //identity will return to original location
        // this needs to change for tableview ***

        tableView.transform = CGAffineTransform.identity
    }
    
    func viewSetup() {
        navigationItem.title = "Create Event"
        navigationItem.rightBarButtonItem = createEditTableView.createButton
        navigationItem.leftBarButtonItem = createEditTableView.cancelButton
        createEditTableView.titleTextView.delegate = self
        createEditTableView.delegate = self
//        createEditView.myTableView.dataSource = self
//        createEditView.myTableView.delegate = self
        
    }
    
    func editNumber(increase: Bool)-> String {
        if number != 0 && increase == false{
            number -= 1
            
        } else if increase == true {
            number += 1
        }
        if number == 1{
            return "\(number) hour before event"
            
        } else if number == 0{
            return trackingPlaceholder
        } else {
            return "\(number) hours before event"
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1).withAlphaComponent(0.2)
        tableView.deselectRow(at: indexPath, animated: false)
    }


    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createEditTableView
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? EventPeopleTableViewCell else {return UITableViewCell()}
        let person = friendsArray[indexPath.row]
        cell.layer.cornerRadius = 50
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.profilePicture.kf.setImage(with: URL(string: person.photoURL ?? "no photo"), placeholder: #imageLiteral(resourceName: "ProfileImage.png"))
        cell.nameLabel.text = person.displayName
        cell.taskField.tag = indexPath.row
        cell.taskField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            return cell
        }
        @objc func didChangeText(textField:UITextField) {
            //        print(textField.tag)
            //        print(textField.text)
            //for id key save text
            guard let typedText = textField.text else {
                print("unable to obtain task")
                return
                
            }
            for (key, value) in friendsDictionary {
                
                if textField.tag == key {
                    friendsDictionary[key] = typedText
                    
                }
            }
            
        }
    
}
extension CreateEditTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        createEditTableView.titleTextView.becomeFirstResponder()
        print("textView")
        isTextField = false
        if createEditTableView.titleTextView.text == self.titlePlaceholder {
            createEditTableView.titleTextView.text = ""
            createEditTableView.titleTextView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextField = false
        if textView.text.isEmpty {
            textView.text = titlePlaceholder
            textView.textColor = .gray
        }
        createEditTableView.titleTextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
extension CreateEditTableViewController: CreateEditTableViewDelegate {
    func trackingDecreasePressed() {
        let trackingLabel = editNumber(increase: false)
        createEditTableView.myLabel.text = trackingLabel
        trackingTime -= 1
        
    }
    
    func trackingIncreasePressed() {
        print("tracking increase pressed")
        
        let trackingLabel = editNumber(increase: true)
        createEditTableView.myLabel.text = trackingLabel
        trackingTime += 1
    }
    
    
    func imagePressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [unowned self] (action) in
            
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] (action) in
            
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        present(alertController, animated: true)
        
    }
    
    func cancelPressed() {
        dismiss(animated: true)
    }
    
    func friendsPressed() {
        print("friends pressed")
        let detailVC = InvitedViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
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
        createEditTableView.createButton.isEnabled = false
        
        
        if createEditTableView.titleTextView.text == titlePlaceholder || createEditTableView.titleTextView.text.isEmpty {
            let alertController = UIAlertController(title: "Unable to post. Please title your event.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.createEditTableView.createButton.isEnabled = true
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return}
        if createEditTableView.addressButton.titleLabel?.text == "Event Address" {
            let alertController = UIAlertController(title: "Unable to post. Choose a location.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.createEditTableView.createButton.isEnabled = true
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return}
        
        
        guard let startDate = self.selectedStartDate else {
            let alertController = UIAlertController(title: "Unable to post. Choose an event date.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.createEditTableView.createButton.isEnabled = true
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return}
        guard let endDate = self.selectedEndDate else {return}
        
        
        let eventLength = trackingTime*(-60)
        let trackingDate = startDate.adding(minutes: eventLength)
        
        let isoDateFormatter = ISO8601DateFormatter()
        let startTrackingString = isoDateFormatter.string(from: trackingDate)
        
        
        
        let startDateString = ISO8601DateFormatter().string(from: startDate)
        let endDateString = ISO8601DateFormatter().string(from: endDate)
        
        guard let eventName = createEditTableView.titleTextView.text else {return}
        var friendIds = [String]()
        for friends in friendsArray {
            friendIds.append(friends.userId)
        }
        
        guard let user = authservice.getCurrentUser() else {
            let alertController = UIAlertController(title: "Unable to post. Please login to post.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return}
        
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
            let alertController = UIAlertController(title: "Unable to post. Please fill in the required fields.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return}
        
        
        let docRef = DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document()
        StorageService.postImage(imageData: imageData, imageName: Constants.EventImagePath + "\(user.uid)/\(docRef.documentID)") { [weak self] (error, imageURL) in
            if let error = error {
                print("failed to post image with error: \(error.localizedDescription)")
            } else if let imageURL = imageURL {
                print("image posted and recieved imageURL - post blog to database: \(imageURL)")
                let event = Event(eventName: eventName,
                                  createdDate: Date.getISOTimestamp(),
                                  userID: user.uid,
                                  imageURL: imageURL.absoluteString,
                                  eventDescription: "Event Description",
                                  documentId: docRef.documentID,
                                  startDate: startDateString,
                                  endDate: endDateString,
                                  locationString: self!.selectedLocation,
                                  locationLat: self!.selectedCoordinates.latitude,
                                  locationLong: self!.selectedCoordinates.longitude,
                                  trackingTime: startTrackingString,
                                  quickEvent: false,
                                  proximity: 0)
                //post event to user
                DBService.postEvent(event: event, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Posting Event Error", message: error.localizedDescription)
                    } else {
                        //create function that goes through friends array
                        //function that takes array and turns to dictionary
                        DBService.postPendingEventToUser(user: user, userIds: self!.friendsArray, event: event, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Posting Event To Guest Pending Error", message: error.localizedDescription)
                            } else {
                                print("posted to guest pending")
                            }
                        })
                        DBService.postAcceptedEventToUser(user: user, event: event, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Posting Event To Host Accepted Error", message: error.localizedDescription)
                            } else {
                                print("posted to host accepted")
                            }
                        })
                        DBService.addInvited(user: user, docRef: docRef.documentID, friends: self!.friendsArray, tasks: self!.friendsDictionary, completion: { [weak self] error in
                            if let error = error {
                                self?.showAlert(title: "Inviting Friends Error", message: error.localizedDescription)
                                self?.createEditTableView.createButton.isEnabled = true
                            } else {
                                //============================================================
                                // Adding notification
                                let startContent = UNMutableNotificationContent()
                                
                                startContent.title = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Beginning", arguments: nil)
                                startContent.body = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Starting", arguments: nil)
                                startContent.sound = UNNotificationSound.default
                                
                                let endContent = UNMutableNotificationContent()
                                endContent.title = NSString.localizedUserNotificationString(forKey: "\(event.eventName) ended", arguments: nil)
                                endContent.body = NSString.localizedUserNotificationString(forKey: "\(event.eventName) Ending", arguments: nil)
                                endContent.sound = UNNotificationSound.default
                                let startDate = self?.selectedStartDate
                                let calendar = Calendar.current
                                let startYear = calendar.component(.year, from: startDate!)
                                let startMonth = calendar.component(.month, from: startDate!)
                                let startDay = calendar.component(.day, from: startDate!)
                                let startHour = calendar.component(.hour, from: startDate!)
                                let startMinutes = calendar.component(.minute, from: startDate!)
                                
                                let endDate = self?.selectedEndDate
                                let endYear = calendar.component(.year, from: endDate!)
                                let endMonth = calendar.component(.month, from: endDate!)
                                let endDay = calendar.component(.day, from: endDate!)
                                let endHour = calendar.component(.hour, from: endDate!)
                                let endMinutes = calendar.component(.minute, from: endDate!)
                                
                                var startDateComponent = DateComponents()
                                startDateComponent.year = startYear
                                startDateComponent.month = startMonth
                                startDateComponent.day = startDay
                                startDateComponent.hour = startHour
                                startDateComponent.minute = startMinutes
                                startDateComponent.timeZone = TimeZone.current
                                var endDateComponent = DateComponents()
                                endDateComponent.year = endYear
                                endDateComponent.month = endMonth
                                endDateComponent.day = endDay
                                endDateComponent.hour = endHour
                                endDateComponent.minute = endMinutes
                                endDateComponent.timeZone = TimeZone.current
                                
                                let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: false)
                                let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: false)
                                
                                let startRequest = UNNotificationRequest(identifier: "Event Start", content: startContent, trigger: startTrigger)
                                let endRequest = UNNotificationRequest(identifier: "Event End", content: endContent, trigger: endTrigger)
                                
                                UNUserNotificationCenter.current().add(startRequest) { (error) in
                                    if let error = error {
                                        print("notification delivery error: \(error)")
                                    } else {
                                        print("successfully added start notification")
                                    }
                                }
                                UNUserNotificationCenter.current().add(endRequest) { (error) in
                                    if let error = error {
                                        print("notification delivery error: \(error)")
                                    } else {
                                        print("successfully added end notification")
                                    }
                                }
                                self?.showAlert(title: "Event Posted", message: nil) { action in
                                    print(docRef.documentID)
                                    //                    self?.dismiss(animated: true)//code here to segue to detail
                                    let detailVC = EventTableViewController()
                                    detailVC.event = event
                                    detailVC.tag = 0
                                    //                    detailVC.delegate = self
                                    self?.navigationController?.pushViewController(detailVC, animated: true)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
}
extension CreateEditTableViewController: LocationSearchViewControllerDelegate {
    func getLocation(locationTuple: (String, CLLocationCoordinate2D)) {
        print("tuple printout of string: \(locationTuple.0)")
        print("tuple printout of coordinates: \(locationTuple.1)")
        createEditTableView.addressButton.setTitle(locationTuple.0, for: .normal)
        createEditTableView.addressButton.titleLabel?.text = locationTuple.0
        selectedLocation = locationTuple.0
        selectedCoordinates = locationTuple.1
    }
}

extension CreateEditTableViewController: InvitedViewControllerDelegate {
    func selectedFriends(friends: [UserModel]) {
        print("Friends selected")
        friendsArray = friends
        var count = 0
        for friend in friends {
            if friendsDictionary[count] == nil {
                friendsDictionary[count] = "No Task"
            }
            count += 1
        }
        tableView.reloadData()
    }
}
extension CreateEditTableViewController: DateViewControllerDelegate {
    func selectedDate(startDate: Date, endDate: Date) {
        
        selectedStartDate = startDate
        selectedEndDate = endDate
        
        let startDisplayString = startDate.toString(dateFormat: "MMMM dd hh:mm a")
        createEditTableView.dateButton.setTitle(startDisplayString, for: .normal)
    }
}

extension CreateEditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
        selectedImage = resizedImage.image
        createEditTableView.imageButton.setImage(selectedImage, for: .normal)
        dismiss(animated: true)
    }
}
extension CreateEditTableViewController: CreateEditTableViewCellDelegate {
    func textDelegate() {
//        print("Okay")
    }
}
extension CreateEditTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField")
        isTextField = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //for id key save text
        guard let typedText = textField.text else {return false}
        for (key, value) in friendsDictionary {
            
            if textField.tag == key {
                friendsDictionary[key] = typedText
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        isTextField = false
        //for id key save text
        guard let typedText = textField.text else {
            print("unable to obtain task")
            return
        }
        for (key, value) in friendsDictionary {
            
            if textField.tag == key {
                friendsDictionary[key] = typedText
            }
        }
    }
}
