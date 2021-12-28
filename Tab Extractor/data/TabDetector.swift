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
    } //func
    func detectTabs3( in text: String, using parseAlg: TabParseAlg, splitMultipleOf: [Int]) -> GuitarTab? {
        let utext = text.replacingOccurrences(of: "\r\n", with: "\n")
        let allLines = utext.components( separatedBy: "\n")//.map { $0.trimmingCharacters(in: .whitespaces) }
        if allLines.count < 2 {
            //print("not enough lines")
            return nil
        }
        let resultTab = GuitarTab()
        var curPageCount = 0
        var curIndex = allLines.startIndex
        while curIndex < allLines.endIndex {
            if var checkGoodEndIndex = parseAlg.lastIndexThatLooksGood(slice: allLines[ curIndex...], checkIfGoodEndIndex: curIndex) {
                //print("found from \(curIndex) to \(checkGoodEndIndex)")
                let linesDif = (checkGoodEndIndex - curIndex + 1)
                for splitBy in splitMultipleOf {
                    if splitBy <= 1 {
                        continue
                    }
                    if (linesDif > splitBy) && (linesDif % splitBy == 0) {
                        checkGoodEndIndex = curIndex + splitBy - 1
                        break
                    }
                } //for
                let pageSlice = allLines[ curIndex...checkGoodEndIndex]
                if let p = parseAlg.parsePage( slice: pageSlice) {
                    curPageCount += 1
                    p.title = String.localizedStringWithFormat(NSLocalizedString("Tab %1$d", comment: "default title for a found tab"), curPageCount)
                    p.sourceStrings = [String](pageSlice)
                    resultTab.pages.append( p)
                }
                curIndex = allLines.index(after: checkGoodEndIndex)
                continue
            }
            allLines.formIndex(after: &curIndex)
        } //wh
        return resultTab
    } //func
} //class

protocol TabParseAlg {
    func lastIndexThatLooksGood(slice: ArraySlice<String>, checkIfGoodEndIndex: Array<String>.Index) -> Array<String>.Index?
    func parsePage(slice: ArraySlice<String>) -> GuitarTab.Page?
} //pro
