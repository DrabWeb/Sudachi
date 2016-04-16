//
//  SCSong.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import AVFoundation

class SCSong: NSObject {
    /// The cover image for the song
    var coverImage : NSImage = SCThemingEngine().defaultEngine().musicFileIcon;
    
    /// The title of the song
    var title : String = "No song";
    
    /// The name of the song's artist
    var artist : String = "Unknown";
    
    /// The genre of this song
    var genre : String = "";
    
    /// The duration of the song
    var duration : SCSongTime = SCSongTime();
    
    /// The path to this song
    var filePath : String = "";
    
    // Override the print description
    override var description : String {
        return "Sudachi.SCSong: \"\(title)\" by \"\(artist)\" at \"\(filePath)\"";
    }
    
    /// Returns the cover image for this song
    func getCoverImage() -> NSImage {
        /// The cover image to return
        var songCoverImage : NSImage = SCThemingEngine().defaultEngine().musicFileIcon;
        
        /// The AVFoundation asset for this song
        let songAsset : AVURLAsset = AVURLAsset(URL: NSURL(fileURLWithPath: filePath));
        
        /// For every tag in this song's tags...
        for currentTag:AVMetadataItem in songAsset.metadataForFormat(AVMetadataFormatID3Metadata) as Array<AVMetadataItem> {
            // If the current tag is the artwork tag...
            if(currentTag.commonKey == "artwork") {
                // Set the cover image to this tag's image
                songCoverImage = NSImage(data: currentTag.dataValue!)!;
            }
        }
        
        // Return the cover image
        return songCoverImage;
    }
    
    /// Does the given SCSong equal this song?
    func equals(song : SCSong) -> Bool {
        // Return if all the values match
        return (self.title == song.title) && (self.artist == song.artist) && (self.filePath == song.filePath);
    }
}

/// Used for referring to song lengths/time
class SCSongTime {
    /// The time's hour component
    var hours : Int = 0;
    
    /// The time's minute component
    var minutes : Int = 0;
    
    /// The time's seconds component
    var seconds : Int = 0;
    
    /// Updates the song time(E.g. if seconds is above sixty it will properly deal with that)
    func updateTime() {
        /// The date components for this song time
        let dateComponents : NSDateComponents = NSDateComponents();
        
        // Set the hour minute and second
        dateComponents.hour = hours;
        dateComponents.minute = minutes;
        dateComponents.second = seconds;
        
        /// The gregorian calendar
        let calendar : NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!;
        
        /// The date of dateComponents
        let date : NSDate = calendar.dateFromComponents(dateComponents)!;
        
        /// The date components of date
        let updatedDateComponents : NSDateComponents = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date);
        
        // Set the hours minutes and seconds
        hours = updatedDateComponents.hour;
        minutes = updatedDateComponents.minute;
        seconds = updatedDateComponents.second;
    }
    
    /// Returns this time in seconds
    func toSeconds() -> Int {
        // Return hours * 60 * 60 + minutes * 60 + seconds
        return ((hours * 60) * 60) + (minutes * 60) + (seconds);
    }
    
    /// Subtracts the given time from this time, and returns the output
    func minus(time : SCSongTime) -> SCSongTime {
        // Return this time's seconds minus the subtraction time's seconds as an SCSongTime
        return SCSongTime(hours: 0, minutes: 0, seconds: self.toSeconds() - time.toSeconds());
    }
    
    /// The value of this SCSongTime in a readable format
    var string : String {
        /// Should we show the hour?
        let showHour : Bool = (hours != 0);
        
        /// The second value to show
        var secondsValue : String = "";
        
        // If the seconds is less than 10...
        if(seconds < 10) {
            // Set the seconds value to the seconds with a 0 in front
            secondsValue = "0" + String(seconds);
        }
        else {
            // Set the seconds value to seconds
            secondsValue = String(seconds);
        }
        
        // If we said to show hours...
        if(showHour) {
            /// The minute value to show
            var minutesValue : String = "";
            
            // If the minutes is less than 10...
            if(minutes < 10) {
                // Set the minutes value to the minutes with a 0 in front
                minutesValue = "0" + String(minutes);
            }
            else {
                // Set the minutes value to minutes
                minutesValue = String(minutes);
            }
            
            // Return the string
            return String(hours) + ":" + minutesValue + ":" + secondsValue;
        }
        // If we said to not show hours...
        else {
            // Return the string
            return String(minutes) + ":" + secondsValue;
        }
    }
    
    // Blank init
    init() {
        self.hours = 0;
        self.minutes = 0;
        self.seconds = 0;
    }
    
    // Init with a string
    convenience init(string : String) {
        /// String split at every ":"
        let stringSplit : [String] = string.componentsSeparatedByString(":");
        
        // Do a blank init
        self.init();
        
        // If stringSplit has 2 items...
        if(stringSplit.count == 2) {
            // Set the hours seconds and minutes
            self.minutes = NSString(string: stringSplit[0]).integerValue;
            self.seconds = NSString(string: stringSplit[1]).integerValue;
        }
        // If stringSplit has 3 items...
        else if(stringSplit.count == 3) {
            // Set the hours seconds and minutes
            self.hours = NSString(string: stringSplit[0]).integerValue;
            self.minutes = NSString(string: stringSplit[1]).integerValue;
            self.seconds = NSString(string: stringSplit[2]).integerValue;
        }
        // If stringSplit has any other amount of items...
        else {
            // Print to the log that this string is invalid
            print("SCSongTime: Invalid date string \"\(string)\"");
        }
        
        // Update the time
        updateTime();
    }
    
    // Init with hours, minutes and seconds
    init(hours : Int, minutes : Int, seconds : Int) {
        self.hours = hours;
        self.minutes = minutes;
        self.seconds = seconds;
        
        updateTime();
    }
}