//
//  TabExtract.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import Foundation

class GuitarTab: Codable, ObservableObject {
    
    class Note: Codable {
        var fretValue: String
        var stringIndex: Int
        var isBar: Bool
        var position: Int
        var length: Int
        var inClusterId: Int?
        init(fretValue: String, stringIndex: Int, isBar: Bool, position: Int, length: Int) {
            self.fretValue = fretValue
            self.stringIndex = stringIndex
            self.isBar = isBar
            self.position = position
            self.length = length
        }
    } //def
    
    class Cluster {
        let id: Int
        var minPosition: Int
        var notes: [Note]
        var isBar: Bool
        init(id: Int) {
            self.id = id
            notes = []
            minPosition = Int.max
            isBar = false
        }
        fileprivate func addNote(note: Note) -> Void {
            notes.append(note)
            minPosition = min(minPosition, note.position)
            isBar = note.isBar
        }
    } //def
    
    typealias TabLine = [Note]
    
    class Page:Codable, ObservableObject, Identifiable {
        enum CodingKeys: CodingKey {
            case lines, title, sourceStrings
        }
        var id = UUID()
        var lines: [TabLine] = []
        var title: String = ""
        var sourceStrings: [String] = []
        private lazy var p_AllNotes: [Note] = { generateAllLines() }()
        lazy var clusters: [Cluster] = { [unowned self] in generateClusters(allNotes: self.p_AllNotes) }()
        lazy var displayableLines: [String] = { [unowned self] in computeDisplayableLines(clusts: self.clusters, includeBars: true) }()

        func computeDisplayableLines( clusts: [Cluster], includeBars: Bool) -> [String] {
            computeDisplayableLinesEx( clusts: clusts, includeBars: includeBars)
        }
        static var comcou = 0
        func computeDisplayableLinesEx( clusts: [Cluster], includeBars: Bool, headerLineStringNameSeparator: String = " ", stringValueSeparator: String = "", noteNoteSeparator: String = ", ") -> [String] {
            Self.comcou += 1
            print("computed \(Self.comcou)")
            var out = [String]()
            let stringNames = getStringNames1( clusts: clusts)
            let namesCluster = getNamesCluster(clusts: clusts)
            if let namesLine = namesCluster?.notes.map({
                $0.fretValue
            }).joined(separator: headerLineStringNameSeparator) {
                out.append(namesLine)
            }
            let goodIndices = 0..<stringNames.count
            for clu in clusts {
                if clu === namesCluster {
                    continue
                }
                if clu.isBar {
                    if includeBars {
                        out.append(NSLocalizedString("Bar", comment: "guitar tab bar"))
                    }
                    continue
                }
                let sortedNotes = clu.notes.sorted {
                    $0.stringIndex < $1.stringIndex
                        || ($0.stringIndex == $1.stringIndex && $0.position < $1.position)
                }
                let mapped = sortedNotes.map { (note: GuitarTab.Note) -> String in
                    let fullName: String = goodIndices.contains( note.stringIndex) ? stringNames[ note.stringIndex] : "?"
                    return fullName + stringValueSeparator + note.fretValue
                }
                let curLine = mapped.joined(separator: noteNoteSeparator)
                out.append(curLine)
            }
            return out
        }
        func unnamedStringNames() -> [String] {
            var names = [String]()
            for i in 0..<self.lines.count {
                names.append(String.localizedStringWithFormat(NSLocalizedString("s%1$d;", comment: "string number: s1 s2 etc"), i))
            }
            return names
        }
        func getStringNames2( clusts: [Cluster]) -> [String] {
            var names = [String]()
            if let firstFullCluster = ( clusts.first { c in
                !c.isBar
            } ) {
                for lineIndex in 0..<self.lines.count {
                    let noteCount = (firstFullCluster.notes.filter { n in
                        n.stringIndex == lineIndex
                    }).count
                    if noteCount != 1 {
                        return unnamedStringNames()
                    }
                } //good name cluster
                ////
                for li in 0..<lines.count {
                    if let n = firstFullCluster.notes.first(where: { cn in
                        cn.stringIndex == li
                    }) {
                        names.append(n.fretValue)
                    } else {
return unnamedStringNames()
                    }
                } //for
            } else {
                return unnamedStringNames()
            }
            return names
        }
        private func getStringNames1( clusts: [Cluster]) -> [String] {
            guard let namesCluster = getNamesCluster(clusts: clusts) else {
                return unnamedStringNames()
            }
            return (namesCluster.notes.sorted { n1, n2 in
                n1.stringIndex < n2.stringIndex
                    || (n1.stringIndex == n2.stringIndex && n1.position < n2.position)
            }).map { note in
                note.fretValue
            }
        }
        private func getNamesCluster( clusts: [Cluster]) -> Cluster? {
            guard let firstFullCandidate = ( clusts.first { c in
                !c.isBar
            } ) else {
                return nil
            }
            //number test
            let lineRange = 0..<lines.count
            for note in firstFullCandidate.notes {
                if let _ = Int(note.fretValue) {
                    return nil
                }
                if !(lineRange.contains(note.stringIndex)) {
                    return nil
                }
            } //for
            for lineIndex in 0..<self.lines.count {
                let noteCount = (firstFullCandidate.notes.filter { n in
                    n.stringIndex == lineIndex
                }).count
                if noteCount != 1 {
                    return nil
                }
            } //for
            return firstFullCandidate
        }
        private func generateClusters(allNotes: [Note]) -> [Cluster] {
            var retClusts = [Cluster]()
            let san = allNotes.sorted {
                $0.position < $1.position
                    || ($0.position == $1.position && $0.stringIndex < $1.stringIndex)
            }
            san.forEach {
                $0.inClusterId = nil
            }
            var curCluster = 0
            for en in san {
                if en.inClusterId == nil {
                    curCluster += 1
                    en.inClusterId = curCluster
                }
                for aon in san {
                    if en === aon {
                        continue
                    }
                    if ( en.position + en.length > aon.position)
                        && ( aon.position + aon.length > en.position) {
                        if aon.inClusterId == nil {
                            aon.inClusterId = en.inClusterId
                        } else if aon.inClusterId != en.inClusterId {
                            for old in san {
                                if old.inClusterId == aon.inClusterId {
                                    old.inClusterId = en.inClusterId
                                }
                            }
                        } //adopted
                    }
                } //find brothers
            } //for each note
            for en in san {
                var clus = retClusts.first {
                    $0.id == en.inClusterId
                }
                if clus == nil {
                    clus = Cluster( id: en.inClusterId ?? 0)
                    retClusts.append(clus!)
                }
                clus!.addNote( note: en)
            }
            return retClusts
        } //func
        private func generateAllLines() -> [Note] {
            var retAn = [Note]()
            for iLine in lines {
                for iNote in iLine {
                    retAn.append(iNote)
                }
            }
            return retAn
        }
    } //def page
    
    enum CodingKeys: CodingKey {
        case pages, title, sourceUrl
    }
    var pages: [Page] = []
    var title: String = ""
    var sourceUrl: String?
    
}
