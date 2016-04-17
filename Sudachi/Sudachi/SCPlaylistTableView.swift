//
//  SCPlaylistTableView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPlaylistTableView: NSTableView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func awakeFromNib() {
        // Add the observer for the playlist table view's selection change notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("selectionChanged:"), name: NSTableViewSelectionDidChangeNotification, object: nil);
    }
    
    /// The timer so playlist items get deselected after the selection doesnt change for 5 seconds
    var deselectTimer : NSTimer = NSTimer();
    
    /// When the playlist table view's selection changes...
    func selectionChanged(notification : NSNotification) {
        // If the notification object was this table view...
        if((notification.object as? SCPlaylistTableView) == self) {
            // Invalidate the current timer
            deselectTimer.invalidate();
            
            // Start a new timer for the deselect wait
            deselectTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(5), target: self, selector: Selector("deselectAllItems"), userInfo: nil, repeats: false);
        }
    }
    
    /// Deselects all the items for this table view
    func deselectAllItems() {
        // Deselect all the items
        self.deselectAll(self);
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        /// The index of the row that was right clicked
        let row : Int = self.rowAtPoint(self.convertPoint(theEvent.locationInWindow, fromView: nil));
        
        // Select the row the mouse is over
        self.selectRowIndexes(NSIndexSet(index: row), byExtendingSelection: false);
        
        // If the playlist has any items selected...
        if(self.selectedRow != -1) {
            /// The SCPlaylistTableCellView at the right clicked row index
            let cellAtSelectedRow : SCPlaylistTableCellView = (self.rowViewAtRow(row, makeIfNecessary: false)!.subviews[0] as! SCPlaylistTableCellView);
            
            // Display the right click menu for the row
            NSMenu.popUpContextMenu(cellAtSelectedRow.menuForEvent(theEvent)!, withEvent: theEvent, forView: cellAtSelectedRow);
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        /// The index of the row that was clicked
        let row : Int = self.rowAtPoint(self.convertPoint(theEvent.locationInWindow, fromView: nil));
        
        // Click the row the cursor is above
        (self.rowViewAtRow(row, makeIfNecessary: false)?.subviews[0] as! SCPlaylistTableCellView).mouseDown(theEvent);
    }
    
    // Override the alternate row colors
    private func alternateBackgroundColor() -> NSColor? {
        self.superview?.superview?.superview?.layer?.backgroundColor = SCThemingEngine().defaultEngine().playlistSecondAlternatingColor.CGColor;
        return SCThemingEngine().defaultEngine().playlistFirstAlternatingColor;
    }
    
    internal override func drawBackgroundInClipRect(clipRect: NSRect) {
        // http://stackoverflow.com/questions/3973841/change-nstableview-alternate-row-colors
        // Refactored
        if(alternateBackgroundColor() == nil) {
            // If we didn't set the alternate color, fall back to the default behaviour
            super.drawBackgroundInClipRect(clipRect);
        }
        else {
            // Fill in the background color
            self.backgroundColor.set();
            NSRectFill(clipRect);
            
            // Check if we should be drawing alternating colored rows
            if(usesAlternatingRowBackgroundColors) {
                // Set the alternating background color
                alternateBackgroundColor()!.set();
                
                // Go through all of the intersected rows and draw their rects
                var checkRect = bounds;
                checkRect.origin.y = clipRect.origin.y;
                checkRect.size.height = clipRect.size.height;
                let rowsToDraw = rowsInRect(checkRect);
                var curRow = rowsToDraw.location;
                repeat {
                    if curRow % 2 != 0 {
                        // This is an alternate row
                        var rowRect = rectOfRow(curRow);
                        rowRect.origin.x = clipRect.origin.x;
                        rowRect.size.width = clipRect.size.width;
                        NSRectFill(rowRect);
                    }
                    
                    curRow++;
                } while curRow < rowsToDraw.location + rowsToDraw.length;
                
                // Figure out the height of "off the table" rows
                var thisRowHeight = rowHeight;
                if gridStyleMask.contains(NSTableViewGridLineStyle.SolidHorizontalGridLineMask)
                    || gridStyleMask.contains(NSTableViewGridLineStyle.DashedHorizontalGridLineMask) {
                        thisRowHeight += 2.0; // Compensate for a grid
                }
                
                // Draw fake rows below the table's last row
                var virtualRowOrigin = 0.0 as CGFloat;
                var virtualRowNumber = numberOfRows;
                if(numberOfRows > 0) {
                    let finalRect = rectOfRow(numberOfRows-1);
                    virtualRowOrigin = finalRect.origin.y + finalRect.size.height;
                }
                repeat {
                    if virtualRowNumber % 2 != 0 {
                        // This is an alternate row
                        let virtualRowRect = NSRect(x: clipRect.origin.x, y: virtualRowOrigin, width: clipRect.size.width, height: thisRowHeight);
                        NSRectFill(virtualRowRect);
                    }
                    
                    virtualRowNumber++;
                    virtualRowOrigin += thisRowHeight;
                } while virtualRowOrigin < clipRect.origin.y + clipRect.size.height;
                
                // Draw fake rows above the table's first row
                virtualRowOrigin = -1 * thisRowHeight;
                virtualRowNumber = -1;
                repeat {
                    if(abs(virtualRowNumber) % 2 != 0) {
                        // This is an alternate row
                        let virtualRowRect = NSRect(x: clipRect.origin.x, y: virtualRowOrigin, width: clipRect.size.width, height: thisRowHeight);
                        NSRectFill(virtualRowRect);
                    }
                    
                    virtualRowNumber--;
                    virtualRowOrigin -= thisRowHeight;
                } while virtualRowOrigin + thisRowHeight > clipRect.origin.y;
            }
        }
    }
}