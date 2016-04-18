//
//  SCPreferencesObject.swift
//  Sudachi
//
//  Created by Seth on 2016-04-18.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPreferencesObject: NSObject, NSCoding {
    
    /// The path to the chosen theme(If blank its the default theme)
    var themePath : String = "";
    
    func encodeWithCoder(coder: NSCoder) {
        // Encode the preferences
        coder.encodeObject(themePath, forKey: "themePath");
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        // Decode and load the preferences
        if((decoder.decodeObjectForKey("themePath") as? String?) != nil) {
            self.themePath = (decoder.decodeObjectForKey("themePath") as! String?)!;
        }
    }
}
