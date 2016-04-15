//
//  SCNowPlayingContainerView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCNowPlayingHoverView: NSView {
    
    // Always allow events
    override var acceptsFirstResponder : Bool {
        return true;
    }
    
    /// The target for enteredAction
    var enteredTarget : AnyObject? = nil;
    
    /// The selector to call when the mouse enters this view
    var enteredAction : Selector? = nil;
    
    /// The target for exitedAction
    var exitedTarget : AnyObject? = nil;
    
    /// The selector to call when the mouse exits this view
    var exitedAction : Selector? = nil;

    override func mouseEntered(theEvent: NSEvent) {
        // If the entered target and action aren't nil...
        if(enteredTarget != nil && enteredAction != nil) {
            // Perform the entered action
            enteredTarget!.performSelector(enteredAction!);
        }
    }
    
    override func mouseExited(theEvent: NSEvent) {
        // If the exited target and action aren't nil...
        if(exitedAction != nil && exitedTarget != nil) {
            // Perform the exited action
            exitedTarget!.performSelector(exitedAction!);
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Update the tracking areas
        self.updateTrackingAreas();
    }
    
    override func updateTrackingAreas() {
        // Remove the tracking are we added before
        self.removeTrackingArea(self.trackingAreas[0]);
        
        /// The same as the original tracking area, but updated to match the new view size
        let trackingArea : NSTrackingArea = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.addTrackingArea(trackingArea);
    }
    
    override func awakeFromNib() {
        /// The tracking are we will use for getting mouse entered and exited events
        let trackingArea : NSTrackingArea = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.addTrackingArea(trackingArea);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}
