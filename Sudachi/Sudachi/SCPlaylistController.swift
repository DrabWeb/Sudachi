//
//  SCPlaylistController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-03.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// Controls displaying the playlist to the user and allowing them to edit it
class SCPlaylistController: NSObject {
    /// The main view controller for the main window(The one this is in)
    @IBOutlet weak var mainViewController: ViewController!
    
    /// All the items in the playlist
    var playlistItems : [SCPlaylistTableViewData] = [];
    
    /// Returns playlistItems as an array of SCSongs
    var playlistItemsAsSCSongArray : [SCSong] {
        /// The array of SCSongs that will be returned
        var playlistSongArray : [SCSong] = [];
        
        // For every item in playlistItems
        for(_, currentPlaylistItem) in playlistItems.enumerate() {
            // Add the current playlist item to playlistItems
            playlistSongArray.append(currentPlaylistItem.song);
        }
        
        // Return the playlist songs
        return playlistSongArray;
    }
    
    /// The table view for displaying the playlist to the user
    @IBOutlet weak var playlistTableView: SCPlaylistTableView!
    
    /// Returns the index of the given song in playlistItems
    func indexOfSongInPlaylistItems(song : SCSong) -> Int {
        /// playlistItems as an NSMutableArray(So we can get the index of song)
        let playlistItemsMutableArray : NSMutableArray = NSMutableArray(array: playlistItemsAsSCSongArray);
            
        /// Return the index of the given song
        return playlistItemsMutableArray.indexOfObject(song);
    }
    
    /// Calls SCMPD.clearCurrentPlaylist
    func clearCurrentPlaylist() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.clearCurrentPlaylist();
    }
    
    /// Plays the selected item in the playlist table view(If it is the first responder)
    func playSelectedItemFromPlaylist() {
        // If the playlist table view is the first responder and there is at least one row selected...
        if(mainViewController.window.firstResponder == playlistTableView && playlistTableView.selectedRow != -1) {
            // Call play playlist song with the selected item's song
            playPlaylistItem(playlistItemsAsSCSongArray[playlistTableView.selectedRow]);
        }
    }
    
    /// Removes the selected items in the playlist table view from the current playlist(If it is the first responder)
    func removeSelectedItemsFromPlaylist() {
        // If the playlist table view is the first responder and there is at least one row selected...
        if(mainViewController.window.firstResponder == playlistTableView && playlistTableView.selectedRow != -1) {
            // Remove the selected songs from the playlist
            (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.removeSongsInCurrentPlaylistBetween(playlistTableView.selectedRowIndexes.firstIndex + 1, end: playlistTableView.selectedRowIndexes.lastIndex + 1);
            
            // Update the playlist and now playing
            mainViewController.updatePlaylistAndNowPlaying();
        }
    }
    
    /// Scrolls to the current song in playlistTableView
    func scrollToCurrentSong() {
        // If playlistItems isnt blank...
        if(!playlistItems.isEmpty) {
            /// The index of the current song in playlistItems
            let indexOfSong : Int = indexOfSongInPlaylistItems((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong);
            
            // If the item was in playlistItems...
            if(indexOfSong != 9223372036854775807) {
                // Scroll to the current song
                playlistTableView.scrollRectToVisible(playlistTableView.rectOfRow(indexOfSong));
            }
        }
    }
    
    /// Removes playing the given SCSong from the playlist
    func removePlaylistItem(song : SCSong) {
        // If playlistItems isnt blank...
        if(!playlistItems.isEmpty) {
            /// The index of song in playlistItems
            let indexOfSong : Int = indexOfSongInPlaylistItems(song) + 1;
            
            // If the item was in playlistItems...
            if(indexOfSong != 9223372036854775807) {
                // Remove the given song
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.removeSongInCurrentPlaylistAtIndex(indexOfSong);
            }
            // If the item wasnt in playlistItems...
            else {
                // Print to the log that we cant jump to a non-existent song
                print("SCPlaylistController: Cant remove playlist song \"\(song.title)\", no such song exists in the playlist(Invalid index)");
            }
            
            // Update the playlist and now playing
            mainViewController.updatePlaylistAndNowPlaying();
        }
        // If playlistItems is blank...
        else {
            // Print to the log that we cant jump to a non-existent song
            print("SCPlaylistController: Cant remove playlist song \"\(song.title)\", no such song exists in the playlist(Playlist is blank)");
        }
    }
    
    /// Begins playing the given SCSong from the playlist
    func playPlaylistItem(song : SCSong) {
        // If playlistItems isnt blank...
        if(!playlistItems.isEmpty) {
            /// The index of song in playlistItems
            let indexOfSong : Int = indexOfSongInPlaylistItems(song) + 1;
            
            // If the item was in playlistItems...
            if(indexOfSong != 9223372036854775807) {
                // Play the given song
                (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.playSongInCurrentPlaylistAtIndex(indexOfSong);
            }
            // If the item wasnt in playlistItems...
            else {
                // Print to the log that we cant jump to a non-existent song
                print("SCPlaylistController: Cant jump to playlist song \"\(song.title)\", no such song exists in the playlist(Invalid index)");
            }
            
            // Update the playlist and now playing
            mainViewController.updatePlaylistAndNowPlaying();
        }
        // If playlistItems is blank...
        else {
            // Print to the log that we cant jump to a non-existent song
            print("SCPlaylistController: Cant jump to playlist song \"\(song.title)\", no such song exists in the playlist(Playlist is blank)");
        }
    }
    
    /// Loads the current MPD playlist into the table view
    func loadCurrentPlaylist() {
        // Load the current playlist
        loadSongArray((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getCurrentPlaylist(false));
    }
    
    /// Loads the songs in the given array into the table view(Clears it first)
    func loadSongArray(songArray : [SCSong]) {
        // Clear all the current items
        playlistItems.removeAll();
        
        // Load the current playlist
        for(_, currentPlaylistItem) in songArray.enumerate() {
            // Add the current playlist item to playlistItems
            playlistItems.append(SCPlaylistTableViewData(song: currentPlaylistItem));
        }
        
        // Reload the table view
        playlistTableView.reloadData();
    }
    
    /// Is the playlist allowed to update?
    var canUpdate : Bool = true;
    
    /// Tells the playlist to update
    func update() {
        // If we can update...
        if(canUpdate) {
            // Load the current playlist
            loadCurrentPlaylist();
        }
    }
    
    /// Sets up the menu items for this controller
    func setupMenuItems() {
        // Setup the menu items
        // Set the targets
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemPlaySelectedPlaylistItem.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemRemoveSelectedPlaylistItem.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemClearPlaylist.target = self;
        
        // Set the actions
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemPlaySelectedPlaylistItem.action = Selector("playSelectedItemFromPlaylist");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemRemoveSelectedPlaylistItem.action = Selector("removeSelectedItemsFromPlaylist");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemClearPlaylist.action = Selector("clearCurrentPlaylist");
    }
    
    func initialize() {
        // Update the playlist
        update();
        
        // Get the current song
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.getCurrentSong(false);
        
        // Setup the menu items
        setupMenuItems();
        
        // Scroll to the current song
        scrollToCurrentSong();
    }
}

extension SCPlaylistController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        // Return the amount of items in playlistItems
        return self.playlistItems.count;
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        /// The cell view for the cell we want to modify
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: nil) as! NSTableCellView;
        
        // If this is the main column...
        if(tableColumn!.identifier == "Main Column") {
            /// cellView as a SCPlaylistTableCellView
            let cellViewPlaylistTableCellView : SCPlaylistTableCellView = cellView as! SCPlaylistTableCellView;
            
            /// The data for this cell
            let cellData : SCPlaylistTableViewData = playlistItems[row];
            
            // Set if the song is currently playing
            cellData.current = cellData.song.equals((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.currentSong);
            
            // Load in the data to the cell
            cellViewPlaylistTableCellView.loadDataFromData(cellData);
            
            // Return the modified cell view
            return cellView;
        }
        
        // Return the unmodified cell view, we dont need to do anything
        return cellView;
    }
}

extension SCPlaylistController: NSTableViewDelegate {
    
}