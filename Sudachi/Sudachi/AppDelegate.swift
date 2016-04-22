//
//  AppDelegate.swift
//  Sudachi
//
//  Created by Seth on 2016-04-01.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// The global SCMPD manager to use
    let SudachiMPD : SCMPD = SCMPD();
    
    /// The main window of the application
    var mainWindow : NSWindow? = nil;
    
    /// The preferences object for the application
    var preferences : SCPreferencesObject = SCPreferencesObject();
    
    /// Sudachi/Menubar Mode
    @IBOutlet weak var menuItemMenubarMode: NSMenuItem!
    
    /// Sudachi/Update MPD Database (⌘⇧U)
    @IBOutlet weak var menuItemUpdateMpdDatabase: NSMenuItem!
    
    /// Browser/Open Selected Item(s) (⌘O)
    @IBOutlet weak var menuItemOpenSelectedItem: NSMenuItem!
    
    /// Browser/Open Selected Item(s) (↩︎)
    @IBOutlet weak var menuItemOpenSelectedItemsEnter: NSMenuItem!
    
    /// Browser/Go/Enclosing Folder (⌘↑)
    @IBOutlet weak var menuItemEnclosingFolder: NSMenuItem!
    
    /// Browser/Go/Home (⌘⇧H)
    @IBOutlet weak var menuItemHome: NSMenuItem!
    
    /// Browser/Add Listed Songs (⌘⇧O)
    @IBOutlet weak var menuItemAddListedSongs: NSMenuItem!
    
    /// Browser/Select Search Field (⌘F)
    @IBOutlet weak var menuItemSelectSearchField: NSMenuItem!
    
    /// Browser/Select Music Browser (⌘⇧B)
    @IBOutlet weak var menuItemSelectMusicBrowser: NSMenuItem!
    
    /// Playlist/Clear Playlist (⌘⇧C)
    @IBOutlet weak var menuItemClearPlaylist: NSMenuItem!
    
    /// Playlist/Remove Selected Item (⌘⌫)
    @IBOutlet weak var menuItemRemoveSelectedPlaylistItem: NSMenuItem!
    
    /// Playlist/Play Selected Item (⌘↩︎)
    @IBOutlet weak var menuItemPlaySelectedPlaylistItem: NSMenuItem!
    
    /// Playlist/Play First Song (⌘⇧1)
    @IBOutlet weak var menuItemPlayFirstSong: NSMenuItem!
    
    /// Playlist/Switch Repeat Mode (⌘⇧R)
    @IBOutlet weak var menuItemSwitchRepeatMode: NSMenuItem!
    
    /// Playlist/Shuffle Playlist (⌘⇧S)
    @IBOutlet weak var menuItemShufflePlaylist: NSMenuItem!
    
    /// Playlist/Toggle Random Mode (⌘⌃⇧R)
    @IBOutlet weak var menuItemToggleRandomMode: NSMenuItem!
    
    /// Playlist/Select Playlist (⌘⇧P)
    @IBOutlet weak var menuItemSelectPlayList: NSMenuItem!
    
    /// View/Toggle Music Browser (⌘B)
    @IBOutlet weak var menuItemToggleMusicBrowser: NSMenuItem!
    
    /// View/Toggle Playlist Actions (⌘⌥G)
    @IBOutlet weak var menuItemTogglePlaylistActions: NSMenuItem!
    
    /// View/Toggle Cover Overlay (⌘R)
    @IBOutlet weak var menuItemToggleCoverOverlay: NSMenuItem!
    
    /// View/Toggle Playlist (⌘G)
    @IBOutlet weak var menuItemTogglePlaylist: NSMenuItem!
    
    /// View/Toggle Player (⌘⌃P)
    @IBOutlet weak var menuItemTogglePlayer: NSMenuItem!
    
    /// Window/Size Window To Cover (⌘1)
    @IBOutlet weak var menuItemSizeWindowToCover: NSMenuItem!
    
    func initialize() {
        // Load the preferences
        loadPreferences();
        
        // Create the application support folder
        createApplicationSupportFolder();
        
        // Launch the MPD server
        launchMpdServer();
        
        // Set the MPD folder
        SudachiMPD.mpdFolderPath = getMPDFolder();
    }
    
    func menubarItemPressed() {
        print("Press");
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }
    
    /// Starts the MPD server if it is not already running
    func launchMpdServer() {
        /// TODO: Find out why the server crashes sometimes(Could just be my machine)
        // If the MPD server crashed...
        if(SudachiMPD.runMpcCommand(["status"], waitUntilExit: true, log: false) == "mpd error: Connection closed by the server") {
            // Kill the server
            SCCommandUtilities().runCommand("/usr/local/bin/mpd", arguments: ["--kill"], waitUntilExit: true, log: true);
        }
        
        // Run MPD(This assumes you installed it with Homebrew)
        SCCommandUtilities().runCommand("/usr/local/bin/mpd", arguments: [], waitUntilExit: true, log: true);
    }
    
    /// Creates the application support folder for Sudachi if it doesnt already exist(And the other folders sudachi need inside of it)
    func createApplicationSupportFolder() {
        // If the application support folder doesnt exist...
        if(!NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/")) {
            do {
                // Create the application support folder
                try NSFileManager.defaultManager().createDirectoryAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/", withIntermediateDirectories: false, attributes: nil);
            }
            catch _ as NSError {
                // Do nothing
            }
        }
        
        // If the themes folder doesnt exist...
        if(!NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes")) {
            do {
                // Create the themes folder
                try NSFileManager.defaultManager().createDirectoryAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/themes", withIntermediateDirectories: false, attributes: nil);
            }
            catch _ as NSError {
                // Do nothing
            }
        }
    }
    
    /// Attempts to get the user's MPD folder, and if it fails it prompts for it. Returns the path to the MPD folder
    func getMPDFolder() -> String {
        /// The path to the MPD folder
        var mpdFolderPath : String = "";
        
        // If the user's MPD folder hasnt already been stored in Application Support...
        if(!NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/mpdfolder")) {
            // If the ~/.mpdconf file exists...
            if(NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/.mpdconf")) {
                /// The contents of ~/.mpdconf
                let mpdConfContents : String = String(data: NSData(contentsOfFile: NSHomeDirectory() + "/.mpdconf")!, encoding: NSUTF8StringEncoding)!;
                
                // For every line in mpdConfContents...
                for(_, currentLine) in mpdConfContents.componentsSeparatedByString("\n").enumerate() {
                    // If the current line contains music_directory(Meaning its the MPD folder)...
                    if(currentLine.containsString("music_directory")) {
                        // If the first character in the line isnt a #(Having one would mean its a comment)...
                        if(currentLine.substringToIndex(currentLine.startIndex.successor()) != "#") {
                            // Set mpdFolderPath to the value in between the quotes of the line
                            mpdFolderPath = currentLine.componentsSeparatedByString("\"")[1];
                            
                            // Break the loop
                            break;
                        }
                    }
                }
            }
            
            // If the folder path is still empty...
            if(mpdFolderPath == "") {
                /// The open panel to prompt for the MPD folder
                let mpdFolderOpenPanel : NSOpenPanel = NSOpenPanel();
                
                // Only allow folders
                mpdFolderOpenPanel.canChooseFiles = false;
                mpdFolderOpenPanel.canChooseDirectories = true;
                
                // Set the prompt
                mpdFolderOpenPanel.prompt = "Choose MPD Folder";
                
                // Run the panel, and if we hit choose...
                if(Bool(mpdFolderOpenPanel.runModal())) {
                    // Set mpdFolderPath to the selected folder's directory
                    mpdFolderPath = mpdFolderOpenPanel.URL!.absoluteString.stringByReplacingOccurrencesOfString("file://", withString: "").stringByRemovingPercentEncoding!;
                }
            }
        }
        // If it already has been stored...
        else {
            // Set mpdFolderPath to the contents of ~/Library/Application Support/Sudachi/mpdfolder
            mpdFolderPath = String(data: NSData(contentsOfFile: NSHomeDirectory() + "/Library/Application Support/Sudachi/mpdfolder")!, encoding: NSUTF8StringEncoding)!;
        }
        
        // If mpdFolderPath isnt blank...
        if(mpdFolderPath != "") {
            // If the last character in mpdFolderPath isnt a "/"...
            if(mpdFolderPath.substringFromIndex(mpdFolderPath.endIndex.predecessor()) != "/") {
                // Add a "/" to the end of mpdFolderPath
                mpdFolderPath = mpdFolderPath + "/";
            }
        }
        
        // Return the MPD folder path
        return mpdFolderPath;
    }
    
    // Saves the preferences to user defaults
    func savePreferences() {
        // The data for the preferences object
        let data = NSKeyedArchiver.archivedDataWithRootObject(preferences);
        
        // Set the standard user defaults preferences key to that data
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "preferences");
        
        // Synchronize the data
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    // Load the preferences from user defaults
    func loadPreferences() {
        // If we have any data to load...
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("preferences") as? NSData {
            // Set the preferences object to the loaded object
            preferences = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SCPreferencesObject);
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        // If the user's MPD folder hasnt already been stored in Application Support...
        if(!NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Sudachi/mpdfolder")) {
            do {
                // Store the MPD folder path in ~/Library/Application Support/Sudachi/mpdfolder
                try SudachiMPD.mpdFolderPath.writeToFile(NSHomeDirectory() + "/Library/Application Support/Sudachi/mpdfolder", atomically: true, encoding: NSUTF8StringEncoding);
            }
            catch _ as NSError {
                // Do nothing
            }
        }
        
        // Save the preferences
        savePreferences();
    }
}

