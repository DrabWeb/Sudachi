//
//  SCNowPlayingController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//

import Cocoa

/// Controls the Now Playing/Media Controller view
class SCNowPlayingController: NSObject, MediaKeyTapDelegate {
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
    
    /// The constraint for the previous button for how much it is spaced from the pause/play button
    @IBOutlet weak var nowPlayingPreviousButtonRightSpacingConstraint: NSLayoutConstraint!
    
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
    
    /// The constraint for the next button for how much it is spaced from the pause/play button
    @IBOutlet weak var nowPlayingNextButtonLeftSpacingConstraint: NSLayoutConstraint!
    
    /// When we interact with nowPlayingNextButton...
    @IBAction func nowPlayingNextButtonInteracted(sender: AnyObject) {
        // Skip to the next song
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipNext();
        
        // Update this controller and the playlist
        mainViewController.updatePlaylistAndNowPlaying();
    }
    
    /// The view for managing hovering the now playing view and showing the cover overlay when it's set to hidden
    @IBOutlet weak var nowPlayingHoverView: SCNowPlayingHoverView!
    
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
        
        // Update the menubar media buttons
        updateStatusItemImages();
    }
    
    /// The next song status item for the menu bar
    var nextStatusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength);
    
    /// The pause/play song status item for the menu bar
    var pausePlayStatusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength);
    
    /// The previous song status item for the menu bar
    var previousStatusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength);
    
    /// Adds the status items(Previous, Pause/Play and Next) to the menu bar
    func addStatusItems() {
        // Update the status item images
        updateStatusItemImages();
        
        // Set the targets then actions
        previousStatusItem.button?.target = self;
        pausePlayStatusItem.button?.target = self;
        nextStatusItem.button?.target = self;
        
        previousStatusItem.button?.action = Selector("skipPrevious");
        pausePlayStatusItem.button?.action = Selector("togglePlayPause");
        nextStatusItem.button?.action = Selector("skipNext");
    }
    
    /// Updates the images of the status items
    func updateStatusItemImages() {
        /// The image for the previous song status item
        var previousImage : NSImage = SCThemingEngine().defaultEngine().menubarSkipPreviousImage;
        
        /// The image for the pause/play song status item
        var pausePlayImage : NSImage = NSImage();
        
        /// The image for the next song status item
        var nextImage : NSImage = SCThemingEngine().defaultEngine().menubarSkipNextImage;
        
        // Play/Pause button
        // If the current status is Paused/Stop...
        if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Paused || (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Stopped) {
            // Set the Pause/Play image to the play icon
            pausePlayImage = SCThemingEngine().defaultEngine().menubarPlayImage;
        }
            // If the current status is Playing...
        else if((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.status == .Playing) {
            // Set the Pause/Play image to the pause icon
            pausePlayImage = SCThemingEngine().defaultEngine().menubarPauseImage;
        }
        
        // Set all the status item images to be templates
        previousImage = (previousImage.copy() as! NSImage);
        previousImage.template = true;
        
        pausePlayImage = (pausePlayImage.copy() as! NSImage);
        pausePlayImage.template = true;
        
        nextImage = (nextImage.copy() as! NSImage);
        nextImage.template = true;
        
        // Set the image sizes to fit the menu bar
        previousImage.size = NSSize(width: NSStatusBar.systemStatusBar().thickness - 12, height: NSStatusBar.systemStatusBar().thickness - 12);
        pausePlayImage.size = NSSize(width: NSStatusBar.systemStatusBar().thickness - 12, height: NSStatusBar.systemStatusBar().thickness - 12);
        nextImage.size = NSSize(width: NSStatusBar.systemStatusBar().thickness - 12, height: NSStatusBar.systemStatusBar().thickness - 12);
        
        // Set the status item images
        previousStatusItem.image = previousImage;
        pausePlayStatusItem.image = pausePlayImage;
        nextStatusItem.image = nextImage;
    }
    
    /// Calls SudachiMPD.skipPrevious()
    func skipPrevious() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipPrevious();
    }
    
    /// Calls SudachiMPD.togglePlayPause()
    func togglePlayPause() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.togglePlayPause();
    }
    
    /// Calls SudachiMPD.skipNext()
    func skipNext() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipNext();
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // If we said to hide the cover overlay's shadow...
        if(!SCThemingEngine().defaultEngine().nowPlayingCoverOverlayShadowEnabled) {
            // Disable the cover overlay shadow
            nowPlayingCoverOverlayView.layer = CALayer();
            
            // Set the overlay color(Its transparent when the layer resets)
            nowPlayingCoverOverlayView.layer?.backgroundColor = SCThemingEngine().defaultEngine().nowPlayingCoverOverlayBackgroundColor.CGColor;
        }
        
        // Set the now playing view's background color
        nowPlayingContainer.layer?.backgroundColor = SCThemingEngine().defaultEngine().nowPlayingViewBackgroundColor.CGColor;
        
        // Set the label colors
        nowPlayingTitleLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingTitleTextColor;
        nowPlayingArtistLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingArtistTextColor;
        nowPlayingSongPositionLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingTimesTextColor;
        nowPlayingSongDurationLabel.textColor = SCThemingEngine().defaultEngine().nowPlayingTimesTextColor;
        
        // Set the cover overlay's color
        nowPlayingCoverOverlayView.fillColor = SCThemingEngine().defaultEngine().nowPlayingCoverOverlayBackgroundColor;
        
        // Set the behind cover color
        nowPlayingCoverOverlayView.superview!.layer = CALayer();
        nowPlayingCoverOverlayView.superview!.layer!.backgroundColor = SCThemingEngine().defaultEngine().nowPlayingBehindCoverBackgroundColor.CGColor;
        
        // Load the media button images
        nowPlayingPreviousButton.image = SCThemingEngine().defaultEngine().skipPreviousImage;
        nowPlayingNextButton.image = SCThemingEngine().defaultEngine().skipNextImage;
        nowPlayingPausePlayButton.image = SCThemingEngine().defaultEngine().playImage;
        
        // Set the fonts
        nowPlayingTitleLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingTitleLabel.font!, size: SCThemingEngine().defaultEngine().nowPlayingTitleFontSize);
        nowPlayingArtistLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingArtistLabel.font!, size: SCThemingEngine().defaultEngine().nowPlayingArtistFontSize);
        nowPlayingSongPositionLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingSongPositionLabel.font!, size: SCThemingEngine().defaultEngine().nowPlayingTimesFontSize);
        nowPlayingSongDurationLabel.font = SCThemingEngine().defaultEngine().setFontFamily(nowPlayingSongDurationLabel.font!, size: SCThemingEngine().defaultEngine().nowPlayingTimesFontSize);
        
        // Set the constraints
        nowPlayingPreviousButtonRightSpacingConstraint.constant = SCThemingEngine().defaultEngine().nowPlayingPreviousNextButtonSpacing;
        nowPlayingNextButtonLeftSpacingConstraint.constant = SCThemingEngine().defaultEngine().nowPlayingPreviousNextButtonSpacing;
    }
    
    /// The handler for the media key events
    var mediaKeyTap: MediaKeyTap?
    
    func initialize() {
        // Set the cover overlay box to allow fill colors
        nowPlayingCoverOverlayView.borderType = .LineBorder;
        nowPlayingCoverOverlayView.boxType = .Custom;
        nowPlayingCoverOverlayView.borderWidth = 0;
        
        // Load the theme
        loadTheme();
        
        // Setup the media key listener
        mediaKeyTap = MediaKeyTap(delegate: self);
        mediaKeyTap?.start();
        
        // Setup the hover view
        nowPlayingHoverView.enteredTarget = self;
        nowPlayingHoverView.enteredAction = Selector("mouseEntered");
        
        nowPlayingHoverView.exitedTarget = self;
        nowPlayingHoverView.exitedAction = Selector("mouseExited");
        
        // Add the status items
        addStatusItems();
        
        // Update the status
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.updateStatus();
        
        // Update the controller
        update();
        
        // Do the initial run position/progress update(Or else it will wait 0.5 seconds before running the first time)
        updatePositionLabelAndProgressSlider();
        
        // Set the loop for updating the song position label and progress slider(0.5 seconds just incase the app opens on a half second or something)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.5), target: self, selector: Selector("updatePositionLabelAndProgressSlider"), userInfo: nil, repeats: true);
    }
    
    func mouseEntered() {
        // If the now playing view cover overlay is set to be hidden...
        if(!mainViewController.nowPlayingCoverOverlayVisible) {
            // Show the cover overlay and progress slider
            nowPlayingCoverOverlayView.hidden = false;
            nowPlayingProgressSlider.hidden = false;
        }
    }
    
    func mouseExited() {
        // If the now playing view cover overlay is set to be hidden...
        if(!mainViewController.nowPlayingCoverOverlayVisible) {
            // Hide the cover overlay and progress slider
            nowPlayingCoverOverlayView.hidden = true;
            nowPlayingProgressSlider.hidden = true;
        }
    }
    
    func handleMediaKey(mediaKey: MediaKey, event: KeyEvent) {
        // Switch on the key press and call the respective function
        switch mediaKey {
            case .PlayPause:
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.togglePlayPause();
            case .Previous, .Rewind:
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipPrevious();
            case .Next, .FastForward:
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.skipNext();
        }
    }
}
