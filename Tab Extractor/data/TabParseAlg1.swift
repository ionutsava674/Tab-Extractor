//
//  TabParseAlg1.swift
//  Tab Extractor
//
//  Created by Ionut on 08.06.2021.
//

import Foundation

class TabParseAlg1: TabParseAlg {
    func lastIndexThatLooksGood(slice: ArraySlice<String>, checkIfGoodEndIndex: Array<String>.Index) -> Array<String>.Index? {
        if slice.isEmpty
            || (checkIfGoodEndIndex >= slice.endIndex) {
            return nil
        }
        if checkIfGoodEndIndex == slice.startIndex {
            return lastIndexThatLooksGood(slice: slice, checkIfGoodEndIndex: slice.index(after: checkIfGoodEndIndex))
        }
        let c0 = slice[ slice.startIndex].count
        for lineIndex in slice.startIndex...checkIfGoodEndIndex {
            if slice[ lineIndex].count != c0 {
                return nil
            }
        }
        
        let bars = getBars(linesWSC: slice[slice.startIndex...checkIfGoodEndIndex])
        if !bars.looksGood() {
            return nil
        }
        let nextCheck = lastIndexThatLooksGood(slice: slice, checkIfGoodEndIndex: slice.index(after: checkIfGoodEndIndex))
        return nextCheck == nil ?
            checkIfGoodEndIndex :
            nextCheck
    } //func
    private func getBars( linesWSC: ArraySlice<String>) -> TabPageResume {
        var tabReport = TabPageResume()
        var inds = [String.Index]()
        for line in linesWSC {
            inds.append(line.startIndex)
        }
        for c in linesWSC[linesWSC.startIndex] {
            var ccIsBar = !( c.isLetter || c.isNumber )
            if ccIsBar {
                for iind in 1..<inds.count {
                    if linesWSC[linesWSC.startIndex + iind][inds[iind]] != c {
                        ccIsBar = false
                        break
                    }
                }
            }
            if ccIsBar {
                tabReport.barIndices.append(inds[0])
                tabReport.barCharsCounted[c] = (tabReport.barCharsCounted[c] ?? 0) + 1
            }
            for iind in 0..<inds.count {
                linesWSC[linesWSC.startIndex + iind].formIndex(after: &inds[iind])
            }
        }
        tabReport.onlyBarChars = Set(tabReport.barCharsCounted.keys)
        for iind in 0..<inds.count {
            inds[iind] = linesWSC[linesWSC.startIndex + iind].startIndex
        }
        for _ in linesWSC[linesWSC.startIndex] {
            let ccIsBar = tabReport.barIndices.contains(inds[0])
            for iind in 0..<inds.count {
                let susp = linesWSC[linesWSC.startIndex + iind][inds[iind]]
                let suspWasBar = tabReport.onlyBarChars.contains(susp)
                if !ccIsBar && suspWasBar {
                    tabReport.onlyBarChars.remove(susp)
                }
            }
            for iind in 0..<inds.count {
                linesWSC[linesWSC.startIndex + iind].formIndex(after: &inds[iind])
            }
        }
        tabReport.nobBars = Set(         tabReport.barCharsCounted.keys ).subtracting(        tabReport.onlyBarChars)
        if !tabReport.barCharsCounted.isEmpty {
            let mac = tabReport.sortedBCC()[0].key
            if tabReport.onlyBarChars.contains(mac) {
                tabReport.onlyBarChars.remove(mac)
                tabReport.nobBars.insert(mac)
            }
        }
        return tabReport
    } //func
    func parsePage(slice: ArraySlice<String>) -> GuitarTab.Page? {
        let bars = getBars(linesWSC: slice)
        if !bars.looksGood() {
            return nil
        }
        let r = GuitarTab.Page()
        let bccs = bars.sortedBCC()
        var fretStarters = Set<Character>(" ")
        fretStarters.insert( bccs[0].key)
        var fretEnders = Set<Character>( bars.barCharsCounted.keys)
        fretEnders.insert(" ")
        for lnIdx in slice.startIndex..<slice.endIndex {
            let sLine = slice[ lnIdx]
            var newLine = GuitarTab.TabLine()
            let epos = sLine.endIndex
            var cpos = sLine.startIndex
            repeat {
                cpos = findNextFretValue( line: sLine, fromIndex: cpos, starterChars: fretStarters)
                if cpos < epos {
                    let fs = cpos
                    if bars.onlyBarChars.contains( sLine[ cpos]) {
                        sLine.formIndex(after: &cpos)
                    } else {
                        cpos = findFretEndPos( line: sLine, fromIndex: cpos, enderChars: fretEnders)
                    }
                    let fv = sLine[ fs..<cpos].trimmingCharacters(in: .whitespaces)
                    let isBar = fv.count == 1 && bars.onlyBarChars.contains( fv[ fv.startIndex])
                    //print(fv)
                    let newNote = GuitarTab.Note(fretValue: String(fv), stringIndex: lnIdx - slice.startIndex, isBar: isBar, position: sLine.distance(from: sLine.startIndex, to: fs), length: sLine.distance(from: fs, to: cpos))
                    //print(newNote)
                    newLine.append(newNote)
                }
            } while cpos < epos
            r.lines.append(newLine)
        } //each line
        return r
    } //func
    private func findNextFretValue( line: String, fromIndex: String.Index, starterChars: Set<Character>) -> String.Index {
        var cIndex = fromIndex
        while cIndex < line.endIndex {
            if !starterChars.contains( line[ cIndex]) {
                return cIndex
            }
            line.formIndex(after: &cIndex)
        }
        return line.endIndex
    }
    private func findFretEndPos(line: String, fromIndex: String.Index, enderChars: Set<Character>) -> String.Index {
        var cIndex = line.index(after: fromIndex)
        while cIndex < line.endIndex {
            if enderChars.contains( line[ cIndex]) {
                return cIndex
            }
            line.formIndex(after: &cIndex)
        }
        return line.endIndex
    } //func
} //alg class

struct TabPageResume {
    var barIndices: [String.Index] = []
    var onlyBarChars: Set<Character> = []
    var nobBars: Set<Character> = []
    var barCharsCounted: [Character: Int] = [:]
    var hasNobBars: Bool {
        //print("nob bars", nobBars)
        return !nobBars.isEmpty
    }
    func sortedBCC() -> [(key: Character, value: Int)] {
        barCharsCounted.sorted { $0.value > $1.value }
    }
    func looksGood() -> Bool {
        if nobBars.isEmpty {
            return false
        }
        if barCharsCounted.isEmpty {
            return false
        }
        let mac = sortedBCC()[0].key
        return !mac.isWhitespace
    }
}
