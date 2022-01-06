//
//  AnyContainerView.swift
//  Tab Extractor
//
//  Created by Ionut on 05.01.2022.
//

import SwiftUI

struct AnyContainerView<ContentType, PassType>: View where ContentType: View {
        var objectToPass: PassType
        var content: (PassType) -> ContentType
        var body: some View {
                content(objectToPass)
        } //body
    } //str

struct AnyContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AnyContainerView(objectToPass: 0) { arg in
            Text("here")
        }
    }
}

