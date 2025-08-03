//
//  DetailEntryView.swift
//  SwiftStudyTracker
//
//  Created by Михайло Тихонов on 03.08.2025.
//

import SwiftUI
import SwiftData

struct DetailEntryView: View {
    let entry: StudyEntry
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                        // --- Блок с ключевыми метриками ---
                        HStack {
                            // Источник
                            VStack(alignment: .leading) {
                                Text("ИСТОЧНИК")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(entry.source)
                                    .font(.title2.weight(.semibold))
                            }
                            
                            Spacer()
                            
                            // Длительность
                            VStack(alignment: .leading) {
                                Text("ВРЕМЯ")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(entry.durationInMinutes) мин")
                                    .font(.title2.weight(.semibold))
                            }
                        }
                        .padding()
                        .background(.thinMaterial, in: .rect(cornerRadius: 12))
                        
                        // --- Блок с заметками ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Заметки")
                                .font(.headline)
                            
                            // Проверяем, есть ли заметки, чтобы показать заглушку
                            if entry.notes.isEmpty {
                                Text("Заметок к этой записи нет.")
                                    .italic()
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(entry.notes)
                            }
                        }
                        
                        // --- Дата в самом низу ---
                        Text("Запись от \(entry.date.formatted(date: .long, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top)

                    }
                    .padding()
        }
        .navigationTitle(entry.topic)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteEntry)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this entry", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteEntry() {
        modelContext.delete(entry)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StudyEntry.self, configurations: config)
        let example = StudyEntry(date: .now, topic: "Test Entry", durationInMinutes: 45, source: "Paul Hudson", notes: "Excellent Day")
        
        return DetailEntryView(entry: example)
            .modelContainer(container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
