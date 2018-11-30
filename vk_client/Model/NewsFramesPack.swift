//
//  NewsFramesPack.swift
//  vk_client
//
//  Created by Leonid Kulikov on 14/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

struct NewsFramesPack {
    
    static let insets: CGFloat = 20.0
    static let iconSide: CGFloat = 60.0
    static let socialMediaActivityHeight: CGFloat = 24.0
    
    var nameFrame: CGRect
    var iconFrame: CGRect
    var articleOrContentImageFrame: CGRect
    var likesFrame: CGRect
    var commentsFrame: CGRect
    var repostsFrame: CGRect
    var viewsFrame: CGRect
    var rowHeight: CGFloat {
        get {
            return (
                4 * NewsFramesPack.insets +
                NewsFramesPack.iconSide +
                articleOrContentImageFrame.size.height +
                NewsFramesPack.socialMediaActivityHeight
            )
        }
    }
    
    init(nameFrame: CGRect,
         iconFrame: CGRect,
         articleOrContentImageFrame: CGRect,
         likesFrame: CGRect,
         commentsFrame: CGRect,
         repostsFrame: CGRect,
         viewsFrame: CGRect) {
        
        self.nameFrame = nameFrame
        self.iconFrame = iconFrame
        self.articleOrContentImageFrame = articleOrContentImageFrame
        self.likesFrame = likesFrame
        self.commentsFrame = commentsFrame
        self.repostsFrame = repostsFrame
        self.viewsFrame = viewsFrame
    }
    
    init() {
        self.nameFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.iconFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.articleOrContentImageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.likesFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.commentsFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.repostsFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        self.viewsFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    }
    
}
