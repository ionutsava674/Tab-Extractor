//
//  SelectableItem.swift
//  Tab Extractor
//
//  Created by Ionut on 17.06.2021.
//

import Foundation

class SelectableItem<ContainedType>: Identifiable, ObservableObject {
    var id = UUID()
    var mainItem: ContainedType
    fileprivate( set) var selected: Bool = false
    init( mainItem: ContainedType) {
        id = UUID()
        self.mainItem = mainItem
        selected = false
    }
} //item

class SelectableItemContainer<ItemType, ContainedType>: ObservableObject
where ItemType: SelectableItem<ContainedType> {
    @Published var items: [ItemType]
    var selectedCount: Int {
        items.reduce(0) { csc, mspi in
                mspi.selected ? csc + 1 : csc
            }
    } //var
    var allSelected: Bool {
        selectedCount == items.count
    }
    
    init( sourceItems: [ContainedType], itemConstruction: (ContainedType) -> ItemType) {
        var itemCounter = 0
        //items = []
        items = sourceItems.map({ gp in
            itemCounter += 1
            return itemConstruction(gp)
        })
    }
    func setSelected(item: ItemType, value: Bool) -> Void {
        objectWillChange.send()
        item.selected = value
    }
} //container
////////
