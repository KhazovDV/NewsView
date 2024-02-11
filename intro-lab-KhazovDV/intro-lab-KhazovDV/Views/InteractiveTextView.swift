//
//  InteractiveTextView.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class InteractiveTextView: UITextView, UITextViewDelegate {
    var onTap: ((URL) -> Void)?

    func setLink(url: String, onTap: ((URL) -> Void)? = nil) {
        self.onTap = onTap
        let mutableAttrText = NSMutableAttributedString(attributedString: attributedText)
        let foundRange = mutableAttrText.mutableString.range(of: url)
        if foundRange.location != NSNotFound {
            mutableAttrText.addAttribute(.link, value: url, range: foundRange)
        }
        attributedText = mutableAttrText
        delegate = self
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        onTap?(URL)
        return false
    }
}
