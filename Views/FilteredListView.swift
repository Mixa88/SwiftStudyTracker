//
//  FilteredListView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 04.08.2025.
//

import SwiftUI
import SwiftData

// НОВЫЙ "ГЛУПЫЙ" VIEW, КОТОРЫЙ ТОЛЬКО ОТОБРАЖАЕТ СПИСОК
struct FilteredListView: View {
    // Этот @Query инициализируется каждый раз, когда создается FilteredListView
    @Query var entries: [StudyEntry]
    
    // Кастомный инициализатор, который принимает тег и настраивает запрос
    init(selectedTag: Tag?) {
        let predicate: Predicate<StudyEntry>?
        
        if let tag = selectedTag {
            
            let tagID = tag.id
            predicate = #Predicate<StudyEntry> { entry in
                entry.tags.contains { $0.id == tagID }
            }
        } else {
            predicate = nil
        }
        
        
        _entries = Query(filter: predicate, sort: \.date, order: .reverse)
    }
    
    var body: some View {
        
        List {
            ForEach(entries) { entry in
                NavigationLink(value: entry) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(entry.topic)
                                .font(.headline)
                            Text(entry.source)
                                .foregroundStyle(.secondary)
                            
                            if !entry.tags.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(entry.tags.sorted { $0.name < $1.name }) { tag in
                                            Text(tag.name)
                                                .font(.caption2)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.accentColor.opacity(0.2))
                                                .foregroundStyle(Color.accentColor)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(entry.durationInMinutes) min")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteEntries)
        }
    }
    
    @Environment(\.modelContext) var modelContext
    
    func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            let entry = entries[offset]
            modelContext.delete(entry)
        }
    }
}
