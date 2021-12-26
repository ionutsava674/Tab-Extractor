//
//  TabSharer.swift
//  Tab Extractor
//
//  Created by Ionut on 14.06.2021.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    typealias SSCallback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [Any]
    let appActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: SSCallback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: self.activityItems, applicationActivities: self.appActivities)
        controller.excludedActivityTypes = self.excludedActivityTypes
        controller.completionWithItemsHandler = self.callback
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        //
    }
    }
