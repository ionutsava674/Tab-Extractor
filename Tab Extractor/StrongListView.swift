//
//  StrongListView.swift
//  Tab Extractor
//
//  Created by Ionut on 12.06.2021.
//

import SwiftUI

struct Note: Identifiable, Hashable {
    let id: UUID
    var title: String
    var text: String
    var isOn: Bool = false
}
class NoteList: ObservableObject {
    @Published var notes: [Note] = []
}
struct NoteView: View {
    @Binding var note: Note
    var body: some View {
        VStack {
            Text(note.title)
            Text(note.text)
            Toggle("sel", isOn: $note.isOn)
        }
    }
}
struct NoteListView: View {
    @ObservedObject var list: NoteList
    var body: some View {
        List() {
            ForEach( list.notes.indices, id: \.self) { noteIndex in
                //Text(list.notes[noteIndex].title)
                NoteView(note: $list.notes[noteIndex])
            }
        }
    }
}

struct StrongListView: View {
    @ObservedObject var list: NoteList
    init() {
        list = NoteList()
        list.notes.append(Note(id: UUID(), title: "tit 1", text: "content 1"))
        list.notes.append(Note(id: UUID(), title: "tit 2", text: "content 2"))
        list.notes.append(Note(id: UUID(), title: "tit 3", text: "content 3"))
    }
    var body: some View {
        NoteListView(list: list)
    }
}

struct IdIndices<Base: RandomAccessCollection>
where Base.Element: Identifiable {
    typealias Index = Base.Index
    struct Element: Identifiable {
        let id: Base.Element.ID
        let rawValue: Index
    }
    fileprivate var bs: Base
}
extension IdIndices: RandomAccessCollection {
    var startIndex: Index { bs.startIndex }
    var endIndex: Index { bs.endIndex }
    subscript(position: Base.Index) -> Element {
        Element(id: bs[position].id, rawValue: position)
    }
    func index(before i: Base.Index) -> Base.Index {
        bs.index(before: i)
    }
    func index(after i: Base.Index) -> Base.Index {
        bs.index(after: i)
    }
}
