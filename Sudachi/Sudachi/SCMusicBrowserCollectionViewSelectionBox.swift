//
//  SCCollectionViewSelectionBox.swift
//  Sudachi
//
//  Created by Seth on 2016-04-07.
//

import Cocoa

class SCMusicBrowserCollectionViewSelectionBox: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        // Get a layer
        self.wantsLayer = true;
        
        // Set the background color
        self.layer?.backgroundColor = SCThemingEngine().defaultEngine().musicBrowserSelectionColor.CGColor;
        
        // Set the corner radius
        self.layer?.cornerRadius = SCThemingEngine().defaultEngine().musicBrowserSelectionBoxCornerRadius;
    }
}
