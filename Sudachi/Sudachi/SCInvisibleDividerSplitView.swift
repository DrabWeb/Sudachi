//
//  SCInvisibleDividerSplitView.swift
//  Sudachi
//
//  Created by Seth on 2016-04-02.
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
