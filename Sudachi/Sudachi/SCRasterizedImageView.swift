//
//  SCRasterizedImageView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-08.
//

import Cocoa

class SCRasterizedImageView: NSImageView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Rasterize the layer
        self.layer?.shouldRasterize = true;
    }
}