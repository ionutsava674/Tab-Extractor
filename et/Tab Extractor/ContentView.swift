//
//  ContentView.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(selection: .constant(1),
                content:  {
                    YourSongsView()
                        .tabItem {
                            Text(lclz.yourSavedSongs)
                        }
                        .tag(1)
                    Text("Tab Content 2")
                        .tabItem {
                            Text("Tab Label 2")
                        }
                        .tag(2)
                })
    }
}
