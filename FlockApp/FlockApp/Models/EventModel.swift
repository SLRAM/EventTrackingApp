//
//  EventModel.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import Foundation

struct Event {
    let eventName: String
    let createdDate: String
    let userID: String
    let imageURL: String?
    let eventDescription: String
    let documentId: String
    let startDate: String
    let endDate: String
    let locationString: String
    let locationLat: Double
    let locationLong: Double
//    let invited: [String]
    let trackingTime: Int
    // add user id for attendees
    // add tasks?
    // add time/date
    // add location
    
    init(eventName: String, createdDate: String, userID: String, imageURL: String?, eventDescription: String, documentId: String, startDate: String, endDate: String, locationString: String, locationLat: Double, locationLong: Double, trackingTime: Int) {
        self.eventName = eventName
        self.createdDate = createdDate
        self.userID = userID
        self.imageURL = imageURL
        self.eventDescription = eventDescription
        self.documentId = documentId
        self.startDate = startDate
        self.endDate = endDate
        self.locationString = locationString
        self.locationLat = locationLat
        self.locationLong = locationLong
//        self.invited = invited
        self.trackingTime = trackingTime
    }
    
    init(dict: [String: Any]) {
        self.eventName = dict[EventsCollectionKeys.EventNameKey] as? String ?? "no event name"
        self.createdDate = dict[EventsCollectionKeys.CreatedDateKey] as? String ?? "no date"
        self.userID = dict[EventsCollectionKeys.UserIDKey] as? String ?? "no user id"
        self.imageURL = dict[EventsCollectionKeys.ImageURLKey] as? String ?? "no imageURL"
        self.eventDescription = dict[EventsCollectionKeys.EventDescriptionKey] as? String ?? "no description"
        self.documentId = dict[EventsCollectionKeys.DocumentIdKey] as? String ?? "no document id"
        self.startDate = dict[EventsCollectionKeys.StartDateKey] as? String ?? "no start date"
        self.endDate = dict[EventsCollectionKeys.EndDateKey] as? String ?? "No end date"
        self.locationString = dict[EventsCollectionKeys.LocationStringKey] as? String ?? "no event location"
        self.locationLat = dict[EventsCollectionKeys.LocationLatKey] as? Double ?? 0
        self.locationLong = dict[EventsCollectionKeys.LocationLongKey] as? Double ?? 0
//        self.invited = dict[EventsCollectionKeys.InvitedKey] as? [String] ?? []
        self.trackingTime = dict[EventsCollectionKeys.TrackingTimeKey] as? Int ?? 0
    }
}
