//
//  AddEntryView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 02.08.2025.
//

import SwiftUI

struct AddEntryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var topic: String = ""
    @State private var source: String = ""
    @State private var durationInMinutes: Int = 0
    @State private var notes: String = ""
    @State private var date = Date.now
    
    
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
                
                Section {
                    Button("Save Entry") {
                        let newEntry = StudyEntry(date: date, topic: topic, durationInMinutes: durationInMinutes, source: source, notes: notes)
                        modelContext.insert(newEntry)
                        dismiss()
                    }
                    .disabled(!formIsValid)
                    
                }
                    
                }
                 .navigationTitle("Add New Entry ✍️")
            
            }
        }
    }


#Preview {
    AddEntryView()
}
