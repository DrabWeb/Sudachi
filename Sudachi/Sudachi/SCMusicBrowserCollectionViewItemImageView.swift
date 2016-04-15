//
//  SCMusicBrowserCollectionViewItemImageView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCMusicBrowserCollectionViewItemImageView: SCRasterizedImageView {
    
    /// Does this image view want an image?
    var wantsShadow : Bool = true;
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        super.drawLayer(layer, inContext: ctx);
        
        // If we want a shadow...
        if(wantsShadow) {
            // Show the shadow
            layer.shadowOpacity = 1;
        }
        // If we dont want a shadow...
        else {
            // Hide the shadow
            layer.shadowOpacity = 0;
        }
    }
}
