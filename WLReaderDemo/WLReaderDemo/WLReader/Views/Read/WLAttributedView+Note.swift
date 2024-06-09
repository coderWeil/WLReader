//
//  WLAttributedView+Note.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import DTCoreText

extension WLAttributedView {
    
    // MARK - 添加笔记
    func addNote(note:WLBookNoteModel?) {
        guard let note = note else { return }
        let attr = NSMutableAttributedString(attributedString: self.attributedString)
        attr.addAttribute(.link, value: URL(string: note.note)!, range: note.range)
        self.attributedString = attr
        var rect = self.bounds
        let insets = self.edgeInsets
        rect.origin.x    += insets.left;
        rect.origin.y    += insets.top;
        rect.size.width  -= (insets.left + insets.right);
        rect.size.height -= (insets.top  + insets.bottom);
        let layoutFrame = self.layouter.layoutFrame(with: rect, range: self.contentRange)
        self.layoutFrame = layoutFrame
    }
    
    // MARK - 有多条笔记需要添加
    func addNotes(notes:[WLBookNoteModel]?) {
        guard let notes = notes else { return }
        if notes.isEmpty {
            return
        }
        let attr = NSMutableAttributedString(attributedString: self.attributedString)
        for note in notes {
            attr.addAttribute(.link, value: URL(string: note.note)!, range: note.range)
        }
        self.attributedString = attr
        var rect = self.bounds
        let insets = self.edgeInsets
        rect.origin.x    += insets.left;
        rect.origin.y    += insets.top;
        rect.size.width  -= (insets.left + insets.right);
        rect.size.height -= (insets.top  + insets.bottom);
        let layoutFrame = self.layouter.layoutFrame(with: rect, range: self.contentRange)
        self.layoutFrame = layoutFrame
    }
    
    // MARK - 生成链接视图的代理
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewForLink url: URL!, identifier: String!, frame: CGRect) -> UIView! {
        let btn = DTLinkButton(frame: frame)
        btn.url = url
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(_onTapBtn(btn:)), for: .touchUpInside)
        return btn
    }
    @objc private func _onTapBtn(btn:DTLinkButton) {
        
    }
}
