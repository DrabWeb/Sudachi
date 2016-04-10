//
//  SCNowPlayingController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// Controls the Now Playing/Media Controller view
class SCNowPlayingController: NSObject {
    /// The main view controller for the main window(The one this is in)
    @IBOutlet weak var mainViewController: ViewController!
    
    /// The container view for the now playing view
    @IBOutlet weak var nowPlayingContainer: NSView!
    
    /// The image view for showing the cover image of the current song
    @IBOutlet weak var nowPlayingCoverImageView: NSImageView!
    
    /// The view that overlays the cover so you can read the song's info
    @IBOutlet weak var nowPlayingCoverOverlayView: NSBox!
    
    /// The label for the current song's title
    @IBOutlet weak var nowPlayingTitleLabel: NSTextField!
    
    /// The label for the current song's artist
    @IBOutlet weak var nowPlayingArtistLabel: NSTextField!
    
    /// The label for showing the current position in the song the user is at
    @IBOutlet weak var nowPlayingSongPositionLabel: NSTextField!
    
    /// The label for showing the duration of the current song
    @IBOutlet weak var nowPlayingSongDurationLabel: NSTextField!
    
    /// The slider for showing the progress of the current song
    @IBOutlet weak var nowPlayingProgressSlider: SCNowPlayingProgressSlider!
    
    /// Is nowPlayingProgressSlider currently being dragged?
    var draggingProgressSlider : Bool = false;
    
    /// When we interact with nowPlayingProgressSlider...
    @IBAction func nowPlayingProgressSliderInteracted(sender: AnyObject) {
        /// The current event of the application
        let curentEvent : NSEvent = NSApplication.sharedApplication().currentEvent!;
        
        /// Was the dragging on the slider just ended?
        let endingDrag : Bool = curentEvent.type == NSEventType.LeftMouseUp;
        
        /// The position in the song the user wants to jump to(Or the time of the current slider position)(In seconds)
        let jumpPositionSeconds : Int = Int((nowPlayingProgressSlider.floatValue * Float((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong.duration.toSeconds())) / 100);
        
        // If we ended dragging...
        if(endingDrag) {
            // Jump to the desired position
            (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.jumpToPosition(SCSongTime(hours: 0, minutes: 0, seconds: jumpPositionSeconds));
            
            // Say we aren't dragging the progress slider
            draggingProgressSlider = false;
        }
        // If we are still dragging...
        else {
            // Set the position label
            nowPlayingSongPositionLabel.stringValue = SCSongTime(hours: 0, minutes: 0, seconds: jumpPositionSeconds).string;
            
            // Say we are dragging the progress slider
            draggingProgressSlider = true;
        }
    }
    
    /// The skip previous button for going to the previous song
    @IBOutlet weak var nowPlayingPreviousButton: NSButton!
    
    /// When we interact with nowPlayingPreviousButton...
    @IBAction func nowPlayingPreviousButtonInteracted(sender: AnyObject) {
        // Skip to the previous song
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipPrevious();
        
        // Update this controller and the playlist
        mainViewController.updatePlaylistAndNowPlaying();
    }
    
    /// The button for pausing/playing the song
    @IBOutlet weak var nowPlayingPausePlayButton: NSButton!
    
    /// When we interact with nowPlayingPausePlayButton...
    @IBAction func nowPlayingPausePlayButtonInteracted(sender: AnyObject) {
        // Toggle Pause/Play
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.togglePlayPause();
        
        // Update this controller
        update();
    }
    
    /// The skip next button for going to the next song
    @IBOutlet weak var nowPlayingNextButton: NSButton!
    
    /// When we interact with nowPlayingNextButton...
    @IBAction func nowPlayingNextButtonInteracted(sender: AnyObject) {
        // Skip to the next song
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipNext();
        
        // Update this controller and the playlist
        mainViewController.updatePlaylistAndNowPlaying();
    }
    
    /// Updates the Next, Previous and Play/Pause buttons to match the current status
    func updateMediaButtons() {
        // Play/Pause button
        // If the current status is Paused/Stop...
        if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Paused || (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Stopped) {
            // Set the Pause/Play button to have the play icon
            nowPlayingPausePlayButton.image = SCThemingEngine().defaultEngine().playImage;
        }
        // If the current status is Playing...
        else if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Playing) {
            // Set the Pause/Play button to have the pause icon
            nowPlayingPausePlayButton.image = SCThemingEngine().defaultEngine().pauseImage;
        }
    }
    
    /// Sends the notification to tell the user what song is currently playing
    func sendNowPlayingNotification() {
        /// Load the current song
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getCurrentSong(false);
        
        /// The notification to be sent
        let playingNotification : NSUserNotification = NSUserNotification();
        
        // Set the title
        playingNotification.title = (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong.artist;
        
        // Set the informative text
        playingNotification.informativeText = (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong.title;
        
        // Deliver the notification
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(playingNotification);
    }
    
    /// Calls loadDataFromSong with the current playing song
    func loadCurrentSongData() {
        // Do the thing
        loadDataFromSong((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getCurrentSong(true));
    }
    
    /// Loads the data from the given SCSong into the now playing interface
    func loadDataFromSong(song : SCSong) {
        // Load the data
        nowPlayingCoverImageView.image = song.coverImage;
        nowPlayingTitleLabel.stringValue = song.title;
        setNowPlayingArtistLabelLabel(song.artist);
        nowPlayingSongDurationLabel.stringValue = song.duration.string;
    }
    
    /// Updates the current position label and the progress slider
    func updatePositionLabelAndProgressSlider() {
        /// The current song position
        let currentSongPosition : SCSongTime = (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getCurrentSongPosition();
        
        // If we aren't dragging the progress slider...
        if(!draggingProgressSlider) {
            // Set the position label
            nowPlayingSongPositionLabel.stringValue = currentSongPosition.string;
            
            // Update the progress bar
            nowPlayingProgressSlider.floatValue = Float(Float(currentSongPosition.toSeconds()) / Float((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong.duration.toSeconds())) * Float(100);
        }
    }
    
    /// Sets the label for nowPlayingTitleLabel to the given artist name with "by" in front
    func setNowPlayingArtistLabelLabel(artistName : String) {
        // Set the title
        nowPlayingArtistLabel.stringValue = "by " + artistName;
    }
    
    /// Tells the now playing to update
    func update() {
        // Reload the song data
        loadCurrentSongData();
        
        // Update the media buttons
        updateMediaButtons();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the now playing view's background color
        nowPlayingContainer.layer?.backgroundColor = SCThemingEngine().defaultEngine().nowPlayingViewBackgroundColor.CGColor;
        
        // Set the label colors
        nowPlayingTitleLabel.textColor = SCThemingEngine().defaultEngine().textColor;
        nowPlayingArtistLabel.textColor = SCThemingEngine().defaultEngine().secondaryTextColor;
        nowPlayingSongPositionLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingTimesTextColor;
        nowPlayingSongDurationLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingTimesTextColor;
        
        // Set the cover overlay's color
        nowPlayingCoverOverlayView.fillColor = SCThemingEngine().defaultEngine().nowPlayingCoverOverlayBackgroundColor;
        
        // Load the media button images
        nowPlayingPreviousButton.image = SCThemingEngine().defaultEngine().skipPreviousImage;
        nowPlayingNextButton.image = SCThemingEngine().defaultEngine().skipNextImage;
        nowPlayingPausePlayButton.image = SCThemingEngine().defaultEngine().playImage;
        
        // Set the fonts
        nowPlayingTitleLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingTitleLabel.font!);
        nowPlayingArtistLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingArtistLabel.font!);
        nowPlayingSongPositionLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingSongPositionLabel.font!);
        nowPlayingSongDurationLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingSongDurationLabel.font!);
    }
    
    func initialize() {
        // Set the cover overlay box to allow fill colors
        nowPlayingCoverOverlayView.borderType = .LineBorder;
        nowPlayingCoverOverlayView.boxType = .Custom;
        nowPlayingCoverOverlayView.borderWidth = 0;
        
        // Load the theme
        loadTheme();
        
        // Update the status
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.updateStatus();
        
        // Update the controller
        update();
        
        // Do the initial run position/progress update(Or else it will wait 0.5 seconds before running the first time)
        updatePositionLabelAndProgressSlider();
        
        // Set the loop for updating the song position label and progress slider(0.5 seconds just incase the app opens on a half second or something)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.5), target: self, selector: Selector("updatePositionLabelAndProgressSlider"), userInfo: nil, repeats: true);
    }
}
