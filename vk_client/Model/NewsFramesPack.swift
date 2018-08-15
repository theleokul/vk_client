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
    
    var nameFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var iconFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var articleOrContentImageFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0),
                                                    size: CGSize(width: 0, height: 0))
    var likesFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var commentsFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var repostsFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var viewsFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    var rowHeight: CGFloat {
        get {
            return (
                4 * NewsFramesPack.insets +
                NewsFramesPack.iconSide +
                articleOrContentImageFrame.height +
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
    
    init() {}
    
}
