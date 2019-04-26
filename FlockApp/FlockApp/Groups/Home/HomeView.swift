//
//  HomeView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

protocol UserEventCollectionViewDelegate: AnyObject {
    func segmentedEventsPressed()
    func segmentedPastEventPressed()
    func pendingJoinEventPressed()
    

}

class HomeView: UIView {
    
    weak var delegate: UserEventCollectionViewDelegate?
    
    var homeViewController: HomeViewController?
    var cellView =  EventHomeCollectionViewCell()

    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Thursday, 18th, 2019"
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 12)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Thursday"
        label.backgroundColor = .white
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 40), size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let image = UIImage(named: "createButton")
        print("Create button pressed")
        return button
    }()
    
    
    

    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Events", "Past Events", "Pending Events"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor =  .black
        segmentedControl.backgroundColor = #colorLiteral(red: 0.9101855159, green: 0.2931141555, blue: 1, alpha: 1)
        segmentedControl.layer.borderWidth = 0.1
        //segmentedControl.layer.opacity = 0.3
        segmentedControl.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
        public lazy var usersCollectionView: UICollectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .vertical
            cellLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 25)
            cellLayout.itemSize = CGSize.init(width: 350, height:350)
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            collectionView.backgroundColor = .white
            collectionView.layer.cornerRadius = 15.0
            return collectionView
        }()
    
//    public lazy var newEventsCollectionView: UICollectionView = {
//        let cellLayout = UICollectionViewFlowLayout()
//        cellLayout.scrollDirection = .vertical
//        cellLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 25)
//        cellLayout.itemSize = CGSize.init(width: 350, height:350)
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
//        collectionView.layer.cornerRadius = 15.0
//        collectionView.backgroundColor = .white
//        return collectionView
//    }()
    
    
    
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var myViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            commonInit()
            self.usersCollectionView.register(EventHomeCollectionViewCell.self, forCellWithReuseIdentifier: "EventHomeCollectionViewCell")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
          
    
        }
    
        private func commonInit() {
            setConstraints()
        }
    
        func setConstraints() {
            setUpDateLabel()
            setUpDayLabel()
            setupUsersCollectionView()
            setupSegmentedView()
            //cellView.setupEventLabel()
            //cellView.setupJoinButton()
        }
    
    func setUpDateLabel(){
       addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.02).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        //dateLabel.bottomAnchor.constraint(equalTo: usersCollectionView.topAnchor, constant: 0).isActive = true
        
    }
    
    func setUpDayLabel() {
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        dayLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
        dayLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
    }
    
    
    
    func setupSegmentedView(){
        addSubview(segmentedControl)
        
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:
            125).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.03).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
    
        
        
    }
    
    func setupUsersCollectionView() {
        addSubview(usersCollectionView)
        usersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        usersCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        usersCollectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.80).isActive = true
        usersCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        usersCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }

    
       @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("Current Events")
            delegate?.segmentedEventsPressed()
            cellView.joinEventButton.isHidden = true
        case 1:
            print("Past Event")
            delegate?.segmentedPastEventPressed()
            cellView.joinEventButton.isHidden = true
        case 2:
            print("Join Event")
            delegate?.pendingJoinEventPressed()
            //cellView.startDateLabel.isHidden = false
            cellView.joinEventButton.isEnabled = true
            cellView.joinEventButton.isHidden = false
            //cellView.eventImage.isHidden = true
            //cellView.eventLabel.isHidden = true
    
            
        default:
            break
        }
    }
    
    }










