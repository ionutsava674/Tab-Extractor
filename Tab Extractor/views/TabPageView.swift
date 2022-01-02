//
//  TabPageView.swift
//  Tab Extractor
//
//  Created by Ionut on 04.06.2021.
//

import SwiftUI

class SelectablePage: SelectableItem<GuitarTab.Page> {
    var titleModified = false
    var title: String {
        get { mainItem.title}
        set {
            objectWillChange.send()
            mainItem.title = newValue
        }
    } //cv
    //@Published var title = ""
} //class
struct MSIView: View {
    @ObservedObject var item: SelectablePage
    @ObservedObject var listContainer: SelectableItemContainer<SelectablePage, GuitarTab.Page>
    @State private var contentCollapsed = false
    @State private var isEditing2 = false
    @State private var editingValue2 = ""
    @State private var editOKayed = false
    
    func startEditingTitle() -> Void {
        editOKayed = false
        editingValue2 = item.title
        isEditing2 = true
    }
    func doneEditingTitle() -> Void {
        if editOKayed {
            item.title = editingValue2
            item.titleModified = true
            listContainer.objectWillChange.send()
            editOKayed = false
        }
    }
    //func woabody(sb: Binding<Bool>) -> some View {
        //Color.red
    //} //woafunc
    var body: some View {
        let sb = Binding<Bool> {
            item.selected
        } set: {
            listContainer.setSelected(item: item, value: $0)
        } //binding
        return
//                woabody(sb: sb)
            //Section( header:
            VStack(alignment: .leading, spacing: nil, content: {
                HStack {
                    Text(String.localizedStringWithFormat(NSLocalizedString("%1$@ (%2$d lines)", comment: "item title to display after it was detected"), item.title, item.mainItem.displayableLines.count))
                        //.padding(.horizontal)
                                    .font(.title)
                               .accessibility(value: Text(item.selected ? NSLocalizedString("selected", comment: "selectable item is selected") : NSLocalizedString("not selected", comment: "selectable item is not selected")))
                    Spacer()
                    Button(NSLocalizedString("Edit", comment: "button caption for selectable item edit title")) {
                        startEditingTitle()
                    }
                    .accessibilityHidden(true)
                } //hs
                            AccessibleCheckBox( checked: sb, caption: item.selected ? NSLocalizedString("selected", comment: "selectable item is selected") : NSLocalizedString("not selected", comment: "selectable item is not selected"))
                                .font(.headline)
                                .accessibility(hidden: true)
                                .padding(2)
                Text(String.localizedStringWithFormat(self.contentCollapsed ? NSLocalizedString("expand %1$@", comment: "expand item lines caption") : NSLocalizedString("collapse %1$@", comment: "collapse item lines"), item.title))
                    .padding(4)
                                .font(.headline)
                                .accessibility(hidden: true)
                                        .onTapGesture(perform: {
                                            self.contentCollapsed.toggle()
                                        })
                                if !self.contentCollapsed {
                                ForEach(item.mainItem.displayableLines, id: \.self) { line in
                        Text(line)
                    } //fe
                                } //if
            }) //mainsect

            .accessibilityAction(named: String.localizedStringWithFormat(self.contentCollapsed ? NSLocalizedString("expand %1$@", comment: "expand item lines caption") : NSLocalizedString("collapse %1$@", comment: "collapse item lines"), item.title), {
                    self.contentCollapsed.toggle()
                })
            .accessibilityAction(named: String.localizedStringWithFormat(item.selected ? NSLocalizedString("deselect %1$@", comment: "deselect item accessibility action") : NSLocalizedString("select %1$@", comment: "select item accessibility action"), item.title), {
                    sb.wrappedValue.toggle()
                })
            .accessibilityAction(named: String.localizedStringWithFormat(NSLocalizedString("edit title for %1$@", comment: "edit title accessibility action"), item.title),
                                         startEditingTitle)
                    .sheet(isPresented: $isEditing2, onDismiss: doneEditingTitle, content: {
                        EditValueView(editTitle: NSLocalizedString("enter new title", comment: "enter new title prompt for tab item"),
                                      editValue: $editingValue2,
                                      editOKayed: $editOKayed)
                    })
    } //body
} //view

struct TabPageView: View {
    let enableDebug = true
    let sourceTab: GuitarTab

    @Environment(\.presentationMode) var premo
    
    @ObservedObject private var selectableItems: SelectableItemContainer<SelectablePage, GuitarTab.Page>

    @State private var showingSaveMenu = false
    @State private var showingSaveAs1 = false
    @State private var showingSaveConfirm = false
    @State private var saveConfirmMsg = ""
    @State private var genAlertMsg = ""
    @State private var genAlertVisible = false
    
    init(srcTab: GuitarTab) {
        //self.pages = pages
        self.sourceTab = srcTab
        //var pageCounter = 0
        self.selectableItems = SelectableItemContainer(sourceItems: sourceTab.pages, itemConstruction: { page in
            //pageCounter += 1
            let rv = SelectablePage(mainItem: page)
            //rv.title =
            return rv
        })
    } //init
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10, content: {
                HStack {
                    Button(NSLocalizedString("back", comment: "back button for web search results page window")) {
                        self.premo.wrappedValue.dismiss()
                    } //btn
                    .padding(.horizontal)
                    Spacer()
                    saveButton
                        .padding(.horizontal)
                        .fullScreenCover(isPresented: $showingSaveAs1, content: {
                            Save1Song(TabSELContainer: self.selectableItems, fromTab: self.sourceTab)
                        }) //pop
                        .actionSheet(isPresented: self.$showingSaveMenu, content: { saveActionSheet }) //asheet
                } //hs
                .font(.title)
                Text("Title: \(self.sourceTab.title)")
                    .font(.title.bold())
                    .lineLimit(1)
                    .padding(.horizontal)
                Text(NSLocalizedString("Select the tabs you want to save, from the list below.", comment: "info static text"))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Form {
                    Section(header:
                selectAllButton
                                .font(.headline)
                    ) {
                ForEach(selectableItems.items) { msi in
                    MSIView(item: msi, listContainer: self.selectableItems)
                } //fe
            } //ls
                    //.frame(maxWidth: .infinity)
                } //sv
            //.listStyle(GroupedListStyle())
                if enableDebug {
                HStack {
                    Spacer()
                    Button("print info") {
                        print(self.sourceTab.sourceUrl ?? "no url")
                        for ip in self.sourceTab.pages {
                            print(ip.title)
                            let ss = ip.sourceStrings
                                for ipl in ss {
                                    print(ipl)
                                }
                            //}
                        }
                    } //b1
                    Button("share info") {
                        var sha = [String]()
                        sha.append(self.sourceTab.sourceUrl ?? "no url")
                        sha.append(self.sourceTab.title)
                        for ip in self.sourceTab.pages {
                            sha.append(ip.title)
                            let ss = ip.sourceStrings
                                for ipl in ss {
                                    sha.append(ipl)
                                }
                            //}
                        }
                        //shareString(sha.joined(separator: "\n"))
                    } //b1
                } //hs
                } //if
            }) //vs
            .navigationTitle(String.localizedStringWithFormat(NSLocalizedString("%1$d tabs detected", comment: "search results window title"), selectableItems.items.count))
            .alert(isPresented: $genAlertVisible, content: {
                Alert(title: Text(genAlertMsg))
            }) //alert
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingSaveConfirm, content: {
            Alert(title: Text(saveConfirmMsg),
                  primaryButton: Alert.Button.default(Text(NSLocalizedString("Save like this", comment: "save button confirmation")), action: {
                    DispatchQueue.main.async {
                        saveSepAction( continueWithUnrenamed: true)
                    } //q
                  }), //b
                  secondaryButton: Alert.Button.cancel())
        }) //alert
    } //body
    
    /*
    func shareString(_ sharedString: String) -> Void {
        guard !sharedString.isEmpty else {
            return
        }
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            //UIWindowScene.window
            return
        }
        let av = UIActivityViewController(activityItems: [sharedString], applicationActivities: nil)
        if let popOverController = av.popoverPresentationController {
            popOverController.sourceView = source.view
            popOverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                                  y: source.view.bounds.midY,
                                                  width: .zero, height: .zero)
            popOverController.permittedArrowDirections = []
        }
        source.present(av, animated: true, completion: nil)
        //UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: {
            //print("shared")
        //})
    } //func
*/
    var saveButton: some View {
        let b = Button(NSLocalizedString("Save", comment: "main save button caption"), action: {
            if self.selectableItems.selectedCount == 1 {
                save1Action()
                return
            }
            self.showingSaveMenu = true
        }) //btn
        .disabled( self.selectableItems.selectedCount == 0)
        .accessibilityAction(named: save1Caption(), {
            save1Action()
        })
        .accessibilityAction(named: saveSepCaption()) {
            saveSepAction(continueWithUnrenamed: false)
        }
        return b
    } //savebtn
    var saveActionSheet: ActionSheet {
        let b1 = ActionSheet.Button.default( Text( save1Caption()), action: {
            save1Action()
                                    })
        let b2 = ActionSheet.Button.default(Text(saveSepCaption()), action: {
            saveSepAction(continueWithUnrenamed: false)
        })
        let cb = ActionSheet.Button.cancel()
        return ActionSheet(title: Text(NSLocalizedString("How do you wish to save?", comment: "save action confirmation prompt")),
                           message: nil,
                           buttons: [ b1, b2, cb] )
    }

    func saveSepAction( continueWithUnrenamed: Bool) -> Void {
        let sc = self.selectableItems.selectedCount
        guard sc > 0 else {
            return
        }
        if sc == 1 {
            if let _ = selectableItems.items.first(where: { item in
                item.selected && !item.titleModified
            }) {
                save1Action()
                return
            }
        }
        if !continueWithUnrenamed {
        let unRenamed = self.selectableItems.items.filter { item in
            item.selected && !item.titleModified
        }
        if !unRenamed.isEmpty {
            //alert
            let lst = (unRenamed.map { item in
                item.title
            }).joined(separator: ",\n")
            confirmSaveAlert( msg: String.localizedStringWithFormat(NSLocalizedString("The following tabs were not renamed:\n%1$@.\nDo you wish to continue?", comment: "save alert confirmation message"), lst))
            return
        } //if not empty
        } //if cont
        let toSave = self.selectableItems.items.filter({ item in
            item.selected
        })
        var savedCount = 0
        var unableToSave: [SelectablePage] = []
        for item in toSave {
                let tts = GuitarTab()
                tts.pages.append( item.mainItem)
                tts.title = item.title
            if let _ = TabFileAssoc.saveTab(tab: tts) {
                savedCount += 1
            } else {
                unableToSave.append( item)
            }
        } //for
        if unableToSave.isEmpty {
            generalAlert( msg: String.localizedStringWithFormat(NSLocalizedString("%1$d tabs saved successfully.", comment: "general alert notification message"), savedCount))
        } else {
            let lst = unableToSave.map({ $0.title }).joined(separator: "\n")
            generalAlert(msg: String.localizedStringWithFormat(NSLocalizedString("Unknown error occurred.\nThe following tabs could not be saved:\n%1$@", comment: "general alert notification"), lst))
        }
    } //func
    func generalAlert( msg: String) -> Void {
        genAlertMsg = msg
        genAlertVisible = true
    }
    func confirmSaveAlert( msg: String) -> Void {
        saveConfirmMsg = msg
        showingSaveConfirm = true
    }
    func save1Action() -> Void {
        let sc = self.selectableItems.selectedCount
        guard sc > 0 else {
            return
        }
        if sc == 1 {
            if let _ = selectableItems.items.first(where: { item in
                item.selected && item.titleModified
            }) {
                saveSepAction( continueWithUnrenamed: false)
                return
            }
        }
        showingSaveAs1 = true
    }
    func saveSepCaption() -> String {
        let sc = self.selectableItems.selectedCount
        if sc < 2 {
            return save1Caption()
        }
        return String.localizedStringWithFormat(NSLocalizedString("save %1$d tabs as separate songs", comment: "save button caption"), sc)
    }
    func save1Caption() -> String {
        let sc = self.selectableItems.selectedCount
        switch sc {
        case 0:
            return NSLocalizedString("Can't save", comment: "cant save button caption")
        case 1:
            let si = selectableItems.items.first { item in
                item.selected == true
            }
            return String.localizedStringWithFormat(NSLocalizedString("Save %1$@", comment: "save button caption"), si?.title ?? "song")
        default:
            return String.localizedStringWithFormat(NSLocalizedString("Save %1$d tabs as one song", comment: "save 2 tabs as...btn caption"), sc)
        }
    } //func
    var selectAllButton: some View { Button(selectableItems.allSelected ?
                                                NSLocalizedString("deSelect all", comment: "deSelect all button") :
                                                NSLocalizedString("select all", comment: "select all button")) {
        let doSelectAll = !self.selectableItems.allSelected
        self.selectableItems.items.forEach { item in
            self.selectableItems.setSelected(item: item, value: doSelectAll)
        }
    } //btn
    }
} //st
