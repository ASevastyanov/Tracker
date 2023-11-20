//
//  Tracker.swift
//  Tracker
//
//  Created by Alexandr Seva on 15.10.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let dateEvents: [Int]?
    let isPinned: Bool
}
