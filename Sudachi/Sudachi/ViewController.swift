//
//  ViewController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-01.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The controller for the now playing panel in the top right
    @IBOutlet var nowPlayingController: SCNowPlayingController!
    
    /// The controller for displaying the playlist
    @IBOutlet var playlistController: SCPlaylistController!
    
    /// The controller for the music browser for adding items to the playlist
    @IBOutlet var musicBrowserController: SCMusicBrowserController!
    
    /// The controller for the playlist actions view
    @IBOutlet var playlistActionsController: SCPlaylistActionsController!
    
    /// The split view that holds the Player, Playlist, Playlist Controls and Music Browser
    @IBOutlet var mainSplitView: SCInvisibleDividerSplitView!
    
    /// The split view for the right panel(Now Playing, Playlist and Playlist Actions)
    @IBOutlet var rightPanelSplitView: SCInvisibleDividerSplitView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        // Initialize the application
        (NSApplication.sharedApplication().delegate as! AppDelegate).initialize();
        
        // Style the window
        styleWindow();
        
        // Set the main window
        (NSApplication.sharedApplication().delegate as! AppDelegate).mainWindow = window;
        
        // An example theme on my machine for testing
        SCThemingEngine().defaultEngine().loadFromThemeFolder(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes/Bright Pink.sctheme/");
        
        // Load the theme
        loadTheme();
        
        // Tell the search field to load its theme
        musicBrowserController.searchField.loadTheme();
        
        // Initialize everything else
        nowPlayingController.initialize();
        playlistController.initialize();
        musicBrowserController.initialize();
        playlistActionsController.initialize();
        
        // Select the music browser
        window.makeFirstResponder(musicBrowserController.musicBrowserCollectionView);
        
        // Spawn the update and notification thread
        NSThread.detachNewThreadSelector(Selector("updateLoopThread"), toTarget: self, withObject: nil);
        
//        NSThread.detachNewThreadSelector(Selector("nowPlayingNotificationLoopThread"), toTarget: self, withObject: nil);
    }
    
    /// Is the now playing open?
    var nowPlayingOpen : Bool = true;
    
    /// The original height of now playing before it was hidden
    var nowPlayingOriginalHeight : CGFloat = 0;
    
    /// Toggles the visibility of now playing
    func toggleNowPlaying() {
        // Toggle nowPlayingOpen
        nowPlayingOpen = !nowPlayingOpen;
        
        // If now playing is now open...
        if(nowPlayingOpen) {
            // Show now playing
            showNowPlaying();
        }
        // If now playing is now closed...
        else {
            // Hide now playing
            hideNowPlaying();
        }
    }
    
    /// Hides now playing
    func hideNowPlaying() {
        // Store the now playing height
        nowPlayingOriginalHeight = rightPanelSplitView.subviews[0].frame.height;
        
        // Hide the now playing view
        rightPanelSplitView.subviews[0].hidden = true;
        
        // Adjust the split view
        rightPanelSplitView.adjustSubviews();
        
        // Move the now playing divider to 0
        rightPanelSplitView.setPosition(0, ofDividerAtIndex: 0);
    }
    
    /// Shows now playing
    func showNowPlaying() {
        // Show the now playing view
        rightPanelSplitView.subviews[0].hidden = false;
        
        // Adjust the split view
        rightPanelSplitView.adjustSubviews();
        
        // Move the now playing divider back to its original position
        rightPanelSplitView.setPosition(nowPlayingOriginalHeight, ofDividerAtIndex: 0);
    }
    
    /// Is the playlist open?
    var playlistOpen : Bool = true;
    
    /// The original size of the playlist before it was hidden
    var playlistOriginalSize : CGFloat = 0;
    
    /// Toggles the visibility of the playlist
    func togglePlaylist() {
        // Toggle playlistOpen
        playlistOpen = !playlistOpen;
        
        // If the playlist is now open...
        if(playlistOpen) {
            // Show the playlist
            showPlaylist();
        }
        // If the playlist is now closed...
        else {
            // Hide the playlist
            hidePlaylist();
        }
    }
    
    /// Hides the playlist
    func hidePlaylist() {
        // Store the current playlist size
        playlistOriginalSize = rightPanelSplitView.subviews[1].frame.height;
        
        // Hide the playlist
        rightPanelSplitView.subviews[1].hidden = true;
        
        // Adjust the split view
        rightPanelSplitView.adjustSubviews();
        
        // Set the position of the playlist divider to 0
        rightPanelSplitView.setPosition(0, ofDividerAtIndex: 1);
    }
    
    /// Shows the playlist
    func showPlaylist() {
        // Show the playlist
        rightPanelSplitView.subviews[1].hidden = false;
        
        // Adjust the split view
        rightPanelSplitView.adjustSubviews();
        
        // If the playlist size is 0, set the original size to 200(So the user doesnt lose their playlist)
        if(playlistOriginalSize == 0) {
            playlistOriginalSize = 200;
        }
        
        // Restore the playlist size
        rightPanelSplitView.setPosition((self.window.frame.height - playlistActionsController.playlistActionsContainerView.frame.height) - playlistOriginalSize, ofDividerAtIndex: 0);
    }
    
    /// Is the now playing cover overlay visible?
    var nowPlayingCoverOverlayVisible : Bool = true;
    
    /// Toggles the visibility of the now playing cover overlay
    func toggleNowPlayingCoverOverlayVisible() {
        // Toggle nowPlayingCoverOverlayVisible
        nowPlayingCoverOverlayVisible = !nowPlayingCoverOverlayVisible;
        
        // If the now playing cover overlay is now open...
        if(nowPlayingCoverOverlayVisible) {
            // Show the now playing cover overlay
            showNowPlayingCoverOverlayVisible();
        }
        // If the now playing cover overlay is now closed...
        else {
            // Hide the now playing cover overlay
            hideNowPlayingCoverOverlayVisible();
        }
    }
    
    /// Hides the now playing cover overlay
    func hideNowPlayingCoverOverlayVisible() {
        // Hide the cover overlay and progress slider
        nowPlayingController.nowPlayingCoverOverlayView.hidden = true;
        nowPlayingController.nowPlayingProgressSlider.hidden = true;
        
        // Set the cover image allignment to center
        nowPlayingController.nowPlayingCoverImageView.imageAlignment = .AlignCenter;
    }
    
    /// Shows the now playing cover overlay
    func showNowPlayingCoverOverlayVisible() {
        // Show the cover overlay and progress slider
        nowPlayingController.nowPlayingCoverOverlayView.hidden = false;
        nowPlayingController.nowPlayingProgressSlider.hidden = false;
        
        // Set the cover image allignment back to top
        nowPlayingController.nowPlayingCoverImageView.imageAlignment = .AlignTop;
    }
    
    /// Are the playlist actions open?
    var playlistActionsOpen : Bool = true;
    
    /// Toggles the visibility of the playlist actions
    func togglePlaylistActions() {
        // Toggle playlistActionsOpen
        playlistActionsOpen = !playlistActionsOpen;
        
        // If the playlist actions are now open...
        if(playlistActionsOpen) {
            // Show the playlist actions
            showPlaylistActions();
        }
        // If the playlist actions are now closed...
        else {
            // Hide the playlist actions
            hidePlaylistActions();
        }
    }
    
    /// Hides the playlist actions
    func hidePlaylistActions() {
        // Hide the playlist actions
        rightPanelSplitView.subviews[2].hidden = true;
        
        // Adjust the split views
        rightPanelSplitView.adjustSubviews();
        
        // Adjust the playlist controls size
        rightPanelSplitView.setPosition(0, ofDividerAtIndex: 2);
    }
    
    /// Shows the playlist actions
    func showPlaylistActions() {
        // Show the playlist actions
        rightPanelSplitView.subviews[2].hidden = false;
        
        // Adjust the split views
        rightPanelSplitView.adjustSubviews();
    }
    
    /// Is the music browser open?
    var musicBrowserOpen : Bool = true;
    
    /// The size of the right panel in mainSplitView before the music browser was hidden
    var rightPanelOriginalSize : CGFloat = 0;
    
    /// Toggles the visibility of the music browser
    func toggleMusicBrowser() {
        // Toggle musicBrowserOpen
        musicBrowserOpen = !musicBrowserOpen;
        
        // If the music browser is now open...
        if(musicBrowserOpen) {
            // Show the music browser
            showMusicBrowser();
        }
        // If the music browser is now closed...
        else {
            // Hide the music browser
            hideMusicBrowser();
        }
    }
    
    /// Hides the music browser
    func hideMusicBrowser() {
        // If the music browser isnt already hidden...
        if(musicBrowserOpen) {
            // Set the right panel size
            rightPanelOriginalSize = mainSplitView.subviews[1].frame.width;
        }
        
        // Hide the music browser
        mainSplitView.subviews[0].hidden = true;
        
        // Adjust the split views
        mainSplitView.adjustSubviews();
        
        // Adjust the music browser size
        mainSplitView.setPosition(0, ofDividerAtIndex: 0);
        
        // Say the music browser is closed
        musicBrowserOpen = false;
    }
    
    /// Shows the music browser
    func showMusicBrowser() {
        // Show the music browser
        mainSplitView.subviews[0].hidden = false;
        
        // Adjust the split views
        mainSplitView.adjustSubviews();
        
        // Adjust the music browser size
        mainSplitView.setPosition(mainSplitView.frame.width - rightPanelOriginalSize, ofDividerAtIndex: 0);
        
        // Say the music browser is open
        musicBrowserOpen = true;
    }
    
    /// The thread that updates the playlist and now playing controllers with "mpc idle"
    func updateLoopThread() {
        // Infinitley loop
        while(true) {
            // If the MPD server is running...
            if(!(NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.runMpcCommand(["status"], waitUntilExit: true, log: false).lowercaseString.containsString("mpd error: connection refused")) {
                // Call "mpc idle"
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.runMpcCommand(["idle"], waitUntilExit: true, log: false);
                
                // Update the now playing and playlist controllers on the main thread
                self.performSelectorOnMainThread(Selector("updatePlaylistAndNowPlaying"), withObject: nil, waitUntilDone: false);
            }
            // If the MPD server isnt running...
            else {
                // Print that we are restarting the server
                print("ViewController: Restarting MPD server");
                
                // Kill the server
                SCCommandUtilities().runCommand("/usr/local/bin/mpd", arguments: ["--kill"], waitUntilExit: true, log: true);
                
                // Launch the server
                SCCommandUtilities().runCommand("/usr/local/bin/mpd", arguments: [], waitUntilExit: true, log: true);
                
                // Update the now playing and playlist controllers on the main thread
                self.performSelectorOnMainThread(Selector("updatePlaylistAndNowPlaying"), withObject: nil, waitUntilDone: false);
            }
        }
    }
    
    /// The thread that show the manages showing the now playing notification
    func nowPlayingNotificationLoopThread() {
        // Infinitley loop
        while(true) {
            /// TODO: Make it so this only gets triggered when songs change, because currently it also fires when you are skipping
            // Call "mpc idle player"
            (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.runMpcCommand(["idle", "player"], waitUntilExit: true, log: false);
            
            // Update the now playing and playlist controllers on the main thread
            self.performSelectorOnMainThread(Selector("updatePlaylistAndNowPlaying"), withObject: nil, waitUntilDone: false);
            
            // Show the now playing notification
            nowPlayingController.sendNowPlayingNotification();
        }
    }
    
    /// Calls updateNowPlaying and updatePlaylist
    func updatePlaylistAndNowPlaying() {
        updateNowPlaying();
        updatePlaylist();
    }
    
    /// Updates the playlist controller
    func updatePlaylist() {
        // Tell the playlist to update
        playlistController.update();
    }
    
    /// Updates the now playing controller
    func updateNowPlaying() {
        // Tell the now playing controller to update
        nowPlayingController.update();
    }
    
    /// Did the user have the toolbar visible before we entered fullscreen?
    var toolbarVisible : Bool = true;
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Set if the toolbar was visible
        toolbarVisible = window.toolbar!.visible;
        
        // Hide the toolbar
        window.toolbar?.visible = false;
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Restore the toolbar's visibility
        window.toolbar?.visible = toolbarVisible;
        
        // If we said to hide window titlebars...
        if(SCThemingEngine().defaultEngine().titlebarsHidden) {
            // Hide the titlebar of the window
            window.standardWindowButton(.CloseButton)?.superview?.superview?.removeFromSuperview();
            
            // Set the content view to be full size
            window.styleMask |= NSFullSizeContentViewWindowMask;
        }
    }
    
    /// Sets up the menu items for this controller
    func setupMenuItems() {
        // Setup the menu items
        // Set the targets
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleMusicBrowser.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlaylistActions.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleCoverOverlay.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlaylist.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlayer.target = self;
        
        // Set the actions
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleMusicBrowser.action = Selector("toggleMusicBrowser");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlaylistActions.action = Selector("togglePlaylistActions");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleCoverOverlay.action = Selector("toggleNowPlayingCoverOverlayVisible");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlaylist.action = Selector("togglePlaylist");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePlayer.action = Selector("toggleNowPlaying");
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Style the window
        window.titleVisibility = .Hidden;
        window.titlebarAppearsTransparent = true;
        
        // Setup the menu items
        setupMenuItems();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the titlebar color
        window.standardWindowButton(.CloseButton)?.superview?.superview?.superview?.wantsLayer = true;
        window.standardWindowButton(.CloseButton)?.superview?.layer?.backgroundColor = SCThemingEngine().defaultEngine().titlebarColor.CGColor;
        window.standardWindowButton(.CloseButton)?.superview?.superview?.superview?.layer?.backgroundColor = SCThemingEngine().defaultEngine().titlebarColor.CGColor;
        
        // Allow the window to be transparent and set the background color
        window.opaque = false;
        window.backgroundColor = SCThemingEngine().defaultEngine().backgroundColor;
        
        // If we said to hide the now right panel's shadow...
        if(!SCThemingEngine().defaultEngine().rightPanelShadowEnabled) {
            // Hide the shadow for the right panel(By resetting the layer - for some reason when this loads the CALayer is blank)
            mainSplitView.subviews[1].layer = CALayer();
        }
        
        // If we said to hide window titlebars...
        if(SCThemingEngine().defaultEngine().titlebarsHidden) {
            // Hide the titlebar of the window
            window.standardWindowButton(.CloseButton)?.superview?.superview?.removeFromSuperview();
            
            // Set the content view to be full size
            window.styleMask |= NSFullSizeContentViewWindowMask;
        }
    }
}