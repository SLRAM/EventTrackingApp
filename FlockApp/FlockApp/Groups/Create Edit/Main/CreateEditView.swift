//
//  CreateEditView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
protocol CreateViewDelegate: AnyObject {
    func createPressed()
    func addressPressed()
    func datePressed()
    func friendsPressed()
    func cancelPressed()
    func imagePressed()
    func trackingIncreasePressed()
    func trackingDecreasePressed()
}
class CreateEditView: UIView {
    
    weak var delegate: CreateViewDelegate?
    
    lazy var imageButton: UIButton = {
        let button = UIButton()
//        button.titleLabel?.numberOfLines = 0
//        button.titleLabel?.textAlignment = .center
//        button.setTitle("Event Image" + "\n" + "Event Time", for: .normal)
        
        

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(imagePressed), for: .touchUpInside)
        button.backgroundColor = .yellow
//        button.setImage(UIImage(named: "pitons"), for: .normal)
        button.setBackgroundImage(UIImage(named: "pitons"), for: .normal)
        button.layer.cornerRadius = 10.0
        
        return button
    }()
    @objc func imagePressed() {
        delegate?.imagePressed()
        print("event image pressed")
        
    }
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Address", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addressPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func addressPressed() {
        delegate?.addressPressed()
        print("event address pressed")
        
    }
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Date", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(datePressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func datePressed() {
        delegate?.datePressed()
        print("event date pressed")
        
    }
//    lazy var trackingStepper: UIStepper = {
//        let stepper = UIStepper()
//        return stepper
//    }()
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.text = "Event Tracking Time"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    lazy var trackingIncreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(trackingIncreasePressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8901717663, green: 0.8789022565, blue: 0, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func trackingIncreasePressed() {
        delegate?.trackingIncreasePressed()
        
    }
    lazy var trackingDecreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(trackingDecreasePressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8881237507, green: 0.8798579574, blue: 0, alpha: 1)
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func trackingDecreasePressed() {
        delegate?.trackingDecreasePressed()
        
    }
    lazy var friendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(friendsPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func friendsPressed() {
        delegate?.friendsPressed()
        print("event date pressed")
        
    }
    
    lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(CreateEditTableViewCell.self, forCellReuseIdentifier: "CreateEditTableViewCell")
        tv.rowHeight = (UIScreen.main.bounds.width)/10
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    @objc func cancelButtonPressed() {
        delegate?.cancelPressed()
    }
    
    
    
    
    public lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createPressed))
        return button
    }()
    @objc func createPressed() {
        delegate?.createPressed()
    }
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = #colorLiteral(red: 0.8529050946, green: 0.8478356004, blue: 0.8568023443, alpha: 0.4653253425).cgColor
        textView.textColor = .gray
        textView.textAlignment = .center
//        textView.font = textView.font?.withSize(20)
//        textView.text = "Enter the Event Title"
        textView.tag = 0
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .white
        setupView()
    }
    
}
extension CreateEditView {
    func setupView() {
        setupTitleTextField()
        setupImageButton()
        setupAddressButton()
        setupDateButton()
        setupTracking()
        setupFriendButton()
        setupTableView()

    }
    func setupTitleTextField() {
        addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupImageButton() {
        addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        imageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        imageButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.30).isActive = true
    }
    func setupAddressButton() {
        addSubview(addressButton)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        addressButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10).isActive = true
        addressButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        addressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        addressButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }

    func setupDateButton() {
        addSubview(dateButton)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: 10).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        dateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dateButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupTracking() {
        addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 10).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        myLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true

        setupTrackingIncrease()
        setupTrackingDecrease()
    }
    func setupTrackingIncrease() {
        addSubview(trackingIncreaseButton)
        trackingIncreaseButton.translatesAutoresizingMaskIntoConstraints = false
        trackingIncreaseButton.topAnchor.constraint(equalTo: myLabel.topAnchor).isActive = true
        trackingIncreaseButton.trailingAnchor.constraint(equalTo: myLabel.trailingAnchor).isActive = true
        trackingIncreaseButton.heightAnchor.constraint(equalTo: myLabel.heightAnchor, multiplier: 1).isActive = true
        trackingIncreaseButton.widthAnchor.constraint(equalTo: myLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    func setupTrackingDecrease() {
        addSubview(trackingDecreaseButton)
        trackingDecreaseButton.translatesAutoresizingMaskIntoConstraints = false
        trackingDecreaseButton.topAnchor.constraint(equalTo: myLabel.topAnchor).isActive = true
        trackingDecreaseButton.leadingAnchor.constraint(equalTo: myLabel.leadingAnchor).isActive = true
        trackingDecreaseButton.heightAnchor.constraint(equalTo: myLabel.heightAnchor, multiplier: 1).isActive = true
        trackingDecreaseButton.widthAnchor.constraint(equalTo: myLabel.widthAnchor, multiplier: 0.2).isActive = true
    }
    func setupFriendButton() {
        addSubview(friendButton)
        friendButton.translatesAutoresizingMaskIntoConstraints = false
        friendButton.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 10).isActive = true
        friendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        friendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        friendButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func setupTableView() {
        addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: friendButton.bottomAnchor, constant: 10).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
//        myTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
}
