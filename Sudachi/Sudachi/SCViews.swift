//
//  SCPopUpButton.swift
//  Sudachi
//
//  Created by Seth on 2016-04-17.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPopUpButton: NSPopUpButton {
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Set the title colors and fonts
        setMenuItemsTitleColorsAndFonts();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        // Set the title colors and fonts
        setMenuItemsTitleColorsAndFonts();
    }
    
    /// Sets the color of the label of each menu item for this popup button to the control text color and sets the fonts
    func setMenuItemsTitleColorsAndFonts() {
        // Set the popup button's font
        self.font = SCThemingEngine().defaultEngine().setFontFamily(self.font!, size: SCThemingEngine().defaultEngine().controlTextFontSize);
        
        // For every menu item...
        for(_, currentMenuItem) in self.menu!.itemArray.enumerate() {
            /// The attributed title
            let attributedTitle = NSMutableAttributedString(string: currentMenuItem.title, attributes: [NSFontAttributeName: NSFont.systemFontOfSize(self.font!.pointSize), NSForegroundColorAttributeName: SCThemingEngine().defaultEngine().controlTextColor, NSFontFamilyAttribute: self.font!.familyName!]);
            
            // Set the title
            currentMenuItem.attributedTitle = attributedTitle;
        }
    }
}

class SCPopUpButtonCell: NSPopUpButtonCell {
    override func drawBorderAndBackgroundWithFrame(cellFrame: NSRect, inView controlView: NSView) {
        /// The bounds of the NSPopUpButton for this cell
        var controlBounds : NSRect = (self.controlView as! NSPopUpButton).bounds;
        
        // Fix the bounds so we draw the control background the same size as it would regularly
        controlBounds = NSRect(x: controlBounds.origin.x, y: controlBounds.origin.y + 3, width: controlBounds.width, height: controlBounds.height - 7);
        
        // Set the fill color
        SCThemingEngine().defaultEngine().controlBackgroundColor.setFill();
        
        /// The bezier path to fill in the background of the cell
        let backgroundPath : NSBezierPath = NSBezierPath(roundedRect: controlBounds, xRadius: 3, yRadius: 3);
        
        // Fill the background
        backgroundPath.fill();
    }
    
    override func drawInteriorWithFrame(cellFrame: NSRect, inView controlView: NSView) {
        // Adjust the interior size so it fits with our custom drawing
        super.drawInteriorWithFrame(NSRect(x: cellFrame.origin.x - 3, y: cellFrame.origin.y, width: cellFrame.width, height:cellFrame.height), inView: controlView);
    }
}

class SCButton: NSButton {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Set the title color and font
        setTitleColorAndFont();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        // Set the title color and font
        setTitleColorAndFont();
    }
    
    /// Sets the color of the button's title to the control text color and the font family
    func setTitleColorAndFont() {
        // Set the font
        self.font = SCThemingEngine().defaultEngine().setFontFamily(self.font!, size: SCThemingEngine().defaultEngine().controlTextFontSize);
        
        /// The title's paragraph style
        let titleParagraphStyle = NSMutableParagraphStyle();
        
        // Set the alignment to the button's title aligment
        titleParagraphStyle.alignment = self.alignment;
        
        /// The attributed title
        let attributedTitle = NSMutableAttributedString(string: self.title, attributes: [NSFontAttributeName: NSFont.systemFontOfSize(self.font!.pointSize), NSParagraphStyleAttributeName: titleParagraphStyle, NSForegroundColorAttributeName: SCThemingEngine().defaultEngine().controlTextColor, NSFontFamilyAttribute: self.font!.familyName!]);
            
        // Set the title
        self.attributedTitle = attributedTitle;
    }
}

class SCButtonCell: NSButtonCell {
    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView) {
        /// The frame that was passed, adjusted to be sized properly
        let adjustedFrame : NSRect = NSRect(x: frame.origin.x + 7, y: frame.origin.y + 5, width: frame.width - 14, height: frame.height - 13);
        
        // Set the fill color
        SCThemingEngine().defaultEngine().controlBackgroundColor.setFill();
        
        /// The bezier path to fill in the background of the cell
        let backgroundPath : NSBezierPath = NSBezierPath(roundedRect: adjustedFrame, xRadius: 3, yRadius: 3);
        
        // Fill the background
        backgroundPath.fill();
    }
}
