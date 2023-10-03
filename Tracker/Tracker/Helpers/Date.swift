//
//  Date.swift
//  Tracker
//
//  Created by Alexandr Seva on 02.10.2023.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.dateFormat = "MM/dd/YY"
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }
}
