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
    
    /// When we click themePopupButton...
    @IBAction func themePopupButtonInteracted(sender: AnyObject) {
        // If we clicked the "Add from folder..." item...
        if(themePopupButton.selectedItem?.title == "Add from folder...") {
            // Prompt to install a theme
            SCThemingEngine().defaultEngine().promptToInstallTheme();
            
            // Reload the menu items
            addThemePopupButtonItems();
        }
    }
    
    /// When we click the "Apply" button...
    @IBAction func applyButtonPressed(sender: AnyObject) {
        
    }
    
    /// The label to tell teh user they have to restart Sudachi for visual changes to take effect
    @IBOutlet var restartLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
        
        // Load the theme
        loadTheme();
        
        // Add the theme popup button menu items
        addThemePopupButtonItems();
    }
    
    /// Selects the current theme for themePopupButton
    func selectCurrentTheme() {
        // For every item in themePopupButton's item titles...
        for(currentItemIndex, currentItemTitle) in themePopupButton.itemTitles.enumerate() {
            // If the current item's title matches the title of the current theme...
            if(currentItemTitle == NSString(string: SCThemingEngine().defaultEngine().currentThemePath).lastPathComponent.stringByReplacingOccurrencesOfString("." + NSString(string: SCThemingEngine().defaultEngine().currentThemePath).pathExtension, withString: "")) {
                // Select this item
                themePopupButton.selectItemAtIndex(currentItemIndex);
                
                // Stop the loop
                return;
            }
            // If the current item's title is Default and the theme folder path is blank...
            if(currentItemTitle == "Default" && SCThemingEngine().defaultEngine().currentThemePath == "") {
                // Select this item
                themePopupButton.selectItemAtIndex(currentItemIndex);
                
                // Stop the loop
                return;
            }
        }
    }
    
    /// Sets up the menu items in themePopupButton, and then selects the current theme
    func addThemePopupButtonItems() {
        // Remove all the current menu items
        themePopupButton.menu?.removeAllItems();
        
        // Add the "Default" menu item
        themePopupButton.addItemWithTitle("Default");
        
        do {
            // For every file in the themes folder of the Sudachi application support folder...
            for(_, currentFile) in try NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes").enumerate() {
                // If the current file's extension is .sctheme and its a folder...
                if(NSString(string: currentFile).pathExtension == "sctheme" && SCFileUtilities().isFolder(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes/" + currentFile)) {
                    // Add the current theme folder to them menu, without the extension
                    themePopupButton.addItemWithTitle(currentFile.stringByReplacingOccurrencesOfString("." + NSString(string: currentFile).pathExtension, withString: ""));
                }
            }
        }
        catch let error as NSError {
            // Print the error description
            print("SCPreferencesViewController: Error reading themes directory, \(error.description)");
        }
        
        // Add the "Add from folder..." menu item
        themePopupButton.addItemWithTitle("Add from folder...");
        
        // Refresh the popup button's style
        (themePopupButton as! SCPopUpButton).setMenuItemsTitleColorsAndFonts();
        
        // Select the current theme
        selectCurrentTheme();
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
        restartLabel.textColor = SCThemingEngine().defaultEngine().preferencesLabelColor;
        
        // Set the label fonts
        themeLabel.font = SCThemingEngine().defaultEngine().setFontFamily(themeLabel.font!, size: SCThemingEngine().defaultEngine().preferencesLabelFontSize);
        restartLabel.font = SCThemingEngine().defaultEngine().setFontFamily(themeLabel.font!, size: SCThemingEngine().defaultEngine().preferencesLabelFontSize);
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