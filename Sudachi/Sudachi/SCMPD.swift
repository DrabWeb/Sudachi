//
//  SCMPD.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import AVFoundation

/// The main controller for interacting with MPD
class SCMPD {
    /// The path to the user's MPD music folder
    var mpdFolderPath : String = "";
    
    /// Clears the current playlist
    func clearCurrentPlaylist() {
        // Run the "mpc clear" command
        runMpcCommand(["clear"], waitUntilExit: true, log: true);
    }
    
    /// Removes all the songs in between begin and end from the current playlist(Index starts at 1, not 0)
    func removeSongsInCurrentPlaylistBetween(begin : Int, end : Int) {
        // Run the del command with the given range
        runMpcCommand(["del", String(begin) + "-" + String(end)], waitUntilExit: true, log: false);
    }
    
    /// Removes the song at the given index in the current playlist(Index starts at 1, not 0)
    func removeSongInCurrentPlaylistAtIndex(index : Int) {
        // Run the del command with the given index
        runMpcCommand(["del", String(index)], waitUntilExit: true, log: false);
    }
    
    /// TODO: Fix an odd bug where when you jump to a track and it finishes, it plays the one after the one you jumped from
    /// Plays the song at the given index in the current playlist(Index starts at 1, not 0)
    func playSongInCurrentPlaylistAtIndex(index : Int) {
        // Run the play command with the given index
        runMpcCommand(["play", String(index)], waitUntilExit: true, log: false);
    }
    
    /// Adds the given song to the end of the current playlist, and puts it right after the current playing song if insert is true
    func addSongToPlaylist(song : SCSong, insert : Bool) {
        // If we said to insert the song...
        if(insert) {
            // Run the insert command with the song's relative directory to the MPD folder path
            runMpcCommand(["insert", song.filePath.stringByReplacingOccurrencesOfString(mpdFolderPath, withString: "")], waitUntilExit: true, log: false);
        }
        // If we said to just add the song
        else {
            // Run the add command with the song's relative directory to the MPD folder path
            runMpcCommand(["add", song.filePath.stringByReplacingOccurrencesOfString(mpdFolderPath, withString: "")], waitUntilExit: true, log: true);
        }
    }
    
    /// Jumps to the given position in the current song
    func jumpToPosition(position : SCSongTime) {
        // Print to the log where we are jumping to
        print("Jumping to \(position.string)");
        
        // Seek to the given position
        runMpcCommand(["seek", position.string], waitUntilExit: false, log: false);
    }
    
    /// Returns the SCSongTime the user is at in the current playing song
    func getCurrentSongPosition() -> SCSongTime {
        /// The time the user is at in the current song
        var songPosition : SCSongTime = SCSongTime();
        
        /// The raw output of the second line from "mpc status", split at every " "
        let statusRawOutput : [String] = runMpcCommand(["status"], waitUntilExit: false, log: false).componentsSeparatedByString("\n")[1].componentsSeparatedByString(" ");
        
        // For every item in statusRawOutput...
        for(_, currentItem) in statusRawOutput.enumerate() {
            // If the current item contains a ":"(Should always mean that it's a time)
            if(currentItem.containsString(":")) {
                /// currentItem without any spaces
                let currentItemModified : String = currentItem.stringByReplacingOccurrencesOfString(" ", withString: "");
                
                // If currentItemModified contains any slashes...
                if(currentItemModified.containsString("/")) {
                    // Set the song position to the string before the "/" in currentItemModified
                    songPosition = SCSongTime(string: currentItemModified.componentsSeparatedByString("/")[0]);
                }
            }
        }
        
        // Return the song position
        return songPosition;
    }
    
    /// The current playing/paused status
    var status : SCMPDStatus = .Paused;
    
    /// Updates status to match the current state
    func updateStatus() {
        /// The raw output of the second line from "mpc status"
        let statusRawOutput : String = runMpcCommand(["status"], waitUntilExit: false, log: true).componentsSeparatedByString("\n")[1];
        
        // If the raw output has a "[" and "]"...
        if(statusRawOutput.containsString("[") && statusRawOutput.containsString("]")) {
            /// The index of "]" in statusRawOutput
            let endCharacterIndex : Range = statusRawOutput.rangeOfString("]")!;
            
            /// The string before the "]" and after the "[" in statusRawOutput
            let statusString : String = statusRawOutput.substringToIndex(endCharacterIndex.first!).substringFromIndex(statusRawOutput.substringToIndex(endCharacterIndex.first!).startIndex.successor());
            
            // If the status string is "playing"...
            if(statusString == "playing") {
                // Set the status to Playing
                status = .Playing;
            }
            // If the status string is "paused"...
            else if(statusString == "paused") {
                // Set the status to paused
                status = .Paused;
            }
            // If the status string is anything else...
            else {
                // Set the status to stopped
                status = .Stopped;
            }
        }
        // If statusRawOutput doesnt have a "[" and "]..."
        else {
            // Set the status to stopped
            status = .Stopped;
        }
    }
    
    /// Toggles between play and pause
    func togglePlayPause() {
        // Tell MPC to toggle
        runMpcCommand(["toggle"], waitUntilExit: true, log: true);
        
        // Update the status
        updateStatus();
    }
    
    /// Pauses the current song
    func pause() {
        // Tell MPC to pause
        runMpcCommand(["pause"], waitUntilExit: true, log: true);
        
        // Update the status
        updateStatus();
    }
    
    /// Plays the current song
    func play() {
        // Tell MPC to play
        runMpcCommand(["play"], waitUntilExit: true, log: true);
        
        // Update the status
        updateStatus();
    }
    
    /// Skips to the next song
    func skipNext() {
        // Skip to the next song
        runMpcCommand(["next"], waitUntilExit: true, log: true);
        
        // Update the status
        updateStatus();
    }
    
    /// Skips to the previous song
    func skipPrevious() {
        // Skip to the previous song
        runMpcCommand(["prev"], waitUntilExit: true, log: true);
        
        // Update the status
        updateStatus();
    }
    
    /// The last playlist fetched with getCurrentPlaylist
    var currentPlaylist : [SCSong] = [];
    
    /// Returns the current playlist, and also loads the images for them if loadCoverImages is true
    func getCurrentPlaylist(loadCoverImages : Bool) -> [SCSong] {
        /// The current playlist
        var currentPlaylist : [SCSong] = [];
        
        /// The raw output of "mpc playlist --format "%title% .:'':. %artist% .:'':. %file% .:'':. %duration%", split at every new line
        let currentPlaylistRaw : [String] = runMpcCommand(["playlist", "--format", "%title% .:'':. %artist% .:'':. %file% .:'':. %time%"], waitUntilExit: true, log: true).componentsSeparatedByString("\n");
        
        // For every item in currentPlaylistRaw...
        for(_, currentItem) in currentPlaylistRaw.enumerate() {
            /// The current song
            let currentSong : SCSong = SCSong();
            
            /// The output of the MPC current command(first line), split at every ".:'':."(The separator)
            let currentRaw : [String] = currentItem.componentsSeparatedByString(" .:'':. ");
            
            // If currentRaw has at least 4 items...
            if(currentRaw.count >= 4) {
                // Set the song's title to the first value in currentRaw
                currentSong.title = currentRaw[0];
                
                // If the artist value isnt blank...
                if(currentRaw[1] != "") {
                    // Set the song's title to the second value in currentRaw
                    currentSong.artist = currentRaw[1];
                }
                
                // Get the cover image
                // Set the path of the song
                currentSong.filePath = mpdFolderPath + currentRaw[2];
                
                // If we said to load cover images...
                if(loadCoverImages) {
                    // Load the cover image
                    currentSong.coverImage = currentSong.getCoverImage();
                }
                
                // Set the duration
                currentSong.duration = SCSongTime(string: currentRaw[3]);
                
                // If the current song's title is blank...
                if(currentSong.title == "") {
                    // Set the title to the filename without the extension
                    currentSong.title = NSString(string: currentSong.filePath).lastPathComponent.stringByReplacingOccurrencesOfString("." + NSString(string: currentSong.filePath).pathExtension, withString: "");
                }
                
                // Add the current item to the current playlist array
                currentPlaylist.append(currentSong);
            }
        }
        
        // Set the current playlist
        self.currentPlaylist = currentPlaylist;
        
        // Return the current playlist
        return currentPlaylist;
    }
    
    /// The last song fetched with getCurrentSong
    var currentSong : SCSong = SCSong();
    
    /// Returns the current playing song, and also loads the images for them if loadCoverImage is true
    func getCurrentSong(loadCoverImage : Bool) -> SCSong {
        /// The current song
        let currentPlayingSong : SCSong = SCSong();
        
        /// The output of the MPC current command(first line), split at every ".:'':."(The separator)
        let currentRaw : [String] = runMpcCommand(["--format", "%title% .:'':. %artist% .:'':. %file% .:'':. %time%"], waitUntilExit: true, log: true).componentsSeparatedByString("\n")[0].componentsSeparatedByString(" .:'':. ");
        
        // If currentRaw has at least 4 items...
        if(currentRaw.count >= 4) {
            // Set the song's title to the first value in currentRaw
            currentPlayingSong.title = currentRaw[0];
            
            // If the artist value isnt blank...
            if(currentRaw[1] != "") {
                // Set the song's title to the second value in currentRaw
                currentPlayingSong.artist = currentRaw[1];
            }
            
            // Get the cover image
            // Set the path of the song
            currentPlayingSong.filePath = mpdFolderPath + currentRaw[2];
            
            // If we said to load cover images...
            if(loadCoverImage) {
                // Load the cover image
                currentPlayingSong.coverImage = currentPlayingSong.getCoverImage();
            }
            
            // Set the duration
            currentPlayingSong.duration = SCSongTime(string: currentRaw[3]);
            
            // If the current song's title is blank...
            if(currentPlayingSong.title == "") {
                // Set the title to the filename without the extension
                currentPlayingSong.title = NSString(string: currentPlayingSong.filePath).lastPathComponent.stringByReplacingOccurrencesOfString("." + NSString(string: currentPlayingSong.filePath).pathExtension, withString: "");
            }
        }
        
        // Set currentSong
        currentSong = currentPlayingSong;
        
        // Update the status
        updateStatus();
        
        // Return the playing song
        return currentPlayingSong;
    }
    
    /// Runs SCCommandUtilities.runCommand with a launch path of MPC and the given arguments. Also logs to the console the command if log is true
    func runMpcCommand(arguments : [String], waitUntilExit : Bool, log : Bool) -> String {
        // Run the command
        return SCCommandUtilities().runCommand(NSBundle.mainBundle().bundlePath + "/Contents/Resources/mpc", arguments: arguments, waitUntilExit: waitUntilExit, log: log);
    }
}

/// Used for referencing if MPD is playing or paused
enum SCMPDStatus {
    case Playing
    case Paused
    case Stopped
}
