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
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
