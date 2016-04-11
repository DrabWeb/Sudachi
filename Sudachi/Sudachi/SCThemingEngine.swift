//
//  SCThemingEngine.swift
//  Sudachi
//
//  Created by Seth on 2016-04-05.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCThemingEngine {
    /// The titlebar color of any window in the app
    var titlebarColor : NSColor = NSColor(hexString: "#1D1921")!;
    
    /// The background color of any window in the app
    var backgroundColor : NSColor = NSColor(hexString: "#211D26")!;
    
    /// The name of the font family to use for the application
    var fontFamily : String = "";
    
    /// Should the application font be antialiased?
    var antialiasFont : Bool = true;
    
    /// The caret color for text fields
    var caretColor : NSColor = NSColor(hexString: "#665F6E")!;
    
    /// The default icon for songs that dont have a cover
    var musicFileIcon : NSImage = NSImage(named: "Music File")!;
    
    /// The icon for folders
    var folderIcon : NSImage = NSImage(named: "Folder")!;
    
    /// The icon for representing the parent folder
    var folderBackIcon : NSImage = NSImage(named: "Folder Back")!;
    
    /// The first alternating color for the playlist table view
    var playlistFirstAlternatingColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The second alternating color for the playlist table view
    var playlistSecondAlternatingColor : NSColor = NSColor(hexString: "#423B47")!;
    
    /// The default text color for playlist items
    var playlistTextColor : NSColor = NSColor(hexString: "#887F90")!;
    
    /// The default secondary text color for playlist items
    var playlistSecondaryTextColor : NSColor = NSColor(hexString: "#6C6473")!;
    
    /// The background color for the current item in the playlist
    var playlistCurrentSongBackgroundColor : NSColor = NSColor(hexString: "#665F6E")!;
    
    /// The default text color for the current playlist item
    var playlistCurrentSongTextColor : NSColor = NSColor(hexString: "#BAB5BF")!;
    
    /// The default secondary text color for the current playlist item
    var playlistCurrentSongSecondaryTextColor : NSColor = NSColor(hexString: "#9F97A5")!;
    
    /// The font size for the title label in playlist items(In points)
    var playlistTitleFontSize : CGFloat = 16;
    
    /// The font size for the artist label in playlist items(In points)
    var playlistArtistFontSize : CGFloat = 13;
    
    /// The default text color
    var textColor : NSColor = NSColor(hexString: "#887F90")!;
    
    /// The default secondary text color
    var secondaryTextColor : NSColor = NSColor(hexString: "#6C6473")!;
    
    /// The color for the left of the now playing progress slider
    var nowPlayingProgressCompletedColor : NSColor = NSColor(hexString: "#887F90")!;
    
    /// The color for the right of the now playing progress slider
    var nowPlayingProgressLeftOverColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The color for the current position and duration labels in the now playing panel
    var nowPlayingTimesTextColor : NSColor = NSColor(hexString: "#6C6473")!;
    
    /// The color for the background of the now playing view
    var nowPlayingViewBackgroundColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The color for the cover overlay in the now playing view(The panel that holds the media controls)
    var nowPlayingCoverOverlayBackgroundColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The font size for the now playing title(In points)
    var nowPlayingTitleFontSize : CGFloat = 15;
    
    /// The font size for the now playing artist(In points)
    var nowPlayingArtistFontSize : CGFloat = 13;
    
    /// The font size for the times(position and duration) labels in the now playing panel(In points)
    var nowPlayingTimesFontSize : CGFloat = 13;
    
    /// The image for the skip previous media icon
    var skipPreviousImage : NSImage = NSImage(named: "Skip Previous")!;
    
    /// The image for the skip next media icon
    var skipNextImage : NSImage = NSImage(named: "Skip Next")!;
    
    /// The image for the pause media icon
    var pauseImage : NSImage = NSImage(named: "Pause")!;
    
    /// The image for the play media icon
    var playImage : NSImage = NSImage(named: "Play")!;
    
    /// The color for the background of search fields
    var searchFieldBackgroundColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The text color for search fields
    var searchFieldTextColor : NSColor = NSColor(hexString: "#887F90")!;
    
    /// The placeholder text color for search fields
    var searchFieldPlaceholderTextColor : NSColor = NSColor(hexString: "#544E5A")!;
    
    /// The corner radius for search fields
    var searchFieldCornerRadius : CGFloat = 4.0;
    
    /// The font size for search fields(In points)
    var searchFieldFontSize : CGFloat = 13;
    
    /// The text color for the music browser item's text
    var musicBrowserItemTextColor : NSColor = NSColor(hexString: "#887F90")!;
    
    /// The color for the background of the selected item in the music browser
    var musicBrowserSelectionColor : NSColor = NSColor(hexString: "#2D2834")!;
    
    /// The minimum size for items in the music browser
    var musicBrowserMinimumItemSize : NSSize = NSSize(width: 200, height: 200);
    
    /// The maximum size for items in the music browser
    var musicBrowserMaximumItemSize : NSSize = NSSize(width: 250, height: 250);
    
    /// The corner radius for the selection box for music browser items
    var musicBrowserSelectionBoxCornerRadius : CGFloat = 5.0;
    
    /// The font size for the title of music browser items(In points)
    var musicBrowserItemTitleFontSize : CGFloat = 13;
    
    /// The color for the background of the playlist actions view
    var playlistActionsBackgroundColor : NSColor = NSColor(hexString: "#37333B")!;
    
    /// The image for the repeat button when repeat mode is off in the playlist actions view
    var playlistActionsRepeatOffImage : NSImage = NSImage(named: "Not Looping")!;
    
    /// The image for the repeat button when playlist repeat mode is on in the playlist actions view
    var playlistActionsRepeatPlaylistImage : NSImage = NSImage(named: "Playlist Looping")!;
    
    /// The image for the repeat button when song repeat mode is on in the playlist actions view
    var playlistActionsRepeatSongImage : NSImage = NSImage(named: "Song Looping")!;
    
    /// The image for the shuffle button in the playlist actions view
    var playlistActionsShuffleImage : NSImage = NSImage(named: "Playlist Shuffle")!;
    
    /// The image for the random button when random mode is on in the playlist actions view
    var playlistActionsRandomOnImage : NSImage = NSImage(named: "Playlist Random On")!;
    
    /// The image for the random button when random mode is off in the playlist actions view
    var playlistActionsRandomOffImage : NSImage = NSImage(named: "Playlist Random Off")!;
    
    /// Loads the theme from the given Sudachi theme folder(Extension must be .sctheme)
    func loadFromThemeFolder(var folderPath : String) {
        // If the folder exists...
        if(NSFileManager.defaultManager().fileExistsAtPath(folderPath)) {
            // If the extension is .sctheme...
            if(NSString(string: folderPath).pathExtension == "sctheme") {
                // If the last character in folderPath is a "/"...
                if(folderPath.substringFromIndex(folderPath.endIndex.predecessor()) == "/") {
                    // Remove the last character from folderPath
                    folderPath = folderPath.substringToIndex(folderPath.endIndex.predecessor());
                }
                
                // Load the theme
                // Load colors
                // If there is a colors.json...
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/colors.json")) {
                    /// The JSON object for the colors JSON
                    let colorsJson : JSON = JSON(data: NSFileManager.defaultManager().contentsAtPath(folderPath + "/colors.json")!);
                    
                    // Load the color values
                    // The if is to make sure its a valid color, and if it is it loads it
                    
                    if(NSColor(hexString: colorsJson["titlebar-color"].stringValue) != nil) {
                        self.titlebarColor = NSColor(hexString: colorsJson["titlebar-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["window-background-color"].stringValue) != nil) {
                        self.backgroundColor = NSColor(hexString: colorsJson["window-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["regular-text-color"].stringValue) != nil) {
                        self.textColor = NSColor(hexString: colorsJson["regular-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["secondary-text-color"].stringValue) != nil) {
                        self.secondaryTextColor = NSColor(hexString: colorsJson["secondary-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-first-alternation-color"].stringValue) != nil) {
                        self.playlistFirstAlternatingColor = NSColor(hexString: colorsJson["playlist-first-alternation-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-second-alternation-color"].stringValue) != nil) {
                        self.playlistSecondAlternatingColor = NSColor(hexString: colorsJson["playlist-second-alternation-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-regular-text-color"].stringValue) != nil) {
                        self.playlistTextColor = NSColor(hexString: colorsJson["playlist-regular-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-secondary-text-color"].stringValue) != nil) {
                        self.playlistSecondaryTextColor = NSColor(hexString: colorsJson["playlist-secondary-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-current-song-background-color"].stringValue) != nil) {
                        self.playlistCurrentSongBackgroundColor = NSColor(hexString: colorsJson["playlist-current-song-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-current-song-regular-text-color"].stringValue) != nil) {
                        self.playlistCurrentSongTextColor = NSColor(hexString: colorsJson["playlist-current-song-regular-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-current-song-secondary-text-color"].stringValue) != nil) {
                        self.playlistCurrentSongSecondaryTextColor = NSColor(hexString: colorsJson["playlist-current-song-secondary-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["now-playing-progress-bar-background-color"].stringValue) != nil) {
                        self.nowPlayingProgressLeftOverColor = NSColor(hexString: colorsJson["now-playing-progress-bar-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["now-playing-progress-bar-completed-color"].stringValue) != nil) {
                        self.nowPlayingProgressCompletedColor = NSColor(hexString: colorsJson["now-playing-progress-bar-completed-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["now-playing-time-text-color"].stringValue) != nil) {
                        self.nowPlayingTimesTextColor = NSColor(hexString: colorsJson["now-playing-time-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["now-playing-background-color"].stringValue) != nil) {
                        self.nowPlayingViewBackgroundColor = NSColor(hexString: colorsJson["now-playing-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["now-playing-media-panel-background-color"].stringValue) != nil) {
                        self.nowPlayingCoverOverlayBackgroundColor = NSColor(hexString: colorsJson["now-playing-media-panel-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["search-field-background-color"].stringValue) != nil) {
                        self.searchFieldBackgroundColor = NSColor(hexString: colorsJson["search-field-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["search-field-placeholder-text-color"].stringValue) != nil) {
                        self.searchFieldPlaceholderTextColor = NSColor(hexString: colorsJson["search-field-placeholder-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["search-field-text-color"].stringValue) != nil) {
                        self.searchFieldTextColor = NSColor(hexString: colorsJson["search-field-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["music-browser-item-text-color"].stringValue) != nil) {
                        self.musicBrowserItemTextColor = NSColor(hexString: colorsJson["music-browser-item-text-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["music-browser-selection-background-color"].stringValue) != nil) {
                        self.musicBrowserSelectionColor = NSColor(hexString: colorsJson["music-browser-selection-background-color"].stringValue)!;
                    }
                    
                    if(NSColor(hexString: colorsJson["playlist-actions-background-color"].stringValue) != nil) {
                        self.playlistActionsBackgroundColor = NSColor(hexString: colorsJson["playlist-actions-background-color"].stringValue)!;
                    }
                }
                
                // Load the font and size settings
                // If there is a fonts.json...
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/fonts.json")) {
                    /// The JSON object for the fonts JSON
                    let fontsJson : JSON = JSON(data: NSFileManager.defaultManager().contentsAtPath(folderPath + "/fonts.json")!);
                    
                    // Load the font and font values
                    
                    // Load basic appearance settings
                    // Set the font family
                    if(fontsJson["font-family"].exists()) {
                        fontFamily = fontsJson["font-family"].stringValue;
                    }
                    
                    // Set if the font is antialiased
                    if(fontsJson["antialiased"].exists()) {
                        antialiasFont = fontsJson["antialiased"].boolValue;
                    }
                    
                    // Update the font antialiasing
                    setFontAntialiasing();
                    
                    // Load the font sizes
                    // For each one it checks if the value exists and then if it does loads it into it's respective value
                    
                    if(fontsJson["playlist-item-primary-font-size"].exists()) {
                        playlistTitleFontSize = CGFloat(fontsJson["playlist-item-primary-font-size"].floatValue);
                    }
                    
                    if(fontsJson["playlist-item-secondary-font-size"].exists()) {
                        playlistArtistFontSize = CGFloat(fontsJson["playlist-item-secondary-font-size"].floatValue);
                    }
                    
                    if(fontsJson["now-playing-title-font-size"].exists()) {
                        nowPlayingTitleFontSize = CGFloat(fontsJson["now-playing-title-font-size"].floatValue);
                    }
                    
                    if(fontsJson["now-playing-artist-font-size"].exists()) {
                        nowPlayingArtistFontSize = CGFloat(fontsJson["now-playing-artist-font-size"].floatValue);
                    }
                    
                    if(fontsJson["now-playing-times-font-size"].exists()) {
                        nowPlayingTimesFontSize = CGFloat(fontsJson["now-playing-times-font-size"].floatValue);
                    }
                    
                    if(fontsJson["search-field-font-size"].exists()) {
                        searchFieldFontSize = CGFloat(fontsJson["search-field-font-size"].floatValue);
                    }
                    
                    if(fontsJson["music-browser-item-title-font-size"].exists()) {
                        musicBrowserItemTitleFontSize = CGFloat(fontsJson["music-browser-item-title-font-size"].floatValue);
                    }
                }
                
                // Load images
                // If there is a pause image...
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/pause.png")) {
                    // Load the pause image
                    self.pauseImage = NSImage(contentsOfFile: folderPath + "/pause.png")!;
                }
                
                // Im not commenting the rest of this, the above explains how it works
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/play.png")) {
                    self.playImage = NSImage(contentsOfFile: folderPath + "/play.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/skip-next.png")) {
                    self.skipNextImage = NSImage(contentsOfFile: folderPath + "/skip-next.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/skip-previous.png")) {
                    self.skipPreviousImage = NSImage(contentsOfFile: folderPath + "/skip-previous.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/music-file-icon.png")) {
                    self.musicFileIcon = NSImage(contentsOfFile: folderPath + "/music-file-icon.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/folder-icon.png")) {
                    self.folderIcon = NSImage(contentsOfFile: folderPath + "/folder-icon.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/folder-back-icon.png")) {
                    self.folderBackIcon = NSImage(contentsOfFile: folderPath + "/folder-back-icon.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/repeat-off.png")) {
                    self.playlistActionsRepeatOffImage = NSImage(contentsOfFile: folderPath + "/repeat-off.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/repeat-playlist.png")) {
                    self.playlistActionsRepeatPlaylistImage = NSImage(contentsOfFile: folderPath + "/repeat-playlist.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/repeat-song.png")) {
                    self.playlistActionsRepeatSongImage = NSImage(contentsOfFile: folderPath + "/repeat-song.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/shuffle.png")) {
                    self.playlistActionsShuffleImage = NSImage(contentsOfFile: folderPath + "/shuffle.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/random-off.png")) {
                    self.playlistActionsRandomOffImage = NSImage(contentsOfFile: folderPath + "/repeat-off.png")!;
                }
                
                if(NSFileManager.defaultManager().fileExistsAtPath(folderPath + "/random-on.png")) {
                    self.playlistActionsRandomOnImage = NSImage(contentsOfFile: folderPath + "/repeat-on.png")!;
                }
            }
            // If the extension isnt .sctheme...
            else {
                // Print to the log that the theme folder needs the .sctheme extension
                print("SCThemingEngine: Sudachi theme folder \"\(folderPath)\" needs a .sctheme extension to be loaded");
            }
        }
        // If the folder doesnt exist...
        else {
            // Print to the log that the theme folder doesnt exist
            print("SCThemingEngine: Sudachi theme folder doesnt exist at path \"\(folderPath)\"");
        }
    }
    
    /// Sets the family of the given font to the theme's font family while retaining previous values like weight, and returns the font
    func setFontFamily(font : NSFont, size : CGFloat) -> NSFont {
        // Update the font antialiasing
        setFontAntialiasing();
        
        // If the theme font family is set...
        if(fontFamily != "") {
            /// The given font with the modified font family and size
            let newFont : NSFont? = NSFont(name: fontFamily, size: size);
            
            // If the new font isnt nil...
            if(newFont != nil) {
                // Return the new font
                return newFont!;
            }
            // If the new font is nil...
            else {
                // Return the unmodified font
                return font;
            }
        }
        // If the theme font family isnt set...
        else {
            // Return the unmodified font
            return font;
        }
    }
    
    /// Updates the application's font antialiasing based on antialiasFont
    func setFontAntialiasing() {
        // If we said not to antialias the font...
        if(!antialiasFont) {
            // Disable font antialiasing on the font(And the whole application)(This has to be dont so the font smoothing is disabled and we can get a non-antialiased font)
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "AppleFontSmoothing");
        }
            // If we said to antialias the font...
        else {
            // Set the font smoothing to default
            NSUserDefaults.standardUserDefaults().setValue(3, forKey: "AppleFontSmoothing");
        }
        
        // Synchronize the user defaults
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    /// Returns the default theming engine
    func defaultEngine() -> SCThemingEngine {
        return SCThemingEngineStruct.defaultEngine;
    }
}

struct SCThemingEngineStruct {
    /// The default theming engine for the app
    static var defaultEngine : SCThemingEngine = SCThemingEngine();
}
