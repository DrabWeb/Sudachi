//
//  SCPlaylistActionsController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-10.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPlaylistActionsController: NSObject {
    /// The main view controller for the main window(The on this is in)
    @IBOutlet weak var mainViewController: ViewController!
    
    /// The container view for the playlist actions view
    @IBOutlet weak var playlistActionsContainerView: NSBox!
    
    /// The button for looping the current song
    @IBOutlet weak var loopButton: NSButton!
    
    /// When we press loopButton...
    @IBAction func loopButtonPressed(sender: AnyObject) {
        // Switch repeat modes
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.repeatModeSwitch();
        
        // Update the buttons
        updateButtons();
    }
    
    /// The button for shuffling the current playlist
    @IBOutlet weak var shuffleButton: NSButton!
    
    /// When we press shuffleButton...
    @IBAction func shuffleButtonPressed(sender: AnyObject) {
        // Shuffle the playlist
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.shufflePlaylist();
    }
    
    /// The button for toggling if we want random mode on
    @IBOutlet weak var randomButton: NSButton!
    
    /// When we press randomButton...
    @IBAction func randomButtonPressed(sender: AnyObject) {
        // Toggle random mode
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.toggleRandomMode();
        
        // Update the buttons
        updateButtons();
    }
    
    /// Updates the Loop/Random buttons to match the current state of their respective values
    func updateButtons() {
        // If repeat mode is on...
        if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getRepeatState()) {
            // If we are in single repeat mode...
            if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getSingleState()) {
                // Set the repeat mode button's image to the single repeat image
                loopButton.image = SCThemingEngine().defaultEngine().playlistActionsRepeatSongImage;
            }
            // If we are in playlist repeat mode...
            else {
                // Set the repeat mode button's image to the playlist repeat image
                loopButton.image = SCThemingEngine().defaultEngine().playlistActionsRepeatPlaylistImage;
            }
        }
        // If repeat mode is off...
        else {
            // Set the repeat mode button's image to the off image
            loopButton.image = SCThemingEngine().defaultEngine().playlistActionsRepeatOffImage;
        }
        
        // If random mode is on...
        if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getRandomState()) {
            // Set the random mode button's image to the on image
            randomButton.image = SCThemingEngine().defaultEngine().playlistActionsRandomOnImage;
        }
        // If random mode is off...
        else {
            // Set the random mode button's image to the off image
            randomButton.image = SCThemingEngine().defaultEngine().playlistActionsRandomOffImage;
        }
    }
    
    /// Called by the switch repeat mode menu item, switches the repeat mode
    func switchRepeatModeMenuItem() {
        // Switch repeat mode
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.repeatModeSwitch();
        
        // Update the buttons
        updateButtons();
    }

    /// Called by the shuff;e menu item, shuffles the current playlist
    func shufflePlaylistMenuItem() {
        // Shuffle the playlist
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.shufflePlaylist();
        
        // Update the buttons
        updateButtons();
    }
    
    /// Called by the toggle random mode menu item, toggles random mode
    func toggleRandomModeMenuItem() {
        // Toggle random mode
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.toggleRandomMode();
        
        // Update the buttons
        updateButtons();
    }
    
    /// Sets up the menu items for this controller
    func setupMenuItems() {
        // Setup the menu items
        // Set the targets
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSwitchRepeatMode.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemShufflePlaylist.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleRandomMode.target = self;
        
        // Set the actions
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSwitchRepeatMode.action = Selector("switchRepeatModeMenuItem");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemShufflePlaylist.action = Selector("shufflePlaylistMenuItem");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleRandomMode.action = Selector("toggleRandomModeMenuItem");
    }
    
    /// Tells the playlist actions to update
    func update() {
        // Update the buttons
        updateButtons();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the container color
        playlistActionsContainerView.fillColor = SCThemingEngine().defaultEngine().playlistActionsBackgroundColor;
        
        // Set the button images
        loopButton.image = SCThemingEngine().defaultEngine().playlistActionsRepeatOffImage;
        shuffleButton.image = SCThemingEngine().defaultEngine().playlistActionsShuffleImage;
        randomButton.image = SCThemingEngine().defaultEngine().playlistActionsRandomOffImage;
    }
    
    func initialize() {
        // Set the container box to allow fill colors
        playlistActionsContainerView.borderType = .LineBorder;
        playlistActionsContainerView.boxType = .Custom;
        playlistActionsContainerView.borderWidth = 0;
        
        // Load the theme
        loadTheme();
        
        // Setup the menu items
        setupMenuItems();
        
        // Update the buttons
        updateButtons();
    }
}
