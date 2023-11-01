//
//  StoreError.swift
//  Tracker
//
//  Created by Alexandr Seva on 01.11.2023.
//

import Foundation

enum StoreError: Error {
    case failedToWrite
    case failedReading
    case failedDecoding
    case failedGettingTitle
    case failedActoionDelete
}
