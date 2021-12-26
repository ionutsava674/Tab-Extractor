//
//  ContentView.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var mainTabSelection = 1
    
    var body: some View {
        TabView(selection: $mainTabSelection,
                content:  {
                    YourSongsView()
                        .tabItem {
                            Text(LCLZ.yourSavedSongs)
                        }
                        .tag(1)
                    
                    PreferencesView()
                        .tabItem {
                            Text(LCLZ.preferencesTab)
                        }
                        .tag(2)
                }) //tv
    } //body
} //str
