//
//  TabDisplayableLine.swift
//  Tab Extractor
//
//  Created by Ionut on 02.01.2022.
//

import Foundation

struct DisplayableCluster {
    var idForUI = UUID()
    weak var fromCluster: GuitarTab.Cluster?
    var content: String
    
    init(from cluster: GuitarTab.Cluster?, rawString: String) {
        fromCluster = cluster
        content = rawString
    }
    init(from cluster: GuitarTab.Cluster, using formatter: DisplayableClusterFormatter, and stringNames: [String]) {
        fromCluster = cluster
        let sortedNotes = cluster.notes.sortedNicely()
        
        let mapped = sortedNotes.map { (note: GuitarTab.Note) -> String in
            let fullName: String = stringNames.indices.contains( note.stringIndex)
            ? stringNames[ note.stringIndex]
            : "?"
            return "\(fullName)\(formatter.stringToValueSeparator)\(note.fretValue)"
        }
        content = mapped.joined(separator: formatter.noteNoteSeparator)
    }
} //str

struct DisplayableClusterFormatter {
    let stringToValueSeparator: String
    let noteNoteSeparator: String
    let stringHeaderSeparator: String
    
    func makeDisplayText(from cluster: GuitarTab.Cluster, asHeader: Bool = false, withStringNames stringNames: [String]) -> String {
        if cluster.isBar {
            return NSLocalizedString("Bar", comment: "guitar tab bar")
        }
        if asHeader {
            return cluster.notes.map({
                $0.fretValue
            }).joined(separator: self.stringHeaderSeparator)
        }
        let sortedNotes = cluster.notes.sortedNicely()
        let mapped = sortedNotes.map { (note: GuitarTab.Note) -> String in
            "\( stringNames.at( note.stringIndex, defaultValue: "?") )\(self.stringToValueSeparator)\(note.fretValue)"
        }
        return mapped.joined(separator: noteNoteSeparator)
    } //func
} //str

extension Array where Element == String {
    func at(_ index: Self.Index, defaultValue: Element) -> Element {
        guard self.indices.contains(index) else {
            return defaultValue
        }
        return self[index]
    } //func
} //ext
