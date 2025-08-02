//
//  SwiftStudyTrackerApp.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftStudyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StudyEntry.self)
    }
}
