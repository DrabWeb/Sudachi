//
//  SCMusicBrowserDropView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-14.
//

import Cocoa

class SCMusicBrowserDropView: NSView {
    
    /// The target for dropAction
    var dropTarget : AnyObject? = nil;
    
    /// The selector to call when the user drops files into the view
    var dropAction : Selector? = nil;

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        // Register for dragging
        self.registerForDraggedTypes(NSArray(objects: NSFilenamesPboardType) as! [String]);
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        // Bring the app to the front
        NSApplication.sharedApplication().activateIgnoringOtherApps(true);
        
        return NSDragOperation.Every;
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.Every;
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        // If the drop target and action are set...
        if(dropTarget != nil && dropAction != nil) {
            // Perform the drop action
            dropTarget!.performSelector(dropAction!, withObject: sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as! [String]);
        }
        
        return true;
    }
}
