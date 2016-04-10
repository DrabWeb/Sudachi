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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        // Initialize the application
        (NSApplication.sharedApplication().delegate as! AppDelegate).initialize();
        
        // An example theme on my machine for testing
//        SCThemingEngine().defaultEngine().loadFromThemeFolder(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes/Material Pink.sctheme/");
        
        // Style the window
        styleWindow();
        
        // Set the main window
        (NSApplication.sharedApplication().delegate as! AppDelegate).mainWindow = window;
        
        // Load the theme
        loadTheme();
        
        // Initialize everything else
        nowPlayingController.initialize();
        playlistController.initialize();
        musicBrowserController.initialize();
        
        // Select the music browser
        window.makeFirstResponder(musicBrowserController.musicBrowserCollectionView);
        
        // Spawn the update and notification thread
        NSThread.detachNewThreadSelector(Selector("updateLoopThread"), toTarget: self, withObject: nil);
        
//        NSThread.detachNewThreadSelector(Selector("nowPlayingNotificationLoopThread"), toTarget: self, withObject: nil);
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
    }
}