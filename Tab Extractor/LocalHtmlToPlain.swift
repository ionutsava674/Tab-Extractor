//
//  LocalHtmlToPlain.swift
//  Tab Extractor
//
//  Created by Ionut on 31.05.2021.
//

import Foundation
import UIKit

class UrlExtractor: ObservableObject {
    var srcUrl = ""
    private var reqId = 0
    @Published var plainText = ""
    @Published var aborted = 0
    @Published var succeeded = 0
    @Published var failed = 0
    func extract(srcUrl: String) -> Bool {
        guard let url = URL(string: srcUrl) else {
            return false
        }
        reqId += 1
        self.srcUrl = srcUrl
        let withReq = self.reqId
        URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data else {
                self.failed += 1
                return
            }
                DispatchQueue.main.async {
                    if withReq == self.reqId {
                        self.succeeded += 1
                        guard let nsa = data.htmlToNSAttributedString else {
                            self.failed += 1
                            return
                        }
                        self.plainText = String(data.count) + " " + String(nsa.length) + " " + nsa.string
                    } else {
                        self.aborted += 1
                    }
                } //async
        }.resume()
        return true
    }
}

extension Data {
    var htmlToNSAttributedString: NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return try? NSAttributedString(data: self, options: options, documentAttributes: nil)
    }
}
