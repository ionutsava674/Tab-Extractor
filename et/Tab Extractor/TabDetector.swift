//
//  TabDetector.swift
//  Tab Extractor
//
//  Created by Ionut on 01.06.2021.
//

import Foundation

class TabDetector {
    func detectTabs2( text: String, parseAlg: TabParseAlg) -> GuitarTab {
        let guitarTab = GuitarTab()
        var curPageCount = 0
        let utext = text.replacingOccurrences(of: "\r\n", with: "\n")
        let allLines = utext.components(separatedBy: "\n")//.map { $0.trimmingCharacters(in: .whitespaces) }
        if allLines.count < 2 {
            //print("not enough lines")
            return guitarTab
        }
        var curIndex = allLines.startIndex
        while curIndex < allLines.endIndex {
            if let checkGoodEndIndex = parseAlg.lastIndexThatLooksGood(slice: allLines[ curIndex...], checkIfGoodEndIndex: curIndex) {
                print("found from \(curIndex) to \(checkGoodEndIndex)")
                let pageSlice = allLines[curIndex...checkGoodEndIndex]
                //for psl in pageSlice {
                    //print(psl)
                //}
                if let p = parseAlg.parsePage(slice: pageSlice) {
                    curPageCount += 1
                    p.title = String.localizedStringWithFormat(NSLocalizedString("Tab %1$d", comment: "default title for a found tab"), curPageCount)
                    p.sourceStrings = [String](pageSlice)
                    guitarTab.pages.append( p)
                }
                curIndex = allLines.index(after: checkGoodEndIndex)
                continue
            }
            allLines.formIndex(after: &curIndex)
        } //wh
        return guitarTab
    }
} //struct

protocol TabParseAlg {
    func lastIndexThatLooksGood(slice: ArraySlice<String>, checkIfGoodEndIndex: Array<String>.Index) -> Array<String>.Index?
    func parsePage(slice: ArraySlice<String>) -> GuitarTab.Page?
}
