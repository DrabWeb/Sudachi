//
//  SCNowPlayingProgressSlider.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//

import Cocoa

class SCNowPlayingProgressSlider: NSSlider {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}

class SCNowPlayingProgressSliderCell: NSSliderCell {
    override func drawBarInside(aRect: NSRect, flipped: Bool) {
        // http://stackoverflow.com/questions/29729743/change-nsslider-bar-color
        
        /// The slider's rect
        var rect = aRect;
        
        // Set the height of the slider
        rect.size.height = CGFloat(5);
        
        /// The corner radius of the slider
        let barRadius = CGFloat(0);
        
        /// The current value of the slider
        let value = CGFloat((self.doubleValue - self.minValue) / (self.maxValue - self.minValue));
        
        /// The final calculated width
        let finalWidth = CGFloat(value * (self.controlView!.frame.size.width - 2));
        
        /// The rect for the left part of the slider
        var leftRect = rect;
        
        // Set the width of the left part
        leftRect.size.width = finalWidth;
        
        /// The bezier path for the background of the slider
        let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius);
        
        // Set the fill color
        SCThemingEngine().defaultEngine().nowPlayingProgressLeftOverColor.setFill();
        
        // Fill in the rect
        bg.fill();
        
        /// The path for the completed part of the slider(left)
        let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius);
        
        // Set the fill color
        SCThemingEngine().defaultEngine().nowPlayingProgressCompletedColor.setFill();
        
        // Fill in the rect
        active.fill();
    }
    
    override func knobRectFlipped(flipped: Bool) -> NSRect {
        // Set the width to 1 so we get absoulte mouse position
        return NSRect(x: 0, y: 0, width: 1, height: 5);
    }
    
    override func drawKnob(knobRect: NSRect) {
        // Dont draw a knob
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
