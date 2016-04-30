//
//  GenreList.swift
//  BadFlix
//
//  Created by Sasmito Adibowo on 30/4/16.
//  Copyright © 2016 Basil Salad Software. All rights reserved.
//

import Foundation

private let genreListFileName = "GenreList.plist"

class GenreList {
    static let defaultInstance = GenreList()
    
    /// Mapping between ID and Genre, for the current language
    var currentMapping : Dictionary<Int64,GenreEntity>?
    
    
    
    func refresh(completionHandler: dispatch_block_t) {
        // TODO: refresh list of genres
    }
    
    required init() {
        let fileManager = NSFileManager.defaultManager()
        if let cachesDir = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first,
            genrePathString = cachesDir.URLByAppendingPathComponent(genreListFileName).path {
            if let dict = NSKeyedUnarchiver.unarchiveObjectWithFile(genrePathString) as? Dictionary<NSNumber,GenreEntity> {
                var ourDict = Dictionary<Int64,GenreEntity>()
                for (k,v) in dict {
                    ourDict[k.longLongValue] = v
                }
                self.currentMapping = ourDict
            }
        }
    }
    
    /// Save the genre list into folder
    func save() {
        guard let mapping = self.currentMapping else {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            let fileManager = NSFileManager.defaultManager()
            guard let cachesDir = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first,
                    genrePathString = cachesDir.URLByAppendingPathComponent(genreListFileName).path else {
                return
            }

            let serializedDict = NSMutableDictionary(capacity: mapping.count)
            for (k,v) in mapping {
                serializedDict.setObject(v, forKey: NSNumber(longLong: k))
            }
            NSKeyedArchiver.archiveRootObject(serializedDict, toFile: genrePathString)
        }
    }
}