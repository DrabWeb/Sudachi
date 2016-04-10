//
//  SCPlaylistTableViewData.swift
//  Sudachi
//
//  Created by Seth on 2016-04-03.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCPlaylistTableViewData {
    /// The song this playlist item represents
    var song : SCSong = SCSong();
    
    /// Is this song the current playing song?
    var current : Bool = false;
    
    // Blank init
    init() {
        self.song = SCSong();
    }
    
    // Init with a song
    init(song : SCSong) {
        self.song = song;
    }
}
