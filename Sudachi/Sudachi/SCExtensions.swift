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
        
        // Set the sizes of the images so we dont get compression or anything like that
        result.size = result.pixelSize;
        withImageClone.size = result.pixelSize;
        
        // Lock drawing focus on the result
        result.lockFocus();
        
        // Mask the result image to the mask image
        withImageClone.drawAtPoint(NSMakePoint(0, 0), fromRect: NSRect(x: 0, y: 0, width: result.size.width, height: result.size.height), operation: NSCompositingOperation.CompositeDestinationIn, fraction: 1);
        
        // Unlock drawing focus
        result.unlockFocus();
        
        // Return the result
        return result;
    }
    
    /// The pixel size of this image
    var pixelSize : NSSize {
        /// The NSBitmapImageRep to this image
        let imageRep : NSBitmapImageRep = (NSBitmapImageRep(data: self.TIFFRepresentation!))!;
        
        /// The size of this iamge
        let imageSize : NSSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh);
        
        // Return this image's size
        return imageSize;
    }
}