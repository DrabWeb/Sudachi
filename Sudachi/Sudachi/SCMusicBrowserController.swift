//
//  SCMusicBrowserController.swift
//  Sudachi
//
//  Created by Seth on 2016-04-07.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCMusicBrowserController: NSObject {
    
    /// The main view controller for the main window(The on this is in)
    @IBOutlet weak var mainViewController: ViewController!
    
    /// The array controller for the collection view
    @IBOutlet weak var arrayController : NSArrayController!;
    
    /// The items in arrayController as an NSMutableArray
    var browserItems : NSMutableArray = NSMutableArray();
    
    /// The scroll view for musicBrowserCollectionView
    @IBOutlet weak var musicBrowserCollectionViewScrollView: NSScrollView!
    
    /// The collection view for displaying the music browser visually
    @IBOutlet weak var musicBrowserCollectionView: NSCollectionView!
    
    /// The view for letting users drop files into the music browser and import them
    @IBOutlet weak var musicBrowserDropView: SCMusicBrowserDropView!
    
    /// The SCMusicBrowserItems that are kept in the background and pulled from for displaying
    var musicBrowserItems : [SCMusicBrowserItem] = [];
    
    /// The text field for searching for items in the music browser
    @IBOutlet weak var searchField: SCSearchTextField!
    
    /// When searchField has text entered...
    @IBAction func searchFieldInteracted(sender: AnyObject) {
        // Search for the entered text
        searchFor(searchField.stringValue);
    }
    
    /// Calls the same event as a double click on all the selected items in the music browser
    func openSelectedItems() {
        // Disable updating on the playlist(For speed improvements so it doesnt update on every possible song add)
        mainViewController.playlistController.canUpdate = false;
        
        // For every selected item...
        for(_, currentSelectionIndex) in musicBrowserCollectionView.selectionIndexes.enumerate() {
            /// The collection item at the current selection index
            let currentSelectedItem : SCMusicBrowserCollectionViewItem = musicBrowserCollectionView.itemAtIndex(currentSelectionIndex) as! SCMusicBrowserCollectionViewItem;
            
            // Call the open function for the current item
            currentSelectedItem.open();
        }
        
        // Enable updating on the playlist
        mainViewController.playlistController.canUpdate = true;
        
        // Update the playlist
        mainViewController.playlistController.update();
    }
    
    /// The current path the music browser is at
    var currentFolder : String = "";
    
    /// Called when an item in the Music Browser is opened
    func browserItemOpened(browserItem : SCMusicBrowserItem) {
        // If the item is a folder...
        if(SCFileUtilities().isFolder((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + browserItem.representedObjectPath)) {
            /// Display the items folder contents(First removes the MPD folder path from the represented path)
            displayItemsFromRelativePath(browserItem.representedObjectPath);
        }
        // If the item is a song...
        else {
            // Add the song to the playlist
            /// The temporary song to pass to the SCMPD.addSongToPlaylist
            let itemSong : SCSong = SCSong();
            
            // Set the path
            itemSong.filePath = (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + browserItem.representedObjectPath;
            
            // Add the song to the playlist
            (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.addSongToPlaylist(itemSong, insert: false);
        }
    }
    
    /// Displays the items in the given path(Relative to the MPD folder)
    func displayItemsFromRelativePath(path : String) {
        // Clear the current browser items
        clearGrid(true);
        
        // Set the current folder
        currentFolder = path;
        
        // If the current folder isn't blank...
        if(currentFolder != "") {
            // Add the back item
            /// The item for letting the user go back to the previous folder
            let backBrowserItem : SCMusicBrowserItem = SCMusicBrowserItem();
            
            // Set the path to the folder containing the current folder
            backBrowserItem.representedObjectPath = NSString(string: currentFolder).stringByDeletingLastPathComponent;
            
            // Set the display image to the back icon
            backBrowserItem.displayImage = SCThemingEngine().defaultEngine().folderBackIcon;
            
            // Set the title to "Bacl"
            backBrowserItem.displayTitle = "Back"
            
            // Add the back item to the grid
            addBrowserItem(backBrowserItem);
            
            // Show musicBrowserItems in the grid(I call this here and at the end so this item comes up before the loading is finished, it looks nicer)
            setGridToBrowserItems();
        }
        
        // For every item in the given path...
        for(_, currentItemPath) in (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.runMpcCommand(["ls", path], waitUntilExit: true, log: true).componentsSeparatedByString("\n").enumerate() {
            /// The SCMusicBrowserItem for the current item in the path
            let currentBrowserItem : SCMusicBrowserItem = SCMusicBrowserItem();
            
            // Set the current item's path
            currentBrowserItem.representedObjectPath = currentItemPath;
            
            // Load the item's display image
            currentBrowserItem.grabAndSetDisplayImage();
            
            // If this item isnt a folder...
            if(!currentBrowserItem.isFolder) {
                // Set the display title to the file's name without the extension
                currentBrowserItem.displayTitle = NSString(string: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentBrowserItem.representedObjectPath).lastPathComponent.stringByReplacingOccurrencesOfString("." + NSString(string: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentBrowserItem.representedObjectPath).pathExtension, withString: "");
            }
            // If this item is a folder...
            else {
                // Set the title to the folder's name
                currentBrowserItem.displayTitle = NSString(string: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentBrowserItem.representedObjectPath).lastPathComponent;
            }
            
            // Add the browser item
            addBrowserItem(currentBrowserItem);
        }
        
        // Remove the last item from the grid(Its for some reason a random item called "Music")
        removeBrowserItem(musicBrowserItems.last!, alsoMusicBrowserItems: true);
        
        // Show musicBrowserItems in the grid
        setGridToBrowserItems();
        
        // If we arent in the root directory...
        if(currentFolder != "") {
            // Set the back item's target and action
            /// The SCMusicBrowserCollectionViewItem for the back item
            let backBrowserItemCollectionViewItem : SCMusicBrowserCollectionViewItem = (musicBrowserCollectionView.itemAtIndex(0)) as! SCMusicBrowserCollectionViewItem;
            
            // Set the target and action
            backBrowserItemCollectionViewItem.openTarget = self;
            backBrowserItemCollectionViewItem.openAction = Selector("openParentFolder");
            
            // If the browser items length is greater than 1...
            if(musicBrowserItems.count > 1) {
                // For every SCMusicBrowserCollectionViewItem in the music browser collection view(Except the first one)...
                for currentIndex in 1...(musicBrowserItems.count - 1) {
                    /// The SCMusicBrowserCollectionViewItem for the current index
                    let currentBrowserItemCollectionViewItem : SCMusicBrowserCollectionViewItem = (musicBrowserCollectionView.itemAtIndex(currentIndex)) as! SCMusicBrowserCollectionViewItem;
                    
                    // Set the target and action
                    currentBrowserItemCollectionViewItem.openTarget = self;
                    currentBrowserItemCollectionViewItem.openAction = Selector("browserItemOpened:");
                }
            }
            else {
                // Display the message saying theres an error
                print("SCMusicBrowserController: No items in directory \"\(currentFolder)\", this usually means the server crashed");
            }
        }
        // If we are in the root directory...
        else {
            // For every SCMusicBrowserCollectionViewItem in the music browser collection view...
            for currentIndex in 0...(musicBrowserItems.count - 1) {
                /// The SCMusicBrowserCollectionViewItem for the current index
                let currentBrowserItemCollectionViewItem : SCMusicBrowserCollectionViewItem = (musicBrowserCollectionView.itemAtIndex(currentIndex)) as! SCMusicBrowserCollectionViewItem;
                
                // Set the target and action
                currentBrowserItemCollectionViewItem.openTarget = self;
                currentBrowserItemCollectionViewItem.openAction = Selector("browserItemOpened:");
            }
        }
        
        // Select the first item in the music browser collection view
        musicBrowserCollectionView.selectionIndexes = NSIndexSet(index: 0);
    }
    
    /// Called when the user drops files into the music browser. Moves the dropped files into the current directory, updates the database, and reloads the folder contents
    func filesDroppedIntoMusicBrowser(files : [String]) {
        // For every droppped file...
        for(_, currentFile) in files.enumerate() {
            do {
                // Move the current file to the current folder
                try NSFileManager.defaultManager().moveItemAtPath(currentFile, toPath: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentFolder + "/" + NSString(string: currentFile).lastPathComponent);
            }
            catch let error as NSError {
                // Print the error description
                print("SCMusicBrowserController: Failed to move files to current folder, \(error.description)");
            }
        }
        
        // Update the database
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.updateDatabase();
        
        // Reload the folder contents
        displayItemsFromRelativePath(currentFolder);
    }
    
    /// Adds the current songs in the music browser collection view to the playlist
    func openListedSongs() {
        // Disable updating on the playlist(For speed improvements so it doesnt update on every possible song add)
        mainViewController.playlistController.canUpdate = false;
        
        /// The amount of songs we added to the playlist
        var addedSongCount : Int = 0;
        
        // For every item in the music browser...
        for currentIndex in 0...((arrayController.arrangedObjects as! [AnyObject]).count - 1) {
            /// The collection item at the current index
            let currentItem : SCMusicBrowserCollectionViewItem = musicBrowserCollectionView.itemAtIndex(currentIndex) as! SCMusicBrowserCollectionViewItem;
            
            // If the current item is not a folder...
            if(!(currentItem.representedObject as! SCMusicBrowserItem).isFolder) {
                // Call the open function for the current item
                currentItem.open();
                
                // Add one to the added song count
                addedSongCount++;
            }
        }
        
        // Enable updating on the playlist
        mainViewController.playlistController.canUpdate = true;
        
        // If we added any songs...
        if(addedSongCount > 0) {
            // Update the playlist
            mainViewController.playlistController.update();
        }
    }
    
    /// Updates the music database and once finished reloads the current directory and shows a notification saying the update is done
    func updateDatabse() {
        // Update the database
        (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.updateDatabase();
        
        /// The notification to say the database update finished
        let finishedNotification : NSUserNotification = NSUserNotification();
        
        // Set the informative text
        finishedNotification.informativeText = "Database update finished";
        
        // Deliver the notification
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(finishedNotification);
        
        // Reload the current directory
        displayItemsFromRelativePath(currentFolder);
    }
    
    /// The last entered search
    var lastSearch : String = "";
    
    /// All the items from the search results
    var searchResultItems : [SCMusicBrowserItem] = [];
    
    /// Searches for the given string and displays the results
    func searchFor(var searchString : String) {
        // Print to the log what we are searching for
        print("Searching for \"\(searchString)\" in music browser");
        
        // Set last search
        lastSearch = searchString;
        
        // Clear the results
        searchResultItems.removeAll();
        
        // If the search string is blank...
        if(searchString == "") {
            // Go back to the directory the user was in
            displayItemsFromRelativePath(currentFolder);
            
            // Select the first item in the music browser collection view
            musicBrowserCollectionView.selectionIndexes = NSIndexSet(index: 0);
        }
        // If the search string has content...
        else {
            /// The type that we will search by (any|Artist|Album|AlbumArtist|Title|Track|Name|Genre|Date|Composer|Performer|Comment|Disc)
            var searchType : String = "any";
            
            // If there was a ":" in the search string...
            if(searchString.rangeOfString(":") != nil) {
                // Set the search type to the string before the ":"
                searchType = searchString.substringToIndex(searchString.rangeOfString(":")!.startIndex);
                
                // Remove anything before and including the ":" from searchString
                searchString = searchString.substringFromIndex(searchString.rangeOfString(":")!.startIndex.successor());
                
                // If searchString isnt blank...
                if(searchString != "") {
                    // If the first character in searchString is a " "...
                    if(searchString.substringToIndex(searchString.startIndex.successor()) == " ") {
                        // Remove the first character
                        searchString = searchString.substringFromIndex(searchString.startIndex.successor());
                    }
                }
            }
            
            // For every search result...
            for(_, currentSearchResult) in (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.runMpcCommand(["search", searchType, searchString], waitUntilExit: true, log: true).componentsSeparatedByString("\n").enumerate() {
                // If the search result isnt blank(For some reason it puts an extra blank one on the end)...
                if(currentSearchResult != "") {
                    // Clear the display grid
                    clearGrid(false);
                    
                    // Add the current item to the grid
                    /// The SCMusicBrowserItem for the current search result
                    let currentResultBrowserItem : SCMusicBrowserItem = SCMusicBrowserItem();
                    
                    // Set the current item's path
                    currentResultBrowserItem.representedObjectPath = currentSearchResult;
                    
                    // Load the item's display image
                    currentResultBrowserItem.grabAndSetDisplayImage();
                    
                    // Set the display title to the file's name without the extension
                    currentResultBrowserItem.displayTitle = NSString(string: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentResultBrowserItem.representedObjectPath).lastPathComponent.stringByReplacingOccurrencesOfString("." + NSString(string: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + currentResultBrowserItem.representedObjectPath).pathExtension, withString: "");
                    
                    // Add the browser item to the results
                    searchResultItems.append(currentResultBrowserItem);
                }
            }
            
            // Show the items
            setGridToBrowserItems(searchResultItems);
            
            // Set the open actions
            // If there is at least one search result...
            if(((arrayController.arrangedObjects as! [AnyObject]).count > 0)) {
                // For every SCMusicBrowserCollectionViewItem in the music browser collection view...
                for currentIndex in 0...((arrayController.arrangedObjects as! [AnyObject]).count - 1) {
                    /// The SCMusicBrowserCollectionViewItem for the current index
                    let currentBrowserItemCollectionViewItem : SCMusicBrowserCollectionViewItem = (musicBrowserCollectionView.itemAtIndex(currentIndex)) as! SCMusicBrowserCollectionViewItem;
                    
                    // Set the target and action
                    currentBrowserItemCollectionViewItem.openTarget = self;
                    currentBrowserItemCollectionViewItem.openAction = Selector("browserItemOpened:");
                }
            }
        }
    }
    
    /// Removes the item at the given index from the grid, and also musicBrowserItems if alsoMusicBrowserItems is true
    func removeBrowserItemAtIndex(index : Int, alsoMusicBrowserItems : Bool) {
        // Remove the item from the arrayController
        arrayController.removeObject(musicBrowserItems[index]);
        
        // If we said to also remove it from musicBrowserItems...
        if(alsoMusicBrowserItems) {
            // Remove the object from musicBrowserItems
            musicBrowserItems.removeAtIndex(index);
        }
    }
    
    /// Removes the given item from the grid, and also musicBrowserItems if alsoMusicBrowserItems is true
    func removeBrowserItem(item : SCMusicBrowserItem, alsoMusicBrowserItems : Bool) {
        // Remove the given item from the array controller
        arrayController.removeObject(item);
        
        // If we said to also remove it from musicBrowserItems...
        if(alsoMusicBrowserItems) {
            // Cast musicBrowserItems into an NSMutableArray, remove the object, and turn it back into an [SCMusicBrowserItem] and store it back in musicBrowserItems
            let musicBrowserItemsMutable : NSMutableArray = NSMutableArray(array: musicBrowserItems);
            musicBrowserItemsMutable.removeObject(item);
            musicBrowserItems = (Array(musicBrowserItemsMutable) as! [SCMusicBrowserItem]);
        }
    }
    
    /// Adds the given SCMusicBrowserItem to musicBrowserItems
    func addBrowserItem(item : SCMusicBrowserItem) {
        // Add the item to musicBrowserItems
        musicBrowserItems.append(item);
    }
    
    /// Adds the given SCMusicBrowserItem to the grid
    func addBrowserItemToGrid(item : SCMusicBrowserItem) {
        // Add the item to arrayController
        arrayController.addObject(item);
    }
    
    /// Sets the grid to the given array of SCMusicBrowserItems
    func setGridToBrowserItems(browserItems : [SCMusicBrowserItem]) {
        // Clear the current items
        clearGrid(false);
        
        // Add all the objects in browserItems to arrayController
        arrayController.addObjects(browserItems);
        
        // TODO: Fix this so it also works on the first load(Currently on the first load the layer is nil, and setting it hides the image)
        // If we said to hide shadows on music browser items...
        if(!SCThemingEngine().defaultEngine().musicBrowserItemShadowEnabled) {
            // For every grid item...
            for currentIndex in 0...((arrayController.arrangedObjects as! [AnyObject]).count - 1) {
                // Remove the current grid item's layer
                musicBrowserCollectionView.itemAtIndex(currentIndex)!.imageView!.layer?.shadowOpacity = 0;
            }
        }
    }
    
    /// Sets the grid to match musicBrowserItems
    func setGridToBrowserItems() {
        // Add all the items in musicBrowserItems to the grid
        setGridToBrowserItems(musicBrowserItems);
    }
    
    /// Clears arrayController, also clears musicBrowserItems if you set alsoMusicBrowserItems to true
    func clearGrid(alsoMusicBrowserItems : Bool) {
        // Remove all the objects from the grid array controller
        arrayController.removeObjects(arrayController.arrangedObjects as! [AnyObject]);
        
        // if we also want to clear musicBrowserItems...
        if(alsoMusicBrowserItems) {
            // Clear musicBrowserItems
            musicBrowserItems.removeAll();
        }
    }
    
    /// Opens the parent folder of the current folder(Does nothing if we are in the root of the music directory)
    func openParentFolder() {
        // If currentFolder isnt blank...
        if(currentFolder != "") {
            // Open the enclosing folder
            displayItemsFromRelativePath(NSString(string: currentFolder).stringByDeletingLastPathComponent);
        }
    }
    
    /// Makes searchField the first responder
    func selectSearchField() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).mainWindow?.makeFirstResponder(searchField);
    }
    
    /// Makes musicBrowserCollectionView the first responder
    func selectMusicBrowser() {
        (NSApplication.sharedApplication().delegate as! AppDelegate).mainWindow?.makeFirstResponder(musicBrowserCollectionView);
    }
    
    /// Sets up the menu items for this controller
    func setupMenuItems() {
        // Setup the menu items
        // Set the targets
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemOpenSelectedItem.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectSearchField.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectMusicBrowser.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemEnclosingFolder.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemUpdateMpdDatabase.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemAddListedSongs.target = self;
        
        // Set the actions
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemOpenSelectedItem.action = Selector("openSelectedItems");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectSearchField.action = Selector("selectSearchField");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectMusicBrowser.action = Selector("selectMusicBrowser");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemEnclosingFolder.action = Selector("openParentFolder");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemUpdateMpdDatabase.action = Selector("updateDatabse");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemAddListedSongs.action = Selector("openListedSongs");
    }
    
    /// Loads in the theme variables from SCThemingEngine
    func loadTheme() {
        // Set the minimum and maximum item sizes
        musicBrowserCollectionView.minItemSize = SCThemingEngine().defaultEngine().musicBrowserMinimumItemSize;
        musicBrowserCollectionView.maxItemSize = SCThemingEngine().defaultEngine().musicBrowserMaximumItemSize;
    }
    
    func initialize() {
        // Load the theme
        loadTheme();
        
        // Setup the menu items
        setupMenuItems();
        
        // Set the collection view's prototype item
        musicBrowserCollectionView.itemPrototype = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("musicBrowserCollectionViewItem") as! SCMusicBrowserCollectionViewItem;
        
        // Set the drop view's target and action
        musicBrowserDropView.dropTarget = self;
        musicBrowserDropView.dropAction = Selector("filesDroppedIntoMusicBrowser:");
        
        // Display the root of the music folder
        displayItemsFromRelativePath("");
    }
}

class SCMusicBrowserItem: NSObject {
    /// The image to show for the item
    var displayImage : NSImage = NSImage();
    
    /// The title to show for the item
    var displayTitle : String = "Error: Failed to load title";
    
    /// The path of the file/folder this item represents
    var representedObjectPath : String = "";
    
    /// Is this item a folder?
    var isFolder : Bool {
        // Return if the item at representedObjectPath is a folder
        return SCFileUtilities().isFolder((NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + representedObjectPath);
    }
    
    /// Sets the display image to the proper image
    func grabAndSetDisplayImage() {
        // If the represented path is set...
        if(representedObjectPath != "") {
            // If this item is a folder...
            if(isFolder) {
                /// The NSURL of representedObjectPath
                let folderUrl : NSURL = NSURL(fileURLWithPath: (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + representedObjectPath);
                
                // For every item in this folders contents...
                for(_, currentFile) in NSFileManager.defaultManager().enumeratorAtURL(folderUrl, includingPropertiesForKeys: nil, options: [NSDirectoryEnumerationOptions.SkipsHiddenFiles, NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants], errorHandler: nil)!.enumerate() {
                    /// The path of the current file
                    let currentFilePath : String = currentFile.absoluteString.stringByReplacingOccurrencesOfString("file://", withString: "").stringByRemovingPercentEncoding!;
                    
                    // If the current file is an image...
                    if(SCConstants().realisticImageFileTypes.contains(NSString(string: currentFilePath).pathExtension)) {
                        // Set the display image to this image
                        displayImage = NSImage(contentsOfFile: currentFilePath)!;
                        
                        // Mask the display image to the folder icon
                        displayImage = displayImage.maskWith(SCThemingEngine().defaultEngine().folderIcon);
                    }
                }
                
                // If the display image wasnt set...
                if(displayImage.size == NSSize.zero) {
                    // Set the display image to the folder icon
                    displayImage = SCThemingEngine().defaultEngine().folderIcon;
                }
            }
            // If this item is a file...
            else {
                // Set the display image to the cover of this file
                /// The temporary song to grab the cover image of this item
                let song : SCSong = SCSong();
                
                // Set the song's path
                song.filePath = (NSApplication.sharedApplication().delegate as! AppDelegate).SudachiMPD.mpdFolderPath + representedObjectPath;
                
                // Set the display image to the song's cover image
                displayImage = song.getCoverImage();
                
                // Mask the art
                displayImage = displayImage.maskWith(SCThemingEngine().defaultEngine().musicBrowserArtMask);
            }
        }
    }
    
    // Init with a title and image
    init(displayImage : NSImage, displayTitle : String) {
        self.displayImage = displayImage;
        self.displayTitle = displayTitle;
    }
    
    // Blank init
    override init() {
        super.init();
        
        self.displayImage = NSImage();
        self.displayTitle = "Error: Failed to load title";
        self.representedObjectPath = "";
    }
}
