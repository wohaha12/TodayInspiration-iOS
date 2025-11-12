import SwiftUI
import CoreData
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)])
    private var notes: FetchedResults<Note>

    @State private var showEditor = false
    @State private var filterTag: String? = nil
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: { filterTag = nil }) {
                            Text("全部")
                                .padding(8)
                                .background(filterTag == nil ? Color.accentColor.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                        }
                        ForEach(allTags(), id: \ .self) { tag in
                            Button(action: { filterTag = tag }) {
                                Text(tag)
                                    .padding(8)
                                    .background(filterTag == tag ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }.padding(.horizontal)
                }

                List {
                    ForEach(filteredNotes(), id: \ .id) { note in
                        NavigationLink(destination: NoteEditorView(note: note)) {
                            NoteRowView(note: note)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("今日灵感")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showEditor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                NoteEditorView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private func allTags() -> [String] {
        let set = Set(notes.flatMap { $0.tags })
        return Array(set).sorted()
    }

    private func filteredNotes() -> [Note] {
        if let tag = filterTag {
            return notes.filter { $0.tags.contains(tag) }
        } else {
            return Array(notes)
        }
    }

    private func delete(offsets: IndexSet) {
        for i in offsets {
            let n = filteredNotes()[i]
            viewContext.delete(n)
        }
        save()
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
