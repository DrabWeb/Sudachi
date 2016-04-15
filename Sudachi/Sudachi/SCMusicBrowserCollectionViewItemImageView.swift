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
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow();
        
        // If we want a shadow...
        if(wantsShadow) {
            // Show the shadow
            self.layer!.shadowOpacity = 1;
        }
        // If we dont want a shadow...
        else {
            // Hide the shadow
            self.layer!.shadowOpacity = 0;
        }
    }
}
