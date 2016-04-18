//
//  SCPreferencesViewController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-17.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPreferencesViewController: NSViewController {
    
    /// The main window of this view controller
    var preferencesWindow : NSWindow = NSWindow();
    
    /// The label for the theme popup button
    @IBOutlet var themeLabel: NSTextField!
    
    /// The popup button for setting the theme
    @IBOutlet var themePopupButton: NSPopUpButton!
    
    /// When we click the "Apply" button...
    @IBAction func applyButtonPressed(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
        
        // Load the theme
        loadTheme();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the titlebar color
        preferencesWindow.standardWindowButton(.CloseButton)?.superview?.superview?.superview?.wantsLayer = true;
        preferencesWindow.standardWindowButton(.CloseButton)?.superview?.layer?.backgroundColor = SCThemingEngine().defaultEngine().titlebarColor.CGColor;
        preferencesWindow.standardWindowButton(.CloseButton)?.superview?.superview?.superview?.layer?.backgroundColor = SCThemingEngine().defaultEngine().titlebarColor.CGColor;
        
        // Allow the window to be transparent and set the background color
        preferencesWindow.opaque = false;
        preferencesWindow.backgroundColor = SCThemingEngine().defaultEngine().backgroundColor;
        
        // If we said to hide window titlebars...
        if(SCThemingEngine().defaultEngine().titlebarsHidden) {
            // Hide the titlebar of the window
            preferencesWindow.standardWindowButton(.CloseButton)?.superview?.superview?.removeFromSuperview();
            
            // Set the content view to be full size
            preferencesWindow.styleMask |= NSFullSizeContentViewWindowMask;
        }
        
        // Set the label colors
        themeLabel.textColor = SCThemingEngine().defaultEngine().preferencesLabelColor;
        
        // Set the label fonts
        themeLabel.font = SCThemingEngine().defaultEngine().setFontFamily(themeLabel.font!, size: SCThemingEngine().defaultEngine().preferencesLabelFontSize);
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        preferencesWindow = NSApplication.sharedApplication().windows.last!;
        
        // Style the titlebar
        preferencesWindow.titleVisibility = .Hidden;
        preferencesWindow.titlebarAppearsTransparent = true;
        
        // Get the windows center position on the X
        let windowX = ((NSScreen.mainScreen()?.frame.width)! / 2) - (480 / 2);
        
        // Get the windows center position on the Y
        let windowY = (((NSScreen.mainScreen()?.frame.height)! / 2) - (270 / 2)) + 50;
        
        // Center the window
        preferencesWindow.setFrame(NSRect(x: windowX, y: windowY, width: 480, height: 270), display: false);
    }
}