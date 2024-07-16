//
//  WLAttributedView+Note.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import DTCoreText

extension WLAttributedView {
    
    // MARK - 设置笔记对应的link
    func addLinkToAttributeContent(with notes:[WLBookNoteModel]?) {
        guard let notes = notes else { return }
        let attr = NSMutableAttributedString(attributedString: self.attributedString)
        // 先清除所有的划线
        attr.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedString.length)) { value, range, _ in
            if value != nil {
                attr.removeAttribute(.link, range: range)
            }
        }
        // 再清除所有的下划线
        attr.enumerateAttribute(.underlineStyle, in: NSRange(location: 0, length: attributedString.length)) { value, range, _ in
            if value != nil {
                attr.removeAttribute(.underlineStyle, range: range)
            }
        }
        attr.enumerateAttribute(.underlineColor, in: NSRange(location: 0, length: attributedString.length)) { value, range, _ in
            if value != nil {
                attr.removeAttribute(.underlineColor, range: range)
            }
        }
        for note in notes {
            // 只有划线和笔记需要添加事件
            if note.noteType == .line || note.noteType == .note {
                if let sourceContent = note.sourceContent, sourceContent.type == 0 {
                    // 根据文本计算相对位置
                    let range = (self.attributedString.string as NSString).range(of: sourceContent.text!)
                    attr.addAttribute(.link, value: URL(string: note.noteIdStr!)!, range: range)
                    attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue | NSUnderlineStyle.patternDot.rawValue, range: range)
                }
                // 如果当前是滚动模式
//                if WLBookConfig.shared.effetType == .scroll {
//                    
//                }else {
//                    attr.addAttribute(.link, value: URL(string: note.noteIdStr!)!, range: NSMakeRange(note.startLocation!, note.endLocation! - note.startLocation!))
//                    attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue | NSUnderlineStyle.patternDot.rawValue, range: NSMakeRange(note.startLocation!, note.endLocation! - note.startLocation!))
//                }
            }
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
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGes(gesture:)))
        self.addGestureRecognizer(tapGes)
        
        self.becomeFirstResponder()
        currentNoteId = btn.url.absoluteString
        let menuController = UIMenuController.shared
        let detailItem = UIMenuItem.init(title: "查看", action: #selector(toNoteDetail))
        let deleteItem = UIMenuItem(title: "删除", action: #selector(deleteNote))
        menuController.menuItems = [detailItem, deleteItem]
        menuController.showMenu(from: self, rect: btn.frame)
    }
    
    @objc private func toNoteDetail() {
        // 根据noteId找出来noteModel
        let notes = WLNoteConfig.shared.readChapterNotes()
        guard let notes = notes else { return }
        var currentNote:WLBookNoteModel?
        for note in notes {
            if note.noteIdStr == currentNoteId {
                currentNote = note
                break
            }
        }
        let noteDetail = WLNoteDetailController()
        noteDetail.noteModel = currentNote
        wl_topController()?.navigationController?.pushViewController(noteDetail, animated: true)
    }
    @objc private func deleteNote() {
        WLNoteConfig.shared.removeNote(noteId: currentNoteId)
    }
    public func hideNoteMenu() {
        let menuController = UIMenuController.shared
        menuController.hideMenu(from: self)
        self.resignFirstResponder()
        currentNoteId = nil
    }
}
