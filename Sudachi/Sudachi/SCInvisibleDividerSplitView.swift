//
//  SCInvisibleDividerSplitView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class SCInvisibleDividerSplitView: NSSplitView, NSSplitViewDelegate {

    override var dividerThickness : CGFloat {
        return 0;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        self.delegate = self;
    }
}
