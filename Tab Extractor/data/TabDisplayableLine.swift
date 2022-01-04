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
}
