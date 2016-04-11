//
//  SCMusicBrowserCollectionViewItem.swift
//  Sudachi
//
//  Created by Seth on 2016-04-07.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCMusicBrowserCollectionViewItem: NSCollectionViewItem {
    
    /// The object to perform openAction
    var openTarget : AnyObject? = nil;
    
    /// The selector to call when this item is opened(When called it also passes this item's SCMusicBrowserItem)
    var openAction : Selector? = nil;
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        // If we double clicked...
        if(theEvent.clickCount == 2) {
            // Open this item
            open();
        }
    }
    
    /// Opens this item
    func open() {
        // If the target and action are set...
        if(openTarget != nil && openAction != nil) {
            // Perform the open action
            openTarget!.performSelector(openAction!, withObject: self.representedObject as! SCMusicBrowserItem);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Load the theme
        loadTheme();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the label colors
        self.textField?.textColor = SCThemingEngine().defaultEngine().musicBrowserItemTextColor;
        
        // Set the fonts
        self.textField?.font = SCThemingEngine().defaultEngine().setFontFamily((self.textField?.font!)!, size: SCThemingEngine().defaultEngine().musicBrowserItemTitleFontSize);
    }
}
