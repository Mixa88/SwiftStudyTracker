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
    
    // Состояние для отслеживания выбранного тега для фильтрации
    @State private var selectedTag: Tag?
    
    // Динамический запрос, который будет изменяться в зависимости от selectedTag
    @Query var entries: [StudyEntry]
    
    // Запрос для получения всех тегов, чтобы показать их в меню фильтра
    @Query(sort: \Tag.name) var allTags: [Tag]
    
    @State private var showingAddScreen = false
    
    // Кастомный инициализатор для создания динамического запроса
    // Он будет вызываться каждый раз при изменении `selectedTag` благодаря .id(selectedTag) ниже
    init(selectedTag: Tag? = nil) {
        // Мы присваиваем значение _selectedTag, а не self.selectedTag, чтобы избежать рекурсии
        _selectedTag = State(initialValue: selectedTag)
        
        let predicate: Predicate<StudyEntry>?
        
        if let tag = selectedTag {
            // Если тег выбран, создаем предикат для фильтрации
            // Захватываем ID, чтобы избежать проблем с захватом всего объекта `tag` в замыкании
            let tagID = tag.id
            
            // ИЩЕМ ПО ID: содержит ли массив tags элемент, у которого id такой же, как tagID
            predicate = #Predicate<StudyEntry> { entry in
                entry.tags.contains { $0.id == tagID } // <--- ИСПРАВЛЕННАЯ СТРОКА
            }
        } else {
            // Если тег не выбран (nil), предикат тоже nil, что означает "без фильтра"
            predicate = nil
        }
        
        // Инициализируем наш @Query с нужным фильтром и сортировкой
        _entries = Query(filter: predicate, sort: \.date, order: .reverse)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView {
                        // Показываем разный текст в зависимости от того, активен ли фильтр
                        Label(selectedTag == nil ? "No entries yet" : "No entries for this tag", systemImage: "list.bullet.circle")
                    } description: {
                        Text(selectedTag == nil ? "Please add your first entry by tapping the plus button in the top right corner." : "Try selecting another tag or add a new entry with this tag.")
                    }
                } else {
                    List {
                        ForEach(entries) { entry in
                            NavigationLink(value: entry) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(entry.topic)
                                            .font(.headline)
                                        Text(entry.source)
                                            .foregroundStyle(.secondary)
                                        
                                        // Отображение тегов в виде "плашек"
                                        if !entry.tags.isEmpty {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    // Сортируем теги по имени для консистентности
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
                                .padding(.vertical, 4) // Небольшой отступ для красоты
                            }
                        }
                        .onDelete(perform: deleteEntries)
                    }
                }
            }
            .navigationTitle(selectedTag?.name.capitalized ?? "Study Entries 📚")
            .navigationDestination(for: StudyEntry.self) { entry in
                DetailEntryView(entry: entry)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                // Меню для фильтрации по тегам
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        // Кнопка для сброса фильтра
                        Button("Show All", action: { selectedTag = nil })
                        
                        if !allTags.isEmpty {
                            Divider()
                            ForEach(allTags) { tag in
                                Button(tag.name.capitalized, action: { selectedTag = tag })
                            }
                        }
                    } label: {
                        // Иконка меняется, если фильтр активен
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
        // Этот модификатор заставляет View пересоздаться при изменении selectedTag,
        // что вызывает наш кастомный init и обновляет @Query
        .id(selectedTag)
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
        .modelContainer(for: [StudyEntry.self, Tag.self], inMemory: true)
}
