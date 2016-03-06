//
//  ItemManager.swift
//  IdleCost
//
//  Created by David Chu on 3/6/16.
//  Copyright © 2016 David Chu. All rights reserved.
//

import Foundation

class ItemManager {
    var itemList = [CostCalcItem]()
    
    func archivePath() -> String? {
        let directoryList = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        if let documentsPath = directoryList.first {
            return documentsPath + "/IdleCost"
        }
        assertionFailure("Could not determine where to store files")
        return nil
    }
    
    func save() {
        if let theArchivePath = archivePath() {
            if NSKeyedArchiver.archiveRootObject(itemList, toFile: theArchivePath) {
                print("Saved successfully")
            } else {
                assertionFailure("Could not save")
            }
        }
    }
    
    func unArchive() {
        if let theArchivePath = archivePath() {
            if NSFileManager.defaultManager().fileExistsAtPath(theArchivePath) {
                itemList = NSKeyedUnarchiver.unarchiveObjectWithFile(theArchivePath) as! [CostCalcItem]
            }
        }
    }
    
    init() {
        unArchive()
    }
}