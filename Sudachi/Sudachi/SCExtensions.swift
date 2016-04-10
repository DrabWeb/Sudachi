//
//  SCExtensions.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

extension NSImage {
    /// Masks the first image with the second and returns the result
    func maskWith(withImage : NSImage) -> NSImage {
        /// The masked image
        let result : NSImage = self.copy() as! NSImage;
        
        /// A clone of withImage
        let withImageClone : NSImage = withImage.copy() as! NSImage;
        
        // Set the size of the mask to the result size
        withImageClone.size = result.size;
        
        // Lock drawing focus on the result
        result.lockFocus();
        
        // Mask the result image to the mask image
        withImageClone.drawAtPoint(NSMakePoint(0, 0), fromRect: NSRect(x: 0, y: 0, width: result.size.width, height: result.size.height), operation: NSCompositingOperation.CompositeDestinationIn, fraction: 1);
        
        // Unlock drawing focus
        result.unlockFocus();
        
        // Return the result
        return result;
    }
}