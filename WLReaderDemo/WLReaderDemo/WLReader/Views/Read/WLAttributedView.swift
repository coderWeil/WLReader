//
//  WLAttributedView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/27.
//

import UIKit
import DTCoreText

class WLAttributedView: DTAttributedLabel, UIGestureRecognizerDelegate, DTAttributedTextContentViewDelegate {

    var longPressGes: UILongPressGestureRecognizer
    var panGes: UIPanGestureRecognizer
    var tapGes: UITapGestureRecognizer
    var selectedLineArray: [CGRect] = []
    var hitRange: NSRange
    var touchLeft: Bool = false
    var leftCursor = CGRect()
    var rightCursor = CGRect()
    var touchIsValide = false
    var magnifierView: WLManifierView?
    // 笔记列表的range
    var noteArr:[CGRect] = []
    var contentRange:NSRange!
    // 当前章节
    var chapterIndex:Int!
    var animatedTransition:WLReaderPhotoInteractive?
    // 笔记的vm
    lazy var noteViewModel:WLNoteViewModel! = WLNoteViewModel()
    
    override init(frame: CGRect) {
        // 属性赋值
        self.longPressGes = UILongPressGestureRecognizer()
        self.panGes = UIPanGestureRecognizer()
        self.tapGes = UITapGestureRecognizer()
        self.hitRange = NSRange()
        
        // 父类初始化
        super.init(frame: frame)
        
        self.longPressGes = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPressGesture(gesture:)))

        self.addGestureRecognizer(self.longPressGes)
        
        self.panGes = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:)))
        self.addGestureRecognizer(self.panGes)
        
        self.panGes.delegate = self
        self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    MARK: gesture handler
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) -> Void {
        let hitPoint = gesture.location(in: gesture.view)
        
        if gesture.state == .began {
            let hitIndex = self.closestCursorIndex(to: hitPoint)
            hitRange = self.locateParaRangeBy(index: hitIndex)
            let mutableAttr = self.attributedString.mutableCopy() as! NSMutableAttributedString
            mutableAttr.enumerateAttribute(.attachment, in: hitRange) { value, range, _ in
                if let _ = value as? DTTextAttachment {
                    if range.location == self.hitRange.location { // 如果长按的是图片，则进行修正
                        self.hitRange = range
                    }
                }
            }
            selectedLineArray = self.lineArrayFrom(range: hitRange)
            self.setNeedsDisplay(bounds)
            showMagnifierView(point: hitPoint)
        }
        if gesture.state == .ended {
            tapGes = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGes(gesture:)))
            self.addGestureRecognizer(tapGes)
            hideMagnifierView()
            showMenuItemView()
        }
        magnifierView?.locatePoint = hitPoint
        
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) -> Void {
        let hitPoint = gesture.location(in: gesture.view)
        
        if gesture.state == .began {
            let leftRect = CGRect(x: leftCursor.minX - 20, y: leftCursor.minY - 20, width: leftCursor.width + 40, height: leftCursor.height + 40)
            let rightRect = CGRect(x: rightCursor.minX - 20, y: rightCursor.minY - 20, width: rightCursor.width + 40, height: rightCursor.height + 40)
            if leftRect.contains(hitPoint) {
                touchIsValide = true
                touchLeft = true
            }
            else if rightRect.contains(hitPoint) {
                touchIsValide = true
                touchLeft = false
            }else {
                handleTapGes(gesture: nil)
            }
        }
        else if gesture.state == .changed {
            if touchIsValide {
                hideMenuItemView()
                showMagnifierView(point: hitPoint)
                self.magnifierView?.locatePoint = hitPoint
                self.updateHitRangeWith(point: hitPoint, touchIsLeft: touchLeft)
                selectedLineArray = self.lineArrayFrom(range: hitRange)
                self.setNeedsDisplay(self.bounds)
            }
            if hitPoint.y < 0 {
                showMenuItemView(toPreviousPage: true)
            }else if hitPoint.y > bounds.height {
                showMenuItemView(toNextPage: true)
            }
        }
        else {
            if touchIsValide {
                hideMagnifierView()
                showMenuItemView()
                touchIsValide = false
            }
        }
        
    }
    
    @objc func handleTapGes(gesture: UITapGestureRecognizer?) -> Void {
        selectedLineArray.removeAll()
        self.setNeedsDisplay(bounds)
        self.removeGestureRecognizer(tapGes)
        hideMenuItemView()
    }
    
    func configNotesArr() {
        guard let selectedRanges = WLNoteConfig.shared.readSelectedRanges() else { return }
        noteArr.removeAll()
        for range in selectedRanges {
            let rects = lineArrayFrom(range: range)
            noteArr.append(contentsOf: rects)
        }
        
    }
    
    //    MARK: utils
    func locateParaRangeBy(index: Int) -> NSRange {
        var targetRange = NSRange()
        // 整行选中
        for line in layoutFrame.lines {
            let _line = line as! DTCoreTextLayoutLine
            let lineRange = _line.stringRange()
            if index >=  lineRange.location && index <= lineRange.location + lineRange.length {
                targetRange = lineRange
                break
            }
        }
        // 整段选中
//        for item in layoutFrame.paragraphRanges {
//            let paraRange: NSRange = item as! NSRange
//            if index >= paraRange.location && index < paraRange.location + paraRange.length {
//                //                找到hit段落
//                targetRange = paraRange
//                break
//            }
//        }
        return targetRange
    }
    
    func lineArrayFrom(range: NSRange) -> [CGRect] {
        var lineArray: [CGRect] = []
        var line = layoutFrame.lineContaining(UInt(range.location))
        let selectedMaxIndex = range.location + range.length
        var startIndex = range.location
        
        while line != nil, line!.stringRange().location < selectedMaxIndex {
            let lineMaxIndex = line!.stringRange().location + line!.stringRange().length
            let startX = line!.frame.origin.x + line!.offset(forStringIndex: startIndex)
            let lineEndOffset = lineMaxIndex <= selectedMaxIndex ? line?.offset(forStringIndex: lineMaxIndex) : line?.offset(forStringIndex: selectedMaxIndex)
            let endX = line!.frame.origin.x + lineEndOffset!
            let rect = CGRect(x: startX, y: line!.frame.origin.y, width: endX - startX, height: line!.frame.size.height)
            lineArray.append(rect)
            startIndex = lineMaxIndex
            line = layoutFrame.lineContaining(UInt(startIndex))
            if lineMaxIndex == selectedMaxIndex || line == nil {
                break
            }
            
        }
        
        return lineArray
    }
    
    func updateHitRangeWith(point: CGPoint, touchIsLeft: Bool) -> Void {
        let hitIndex = self.closestCursorIndex(to: point)
        if touchIsLeft {
            if hitIndex >= hitRange.location + hitRange.length {
                return
            }
            hitRange = NSRange.init(location: hitIndex, length: hitRange.location + hitRange.length - hitIndex)
        }else {
            if hitIndex <= hitRange.location {
                return
            }
            hitRange = NSRange.init(location: hitRange.location, length: hitIndex - hitRange.location + 1)
        }
    }
    
    func showMenuItemView(toNextPage:Bool = false, toPreviousPage:Bool = false) -> Void {
        self.becomeFirstResponder()
        let menuController = UIMenuController.shared
        let copyItem = UIMenuItem.init(title: "复制", action: #selector(onCopyItemClicked))
        let lineItem = UIMenuItem.init(title: "划线", action: #selector(onClickLineItem))
        let noteItem = UIMenuItem.init(title: "笔记", action: #selector(onNoteItemClicked))
        let deleteItem = UIMenuItem(title: "删除", action: #selector(onDeleteItemClicked))
        let toNextItem = UIMenuItem(title: "下一页", action: #selector(onToNextItemClicked))
        let toPreviousItem = UIMenuItem(title: "上一页", action: #selector(onToPreviousItemClicked))
        if toNextPage {
            menuController.menuItems = [copyItem, lineItem, noteItem, deleteItem, toNextItem]
        } else if toPreviousPage {
            menuController.menuItems = [toPreviousItem, copyItem, lineItem, noteItem, deleteItem]
        } else {
            menuController.menuItems = [copyItem, lineItem, noteItem, deleteItem]
        }
        
        var rect: CGRect = CGRect()
        if selectedLineArray.first != nil {
            rect = selectedLineArray.first!
        }
        menuController.showMenu(from: self, rect: rect)
    }
    
    func hideMenuItemView() -> Void {
        let menuController = UIMenuController.shared
        menuController.hideMenu(from: self)
        self.resignFirstResponder()
    }
    
    func showMagnifierView(point: CGPoint) -> Void {
        if self.magnifierView == nil {
            self.magnifierView = WLManifierView()
            magnifierView?.targetView = self
            magnifierView?.locatePoint = point
            window!.addSubview(self.magnifierView!)
        }
    }
    
    func hideMagnifierView() -> Void {
        if magnifierView != nil {
            self.magnifierView?.removeFromSuperview()
            self.magnifierView = nil
        }
    }
    
    
    //    MARK: gesture delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let hitPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let leftRect = CGRect(x: leftCursor.minX - 20, y: leftCursor.minY - 20, width: leftCursor.width + 40, height: leftCursor.height + 40)
            let rightRect = CGRect(x: rightCursor.minX - 20, y: rightCursor.minY - 20, width: rightCursor.width + 40, height: rightCursor.height + 40)
            if !leftRect.contains(hitPoint) && !rightRect.contains(hitPoint) {
                return true
            }
        }
        
        return false
    }
    
    //    MARK: menu item click method
    @objc func onCopyItemClicked() -> Void {
        let pageContent = self.attributedString.string
        var startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        if let previousRange = WLNoteConfig.shared.currentSelectedRange {
            var offset = pageContent.distance(from: pageContent.startIndex, to: startIndex)
            if previousRange.location + previousRange.length < offset {
                startIndex = String.Index(utf16Offset: previousRange.location, in: pageContent)
            }
            offset = pageContent.distance(from: pageContent.startIndex, to: endIndex)
            if previousRange.location > offset {
                endIndex = String.Index(utf16Offset: previousRange.location + previousRange.length, in: pageContent)
            }
        }
        let slice = pageContent[startIndex...endIndex]
        let startX = pageContent.distance(from: pageContent.startIndex, to: startIndex)
        let endX = pageContent.distance(from: pageContent.startIndex, to: endIndex)
        let range = NSMakeRange(startX, endX - startX + 1)
        print("当前选中范围 \(range)  选中内容 \(slice)")
        WLNoteConfig.shared.currentSelectedRange = nil
        
        self.resignFirstResponder()
        
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    
    @objc func onNoteItemClicked() -> Void {
        let pageContent = self.attributedString.string
        var startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        if let previousRange = WLNoteConfig.shared.currentSelectedRange {
            var offset = pageContent.distance(from: pageContent.startIndex, to: startIndex)
            if previousRange.location + previousRange.length < offset {
                startIndex = String.Index(utf16Offset: previousRange.location, in: pageContent)
            }
            offset = pageContent.distance(from: pageContent.startIndex, to: endIndex)
            if previousRange.location > offset {
                endIndex = String.Index(utf16Offset: previousRange.location + previousRange.length, in: pageContent)
            }
        }
        let slice = pageContent[startIndex...endIndex]
        let startX = pageContent.distance(from: pageContent.startIndex, to: startIndex)
        let endX = pageContent.distance(from: pageContent.startIndex, to: endIndex)
        let range = NSMakeRange(startX, endX - startX + 1)
        print("当前选中范围 \(range)  选中内容 \(slice)")
        
        selectedLineArray.enumerated().forEach { (_, item) in
            self.noteArr.append(item)
        }
        let note = WLBookNoteModel()
        note.chapteIndex = chapterIndex
        note.range = range
        note.sourceContent = attributedString.attributedSubstring(from: range).string
        WLNoteConfig.shared.currentSelectedRange = nil
        self.resignFirstResponder()
        
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    @objc private func onClickLineItem() {
        let pageContent = self.attributedString.string
        var startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        if let previousRange = WLNoteConfig.shared.currentSelectedRange {
            var offset = pageContent.distance(from: pageContent.startIndex, to: startIndex)
            if previousRange.location + previousRange.length < offset {
                startIndex = String.Index(utf16Offset: previousRange.location, in: pageContent)
            }
            offset = pageContent.distance(from: pageContent.startIndex, to: endIndex)
            if previousRange.location > offset {
                endIndex = String.Index(utf16Offset: previousRange.location + previousRange.length, in: pageContent)
            }
        }
        let slice = pageContent[startIndex...endIndex]
        let startX = pageContent.distance(from: pageContent.startIndex, to: startIndex)
        let endX = pageContent.distance(from: pageContent.startIndex, to: endIndex)
        let range = NSMakeRange(startX, endX - startX + 1)
        print("当前选中范围 \(range)  选中内容 \(slice)")

        let note = WLBookNoteModel()
        note.chapteIndex = chapterIndex
        note.range = range
        note.content = attributedString.attributedSubstring(from: range)
        // 划线也是笔记的一种
        addNote(note: note)
        WLNoteConfig.shared.currentSelectedRange = nil
        self.resignFirstResponder()
        
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    
    @objc private func onDeleteItemClicked() {
        let pageContent = self.attributedString.string
        var startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        if let previousRange = WLNoteConfig.shared.currentSelectedRange {
            var offset = pageContent.distance(from: pageContent.startIndex, to: startIndex)
            if previousRange.location + previousRange.length < offset {
                startIndex = String.Index(utf16Offset: previousRange.location, in: pageContent)
            }
            offset = pageContent.distance(from: pageContent.startIndex, to: endIndex)
            if previousRange.location > offset {
                endIndex = String.Index(utf16Offset: previousRange.location + previousRange.length, in: pageContent)
            }
        }
        let slice = pageContent[startIndex...endIndex]
        let startX = pageContent.distance(from: pageContent.startIndex, to: startIndex)
        let endX = pageContent.distance(from: pageContent.startIndex, to: endIndex)
        let range = NSMakeRange(startX, endX - startX + 1)
        print("当前选中范围 \(range)  选中内容 \(slice)")

        let note = WLBookNoteModel()
        note.chapteIndex = chapterIndex
        note.range = range
        note.content = attributedString.attributedSubstring(from: range)
        deleteNote(note: note)
        WLNoteConfig.shared.currentSelectedRange = nil
        
        self.resignFirstResponder()
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    
    @objc private func onToNextItemClicked() {
        WLNoteConfig.shared.currentSelectedRange = NSMakeRange(hitRange.location, hitRange.length - 1)
        NotificationCenter.default.post(name: .toNextPage, object: nil, userInfo: nil)
    }
    @objc private func onToPreviousItemClicked() {
        WLNoteConfig.shared.currentSelectedRange = NSMakeRange(hitRange.location, hitRange.length - 1)
        NotificationCenter.default.post(name: .toPreviousPage, object: nil, userInfo: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

