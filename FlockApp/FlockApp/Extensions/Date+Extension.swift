//
//  Date+Extension.swift
//  FlockApp
//
//  Created by Yaz Burrell on 4/8/19.
//

import Foundation
extension Date {
    // get an ISO timestamp
    static func getISOTimestamp() -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        let timestamp = isoDateFormatter.string(from: Date())
        return timestamp
    }
}
