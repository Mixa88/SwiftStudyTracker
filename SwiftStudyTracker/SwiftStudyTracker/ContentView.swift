//
//  ContentView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var entries: [StudyEntry]
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView {
                        Label("No entries yet", systemImage: "list.bullet.circle")
                    } description: {
                        Text("Please add your first entry by tapping the plus button in the top right corner.")
                    }
                } else {
                    List {
                        ForEach(entries) { entry in
                                HStack {
                                    VStack {
                                        Text(entry.topic)
                                            .font(.headline)
                                        Text(entry.source)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Text("\(entry.durationInMinutes) min")
                                }
                            
                        }
                        .onDelete(perform: deleteEntries)
                    }
                    
                }
            }
            .navigationTitle("Study Entries 📚")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
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
    
    func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            let entry = entries[offset]
            modelContext.delete(entry)
        }
    }
}

#Preview {
    ContentView()
}
