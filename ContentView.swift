//
//  ContentView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTag: Tag?
    @State private var showingAddScreen = false
    
    // Запрос для получения всех тегов для меню фильтра
    @Query(sort: \Tag.name) var allTags: [Tag]
    
    var body: some View {
        NavigationStack {
            // ContentView теперь просто создает FilteredListView и передает ему выбранный тег
            FilteredListView(selectedTag: selectedTag)
                .navigationTitle(selectedTag?.name.capitalized ?? "Study Entries 📚")
                .navigationDestination(for: StudyEntry.self) { entry in
                    DetailEntryView(entry: entry)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button("Show All", action: { selectedTag = nil })
                            
                            if !allTags.isEmpty {
                                Divider()
                                ForEach(allTags) { tag in
                                    Button(tag.name.capitalized, action: { selectedTag = tag })
                                }
                            }
                        } label: {
                            Image(systemName: selectedTag == nil ? "tag" : "tag.fill")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add new entry", systemImage: "plus") {
                            showingAddScreen.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddEntryView()
                }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: [StudyEntry.self, Tag.self], inMemory: true)
}
