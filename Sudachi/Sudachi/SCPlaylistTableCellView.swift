//
//  SCPlaylistTableCellView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-03.
//

import Cocoa

class SCPlaylistTableViewRowView : NSTableRowView {
    
    /// The previous background color of this row
    var previousBackgroundColor : NSColor = NSColor.clearColor();
    
    override var selected : Bool {
        didSet {
            // If this item isnt selected and the previous background color wasnt clear...
            if(!self.selected && previousBackgroundColor != NSColor.clearColor()) {
                // If the first subview of this row is a SCPlaylistTableCellView...
                if((self.subviews[0] as? SCPlaylistTableCellView) != nil) {
                    // Set the row's background color back to it's pre-selection color
                    (self.subviews[0] as! SCPlaylistTableCellView).layer?.backgroundColor = previousBackgroundColor.CGColor;
                }
            }
        }
    }
    
    override func drawSelectionInRect(dirtyRect: NSRect) {
        // If the selection style isn't none...
        if(self.selectionHighlightStyle != NSTableViewSelectionHighlightStyle.None) {
            // If the first subview of this row is a SCPlaylistTableCellView...
            if((self.subviews[0] as? SCPlaylistTableCellView) != nil) {
                // Store the rows current background color in previousBackgroundColor
                previousBackgroundColor = NSColor(CGColor: ((self.subviews[0] as! SCPlaylistTableCellView).layer?.backgroundColor)!)!;
                
                // Set the row's background color to clear
                (self.subviews[0] as! SCPlaylistTableCellView).layer?.backgroundColor = NSColor.clearColor().CGColor;
            }
            
            /// The NSRect to draw the selection box in
            let selectionRect : NSRect = self.bounds;
            
            // Set the fill color
            SCThemingEngine().defaultEngine().playlistSelectedItemBackgroundColor.setFill();
            
            /// The bezier path to draw the selection box in
            let selectionPath : NSBezierPath = NSBezierPath(rect: selectionRect);
            
            // Draw the box
            selectionPath.fill();
        }
    }
}

class SCPlaylistTableCellView: NSTableCellView {
    
    /// The song this cell represents
    var representedSong : SCSong = SCSong();
    
    /// The label for showing the song's title
    @IBOutlet var titleLabel: NSTextField!
    
    /// The label for showing the song's artist
    @IBOutlet var artistLabel: NSTextField!
    
    /// Is this playlist item the current song?
    var current : Bool = false;
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Make the background of the row clear so we get the custom alternating row colors
        (self.superview as? NSTableRowView)?.backgroundColor = NSColor.clearColor();
    }
    
    override func menuForEvent(event: NSEvent) -> NSMenu? {
        /// The right click menu for this cell
        let menu : NSMenu = NSMenu();
        
        // Add the play menu item
        menu.addItem(NSMenuItem(title: "Play", action: Selector("playSelf"), keyEquivalent: ""));
        
        // Add the remove menu item
        menu.addItem(NSMenuItem(title: "Remove From Playlist", action: Selector("removeSelf"), keyEquivalent: ""));
        
        // Return the menu
        return menu;
    }
    
    override func mouseDown(theEvent: NSEvent) {
        // If we double clicked...
        if(theEvent.clickCount == 2) {
            // Play this song
            playSelf();
        }
    }
    
    /// Starts playing this song
    func playSelf() {
        /// The SCPlaylistController for this cell
        let playlistController : SCPlaylistController = ((self.superview?.superview as? NSTableView)?.delegate() as? SCPlaylistController)!;
        
        // Play this item's song
        playlistController.playPlaylistItem(representedSong);
    }
    
    /// Removes this song from the current playlist
    func removeSelf() {
        /// The SCPlaylistController for this cell
        let playlistController : SCPlaylistController = ((self.superview?.superview as? NSTableView)?.delegate() as? SCPlaylistController)!;
        
        // Remove this item's song
        playlistController.removePlaylistItem(representedSong);
    }
    
    /// Loads the data from the given SCPlaylistTableViewData into the cell
    func loadDataFromData(data : SCPlaylistTableViewData) {
        // Load the theme
        loadTheme();
        
        // Load the data
        self.titleLabel.stringValue = data.song.title;
        self.setArtistLabelTitle(data.song.artist);
        
        // Set the represented song
        representedSong = data.song;
        
        // Set if this item is current
        self.current = data.current;
        
        // Update the background color
        updateBackgroundColor();
    }
    
    /// Updates the background color of this item based on if this song is the current playing song
    func updateBackgroundColor() {
        // If this song is the current song...
        if(self.current) {
            // Set the background color to the current playlist item color
            self.layer?.backgroundColor = SCThemingEngine().defaultEngine().playlistCurrentSongBackgroundColor.CGColor;
            
            // Update the label colors
            titleLabel.textColor = SCThemingEngine().defaultEngine().playlistCurrentSongTextColor;
            artistLabel.textColor = SCThemingEngine().defaultEngine().playlistCurrentSongSecondaryTextColor;
        }
        // If this is not the current song...
        else {
            // Make the background clear
            self.layer?.backgroundColor = NSColor.clearColor().CGColor;
            
            // Restore the label colors
            titleLabel.textColor = SCThemingEngine().defaultEngine().playlistTextColor;
            artistLabel.textColor = SCThemingEngine().defaultEngine().playlistSecondaryTextColor;
        }
    }
    
    /// Sets the artist label to say "by" in front of the given artist name
    func setArtistLabelTitle(artistName : String) {
        // Set the label
        artistLabel.stringValue = "by " + artistName;
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the label colors
        titleLabel.textColor = SCThemingEngine().defaultEngine().playlistTextColor;
        artistLabel.textColor = SCThemingEngine().defaultEngine().playlistSecondaryTextColor;
        
        // Set the fonts
        titleLabel.font = SCThemingEngine().defaultEngine().setFontFamily(titleLabel.font!, size: SCThemingEngine().defaultEngine().playlistTitleFontSize);
        artistLabel.font = SCThemingEngine().defaultEngine().setFontFamily(artistLabel.font!, size: SCThemingEngine().defaultEngine().playlistArtistFontSize);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        // Set the view to want a layer
        self.wantsLayer = true;
    }
}
