//
//  TabParseAlg2.swift
//  Tab Extractor
//
//  Created by Ionut on 10.06.2021.
//

import Foundation

extension String {
    func indexAtDistance( _ dist: Int) -> String.Index {
        index(startIndex, offsetBy: dist)
    }
    func charAtDistance( _ dist: Int) -> Character {
        self[indexAtDistance( dist)]
    }
}
class TabParseAlg2: TabParseAlg {
    func lastIndexThatLooksGood(slice: ArraySlice<String>, checkIfGoodEndIndex: Array<String>.Index) -> Array<String>.Index? {
        if slice.isEmpty
            || (checkIfGoodEndIndex >= slice.endIndex) {
            return nil
        }
        if checkIfGoodEndIndex == slice.startIndex {
            return lastIndexThatLooksGood(slice: slice, checkIfGoodEndIndex: slice.index(after: checkIfGoodEndIndex))
        }
        
        let info = gatherInfo(slice: slice[ slice.startIndex ... checkIfGoodEndIndex], checkCount: Int.max)
        if !info.minRequirements() {
            return nil
        }
        let nextCheck = lastIndexThatLooksGood(slice: slice, checkIfGoodEndIndex: slice.index(after: checkIfGoodEndIndex))
        let myInfo = getMaxInformation(slice: slice[ slice.startIndex ... checkIfGoodEndIndex])
        var maxSubInfo = Int.min
        for subStart in slice.index(after:  slice.startIndex) ... checkIfGoodEndIndex {
            let subInfo = getMaxInformation(slice: slice[ subStart ... checkIfGoodEndIndex])
            if subInfo > maxSubInfo {
                maxSubInfo = subInfo
            }
        }
        var nextInfo = Int.min
        if let goodNextIndex = nextCheck {
            nextInfo = getMaxInformation(slice: slice[ slice.startIndex ... goodNextIndex])
        }
        if nextInfo >= myInfo && nextInfo >= maxSubInfo {
            return nextCheck
        }
        if myInfo >= nextInfo && myInfo >= maxSubInfo {
            return checkIfGoodEndIndex
        }
        return nil
    }
    func getMaxInformation(slice: ArraySlice<String>) -> Int {
        var info = gatherInfo(slice: slice, checkCount: Int.max)
        if !info.minRequirements() {
            return Int.min
        }
        info.putMsbInNobs()
        var fretStarters = Set<Character>(" ")
        fretStarters.insert( info.globFreqSorted[0].key)
        var fretEnders = Set<Character>( info.barChars)
        fretEnders.insert(" ")
        var r = 0
        for lnIdx in slice.startIndex..<slice.endIndex {
            let bigSline = slice[ lnIdx]
            let runEndIndex = bigSline.indexAtDistance( info.checkedUpTo)
            //let sline = bigSline[ bigSline.startIndex ..< runEndIndex]
            var cpos = bigSline.startIndex
            repeat {
                cpos = findNextFretValue( line: bigSline, fromIndex: cpos, starterChars: fretStarters)
                if cpos < runEndIndex {
                    //let fs = cpos
                    if info.onlyBarChars.contains( bigSline[ cpos]) {
                        bigSline.formIndex(after: &cpos)
                    } else {
                        cpos = findFretEndPos( line: bigSline, fromIndex: cpos, enderChars: fretEnders)
                    }
                    //let fv = bigSline[ fs..<cpos].trimmingCharacters(in: .whitespaces)
                    //let isBar = fv.count == 1 && bars.onlyBarChars.contains( fv[ fv.startIndex])
                    r += 1
                } //found
            } while cpos < runEndIndex
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
    func parsePage(slice: ArraySlice<String>) -> GuitarTab.Page? {
        var info = gatherInfo(slice: slice, checkCount: Int.max)
        if !info.minRequirements() {
            return nil
        }
        info.putMsbInNobs()
        var fretStarters = Set<Character>(" ")
        fretStarters.insert( info.globFreqSorted[0].key)
        var fretEnders = Set<Character>( info.barChars)
        fretEnders.insert(" ")
        let r = GuitarTab.Page()
        for lnIdx in slice.startIndex..<slice.endIndex {
            let bigSline = slice[ lnIdx]
            let runEndIndex = bigSline.indexAtDistance( info.checkedUpTo)
            //let sline = bigSline[ bigSline.startIndex ..< runEndIndex]
            var cpos = bigSline.startIndex
            var newLine = GuitarTab.TabLine()
            repeat {
                cpos = findNextFretValue( line: bigSline, fromIndex: cpos, starterChars: fretStarters)
                if cpos < runEndIndex {
                    let fs = cpos
                    if info.onlyBarChars.contains( bigSline[ cpos]) {
                        bigSline.formIndex(after: &cpos)
                    } else {
                        cpos = findFretEndPos( line: bigSline, fromIndex: cpos, enderChars: fretEnders)
                    }
                    let fv = bigSline[ fs..<cpos].trimmingCharacters(in: .whitespaces)
                    let isBar = fv.count == 1 && info.onlyBarChars.contains( fv[ fv.startIndex])
                    let newNote = GuitarTab.Note(fretValue: String(fv), stringIndex: lnIdx - slice.startIndex, isBar: isBar, position: bigSline.distance(from: bigSline.startIndex, to: fs), length: bigSline.distance(from: fs, to: cpos))
                    newLine.append( newNote)
                } //found
            } while cpos < runEndIndex
            r.lines.append( newLine)
        } //each line
        return r
        //GuitarTab.Page()
    }
    func gatherInfo( slice: ArraySlice<String>, checkCount: Int) -> barInfo2 {
        var r = barInfo2()
        if slice.count < 2 {
            return r
        }
        let minCount = slice.reduce(Int.max) { cMin, line in
            min(cMin, line.count)
        }
        let runCount = min(minCount, checkCount)
        r.checkedUpTo = runCount
        var barFreq: [Character: Int] = [:]
        var globFreq: [Character: Int] = [:]
        for i in 0..<runCount {
            let l0 = slice[ slice.startIndex]
            let ctc = l0.charAtDistance( i)
            var lIsBar = !(ctc.isLetter || ctc.isNumber)
            for line in slice {
                let ctcw = line.charAtDistance( i)
                globFreq[ ctcw] = (globFreq[ ctcw] ?? 0) + 1
                if ctc != ctcw {
                    lIsBar = false
                }
            }
            if lIsBar {
                r.barPositions.append( i)
                r.barChars.insert( ctc)
                barFreq[ ctc] = (barFreq[ ctc] ?? 0) + 1
            }
        } //for i
        r.barFreqSorted = barFreq.sorted { $0.value > $1.value }
        r.globFreqSorted = globFreq.sorted { $0.value > $1.value }
        for line in slice {
            var lineCF: [Character: Int] = [:]
            for i in 0..<runCount {
                let c = line.charAtDistance( i)
                lineCF[ c] = (lineCF[ c] ?? 0) + 1
            }
            let s = lineCF.sorted { $0.value > $1.value }
            r.linesCharFreqSorted.append( s)
        }
        r.onlyBarChars = r.barChars
        r.nobChars = []
        for i in 0..<runCount {
            for line in slice {
                let ctc = line.charAtDistance(i)
                if r.barChars.contains( ctc)
                    && !r.barPositions.contains( i)
                    && !r.nobChars.contains( ctc) {
                    r.nobChars.insert( ctc)
                    r.onlyBarChars.remove( ctc)
                }
            }
        }
        return r
    } //getbars
    struct barInfo2 {
        var checkedUpTo = 0
        var barPositions = [Int]()
        var barChars = Set<Character>()
        var onlyBarChars: Set<Character> = []
        var nobChars: Set<Character> = []
        var linesCharFreqSorted: [[(key: Character, value: Int)]] = []
        var barFreqSorted: [(key: Character, value: Int)] = []
        var globFreqSorted: [(key: Character, value: Int)] = []
        
        mutating func putMsbInNobs() -> Void {
            if !minRequirements() {
                return
            }
            let msb = globFreqSorted[0].key
            if onlyBarChars.contains( msb) {
                onlyBarChars.remove( msb)
                nobChars.insert( msb)
            }
        }
        func minRequirements() -> Bool {
            if barChars.isEmpty {
                return false
            }
            let msb = barFreqSorted[0].key
            if msb.isWhitespace {
                return false
            }
            if globFreqSorted[0].key != msb {
                return false
            }
            for lf in linesCharFreqSorted {
                if lf[0].key != msb {
                    return false
                }
            }
            return true
        }
    }
}

