//
//  PList.swift
//  PList
//
//  Created by Cody on 3/20/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import Foundation

struct Plist {
    //1
    enum PlistError: Error {
        case FileNotWritten
        case FileDoesNotExist
    }
    //2
    let name:String
    //3
    var sourcePath:String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }
    //4
    var destPath:String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("directory: \(dir)")
        return (dir as NSString).appendingPathComponent("\(name).plist")
    }
    
    // Initializer
    
    init?(name:String) {
        //1
        self.name = name
        //2
        let fileManager = FileManager.default
        //3
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }
        //4
        if !fileManager.fileExists(atPath: destination) {
            //5
            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    // Methods to work with data
    
    //1
    func getValuesInPlistFile() -> NSDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
    //2
    func getMutablePlistFile() -> NSMutableDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
    //3
    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            if !dictionary.write(toFile: destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
    
    func saveFile() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["myLists"] = myLists
            dict["BusinessList"] = BusinessList
            dict["checkedBusinesses"] = checkedBusinesses
            dict["favoritesList"] = favoritesList
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
                print("File Saved")
            } catch {
                print(error)
            }
            
        } else {
            print("Unable to get Plist")
        }
    }
}


