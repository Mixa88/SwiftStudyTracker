//
//  AddEntryView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var topic: String = ""
    @State private var source: String = ""
    @State private var durationInMinutes: Int = 0
    @State private var notes: String = ""
    @State private var date = Date.now
    
    @State private var tagInput: String = ""
    
    
    var formIsValid: Bool {
        !topic.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Main Info") {
                    TextField("Topic", text: $topic)
                    TextField("Source", text: $source)
                    }
                    
                
                Section("Details") {
                    
                    TextField("Duration (min)", value: $durationInMinutes, format: .number)
                        .keyboardType(.numberPad)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    TextEditor(text: $notes)
                        .frame(height: 150)
                    
                }
                
                Section("Tags") {
                    TextField("Tags (comma separated)", text: $tagInput)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    Button("Save Entry") {
                        saveEntry()
                        dismiss()
                    }
                    .disabled(!formIsValid)
                    
                }
                    
                }
                 .navigationTitle("Add New Entry ✍️")
            
            }
        }
    
    private func saveEntry() {
            
            let newEntry = StudyEntry(date: date, topic: topic, durationInMinutes: durationInMinutes, source: source, notes: notes)
            
            
            let tagNames = tagInput.split(separator: ",").map {
                $0.trimmingCharacters(in: .whitespaces).lowercased()
            }.filter { !$0.isEmpty }
            
            for name in tagNames {
                
                let predicate = #Predicate<Tag> { $0.name == name }
                let descriptor = FetchDescriptor(predicate: predicate)
                
                if let existingTag = try? modelContext.fetch(descriptor).first {
                    
                    newEntry.tags.append(existingTag)
                } else {
                    
                    let newTag = Tag(name: name)
                    newEntry.tags.append(newTag)
                }
            }
            
            
            modelContext.insert(newEntry)
        }
    }


#Preview {
    AddEntryView()
}
