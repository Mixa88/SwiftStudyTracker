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
                        Text(entry.source.isEmpty ? "N/A" : entry.source)
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
                
                // --- Блок с тегами ---
                if !entry.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Теги")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(entry.tags.sorted { $0.name < $1.name }) { tag in
                                    Text(tag.name)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.accentColor.opacity(0.2))
                                        .foregroundStyle(Color.accentColor)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
                
                // --- Блок с заметками ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Заметки")
                        .font(.headline)
                    
                    if entry.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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


// СОЗДАЕМ ОТДЕЛЬНУЮ VIEW-ОБЕРТКУ ДЛЯ ПРЕВЬЮ
private struct DetailPreviewContainer: View {

    // Свойство для хранения результата.
    // Либо получаем готовые данные (запись и контейнер), либо ошибку.
    let result: Result<(StudyEntry, ModelContainer), Error>

    // ИНИЦИАЛИЗАТОР - здесь мы выполняем всю опасную работу.
    // init() - это не ViewBuilder, поэтому здесь можно использовать do-catch!
    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: StudyEntry.self, Tag.self, configurations: config)
            
            let tagSwiftUI = Tag(name: "swiftui")
            let tagArch = Tag(name: "architecture")
            
            let example = StudyEntry(date: .now, topic: "Test Entry with Tags", durationInMinutes: 45, source: "Paul Hudson", notes: "Excellent Day")
            example.tags = [tagSwiftUI, tagArch]
            
            container.mainContext.insert(example)
            
            // Если все прошло успешно, сохраняем результат в свойство
            self.result = .success((example, container))
            
        } catch {
            // Если произошла ошибка, сохраняем ее
            self.result = .failure(error)
        }
    }

    // BODY - теперь только отображает готовый результат.
    // `switch` поддерживается во ViewBuilder.
    var body: some View {
        switch result {
        case .success(let (entry, container)):
            // Ветка для успешного выполнения
            NavigationStack {
                DetailEntryView(entry: entry)
            }
            .modelContainer(container)
            
        case .failure(let error):
            // Ветка для ошибки
            Text("Failed to create preview: \(error.localizedDescription)")
        }
    }
}


#Preview {
    DetailPreviewContainer()
}
