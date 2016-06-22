//
//  SCFileUtilities.swift
//  Sudachi
//
//  Created by Seth on 2016-04-08.
//

import Cocoa

class SCFileUtilities {
    /// Returns the path to the folder the given file is in(Keeps keep the / on the end)
    func folderPathForFile(path : String) -> String {
        // Remove the last path component(File name) of the given path from folderPath
        /// The path of the file's folder
        let folderPath : String = path.stringByReplacingOccurrencesOfString(NSString(string: path).lastPathComponent, withString: "");
        
        // Return the folder path
        return folderPath;
    }
    
    /// Is the given file an image?
    func isImage(path : String) -> Bool {
        // Return if the image file types contains the passed file's extension
        return NSImage.imageFileTypes().contains(NSString(string: path).lastPathComponent);
    }
    
    /// Is the given file a folder?
    func isFolder(path : String) -> Bool {
        // If the contents of the file at the given path arent nil(Meaning its a file)...
        if(NSFileManager.defaultManager().contentsAtPath(path) != nil) {
            // Return false
            return false;
        }
        // If the contents of the file at the given path are nil(Meaning its a folder)...
        else {
            // Return true
            return true;
        }
    }
}
