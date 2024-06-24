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
        var params:[String:Any] = [String:Any]()
        params["bookId"] = WLBookConfig.shared.bookModel.bookId
        params["chapterNumber"] = WLBookConfig.shared.bookModel.chapterIndex
        params["startLocation"] = note.range.location
        params["endLocation"] = note.range.location + note.range.length
        params["noteContent"] = [
            "text": note.content,
            "imageUrl": note.content
        ]
        let attr = NSMutableAttributedString(attributedString: self.attributedString)
        noteViewModel.addNote(params: params) { [weak self] in
            guard let self = self else {return}
            WLNoteConfig.shared.addNotes(notes: [note])
            attr.addAttribute(.link, value: URL(string: "\(note.range.location),\(note.range.length)")!, range: note.range)
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
    }
    
    // MARK - 删除笔记
    func deleteNote(note:WLBookNoteModel!) {
        let attr = NSMutableAttributedString(attributedString: self.attributedString)
        noteViewModel.deleteNote(noteId: note.noteId) { [weak self] in
            guard let self = self else {return}
            attr.removeAttribute(.link, range: note.range)
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
        let range = NSRange(btn.url.absoluteString)!
        print("当前章节选中了\(self.attributedString.attributedSubstring(from: range).string)")
    }
}
