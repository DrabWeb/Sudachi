//
//  SCSearchField.swift
//  Sudachi
//
//  Created by Seth on 2016-04-06.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCSearchTextField: NSTextField {
    
    /// Is loadTheme being called from init?
    private var initLoadTheme : Bool = true;
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        // Say loadTheme isnt being called from init
        initLoadTheme = false;
        
        // Load the theme
        loadTheme();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        // Load the theme
        loadTheme();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Get a layer
        self.wantsLayer = true;
        
        // Set the background color
        self.backgroundColor = SCThemingEngine().defaultEngine().searchFieldBackgroundColor;
        self.textColor = SCThemingEngine().defaultEngine().searchFieldTextColor;
        
        // Set the corners to be rounded
        self.layer?.cornerRadius = SCThemingEngine().defaultEngine().searchFieldCornerRadius;
        
        // Set the font
        self.font = SCThemingEngine().defaultEngine().setFontFamily(self.font!);
        
        // If this isnt being called from init...
        if(!initLoadTheme) {
            // Change the caret color(Cursor)
            /// The field editor of this search field's window
            let fieldEditor = self.window?.fieldEditor(true, forObject: self) as! NSTextView;
            
            // Set the cursor color
            fieldEditor.insertionPointColor = SCThemingEngine().defaultEngine().caretColor;
        }
        
        // Set the placeholder color
        /// The place holder text's paragraph style
        let placeholderParagraphStyle = NSMutableParagraphStyle();
        
        // Set the alignment to the center
        placeholderParagraphStyle.alignment = .Center;
        
        /// The attributed placeholder string
        let placeholder = NSMutableAttributedString(string: "Search", attributes: [NSFontAttributeName: NSFont.systemFontOfSize(self.font!.pointSize), NSForegroundColorAttributeName: SCThemingEngine().defaultEngine().searchFieldPlaceholderTextColor, NSParagraphStyleAttributeName: placeholderParagraphStyle, NSFontFamilyAttribute: self.font!.familyName!]);
        
        // Set the placeholder string
        (self.cell as! NSTextFieldCell).placeholderAttributedString = placeholder;
    }
}

class SCSearchTextFieldCell: NSTextFieldCell {
    
}