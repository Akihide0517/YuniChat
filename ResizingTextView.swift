//
//  ResizingTextView.swift
//  newChat
//
//  Created by 吉田成秀 on 2023/05/01.
//

import Foundation
import UIKit

class ResizingTextView: UITextView {

    var maxHeight: CGFloat = .infinity

    override var contentSize: CGSize {
        didSet {
            var newHeight = contentSize.height
            if newHeight > maxHeight {
                newHeight = maxHeight
                isScrollEnabled = true
            } else {
                isScrollEnabled = false
            }
            if newHeight != bounds.size.height {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height > maxHeight {
            size.height = maxHeight
        }
        return size
    }

}
