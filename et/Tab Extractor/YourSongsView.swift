//
//  YourSongsView.swift
//  Tab Extractor
//
//  Created by Ionut on 23.06.2021.
//

import SwiftUI

struct YourSongsView: View {
        @State private var showingNewTabUrl = false
        @State private var ssl = false
        @State private var docFiles = [TabFileAssoc]()
        @State private var docFilesFiltered: [TabFileAssoc] = []
        @State private var searchFilter = ""
        @State private var filterCount = 0
        
        func filter(_ cfc: Int) -> Void {
            guard cfc == filterCount else {
                return
            }
            guard !searchFilter.isEmpty else {
                docFilesFiltered = docFiles
                return
            }
            docFilesFiltered = docFiles.filter { tfa in
                tfa.tab.title.lowercased().contains(searchFilter.lowercased())
            }
        }
        var body: some View {
            let filterBind = Binding<String> {
                searchFilter
            } set: { newVal in
                searchFilter = newVal
                filterCount += 1
                filterCount %= 1000
                let cfc = filterCount
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    filter( cfc)
                }
            }

            return NavigationView {
            VStack {
                TextField(NSLocalizedString("search", comment: "main window search filter caption"), text: filterBind)
                List {
                ForEach(docFilesFiltered, id: \.fileUrl) {tfa in
                    NavigationLink(tfa.tab.title, destination:
                                    MainTabViewer(tab: tfa.tab)
                                   )
                    .font(.headline)
                } //fe
                .onDelete(perform: deleteItems)
                } //ls
                .onAppear(perform: {
                    //listDocFiles()
                })
                Button(NSLocalizedString("Refresh", comment: "main window list refresh button")) {
                    //ssl = true
                    listDocFiles()
                }
                Button(NSLocalizedString("Add from web", comment: "main window add button")) {
                    showingNewTabUrl = true
                }
                .accessibility(hint: Text(NSLocalizedString("opens browser", comment: "main window add button hint")))
            } //vs
            .navigationTitle(lclz.yourSavedSongs)
            .navigationBarItems(trailing: EditButton() )
            .sheet(isPresented: $ssl, content: {
                StrongListView()
            })
            .sheet(isPresented: $showingNewTabUrl, content: {
                NewTabUrlContent(initialAddress:
                                    "https://tabs.ultimate-guitar.com/tab/misc-television/formula-1-theme-tabs-2640351"
                                     // "https://www.google.com/"
                                    // "https://www.bigbasstabs.com/misc_bass_tabs/amazing_grace_bass_tab.html"
                                    // "https://www.google.com/search?q=amazing+grace+bass+tab&source=hp&ei=Gve8YOuWCsGMlwSjsKWgDQ&oq=amazing+grace+bass+tab&gs_lcp=ChFtb2JpbGUtZ3dzLXdpei1ocBADMgIIADIGCAAQFhAeMgYIABAWEB4yBggAEBYQHjIGCAAQFhAeMgYIABAWEB4yBggAEBYQHjoCCCk6EQguELEDEIMBEMcBEKMCEJMCOggIABCxAxCDAToFCAAQsQM6DgguELEDEIMBEMcBEK8BOgsILhCxAxDHARCjAjoICC4QsQMQgwE6CAguEMcBEK8BOgUILhCxAzoOCC4QsQMQgwEQxwEQowI6AgguOgcIABCxAxAKOgQIABAKOgsILhCxAxCDARCTAjoNCC4QsQMQgwEQDRCTAjoECAAQDVCwQFiwyQFg2tIBaAFwAHgAgAH4AYgBlxqSAQYwLjIwLjOYAQCgAQGwAQE&sclient=mobile-gws-wiz-hp"
                                    , browseAutomatically: true)
        })
            } //nv
        } //body
        func deleteItems(indices: IndexSet) -> Void {
            for index in indices {
                let tfa = docFilesFiltered[index]
                try? FileManager.default.removeItem( at: tfa.fileUrl)
            }
            listDocFiles()
        }
        func listDocFiles() -> Void {
            self.docFiles = []
            let du = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            do {
                let fl = try FileManager.default.contentsOfDirectory(at: du[0], includingPropertiesForKeys: nil, options: [])
                for u in fl {
                    guard u.pathExtension.lowercased() == TabFileAssoc.defaultFileExtension.lowercased() else {
                        continue
                    }
                    if let tfa = TabFileAssoc.getFromFile(fileUrl: u) {
                        self.docFiles.append(tfa)
                    } else {
                        //print("no good file")
                    }
                } //for
            } catch {
                //
            }
            self.filter(self.filterCount)
        } //func
    } //struct
