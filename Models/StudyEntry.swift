//
//  StudyEntry.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import Foundation
import SwiftData

@Model
class StudyEntry {
    var id = UUID()
    var date: Date
    var topic: String
    var durationInMinutes: Int
    var source: String
    var notes: String
    
    init(date: Date, topic: String, durationInMinutes: Int, source: String, notes: String) {
        self.date = date
        self.topic = topic
        self.durationInMinutes = durationInMinutes
        self.source = source
        self.notes = notes
    }
}
