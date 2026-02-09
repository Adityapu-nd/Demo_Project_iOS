//
//  Item.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 09/02/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
