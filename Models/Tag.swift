//
//  Tag.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 04.08.2025.
//

import Foundation
import SwiftData

@Model
class Tag {
    @Attribute(.unique)
    var name: String
    
    var id: UUID = UUID()
    
    var entries: [StudyEntry] = []
    
    init(name: String) {
        self.name = name
    }
}
