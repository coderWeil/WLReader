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
        
        while line!.stringRange().location < selectedMaxIndex {
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
    
    func showMenuItemView() -> Void {
        self.becomeFirstResponder()
        let menuController = UIMenuController.shared
        let copyItem = UIMenuItem.init(title: "复制", action: #selector(onCopyItemClicked))
        let noteItem = UIMenuItem.init(title: "笔记", action: #selector(onNoteItemClicked))
        menuController.menuItems = [copyItem, noteItem]
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
        let startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        let slice = pageContent[startIndex...endIndex]
        print("当前选中范围 \(hitRange)  选中内容 \(slice)")
        
        self.resignFirstResponder()
        
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    
    @objc func onNoteItemClicked() -> Void {
        let pageContent = self.attributedString.string
        let startIndex = pageContent.index(pageContent.startIndex, offsetBy: hitRange.location)
        var endIndex = pageContent.index(startIndex, offsetBy: hitRange.length - 1)
        if pageContent.endIndex <= endIndex {
            endIndex = pageContent.index(before: endIndex)
        }
        let slice = pageContent[startIndex...endIndex]
        print("当前选中范围 \(hitRange)  选中内容 \(slice)")
        selectedLineArray.enumerated().forEach { (_, item) in
            self.noteArr.append(item)
        }
        let note = WLBookNoteModel()
        note.chapteIndex = chapterIndex
        note.range = hitRange
        note.content = attributedString.attributedSubstring(from: hitRange)
        note.note = "这是一段测试的笔记"
        addNotes(notes: [note])
//        addNote(range: hitRange)
        
        self.resignFirstResponder()
        
        selectedLineArray.removeAll()
        self.setNeedsDisplay()
        self.removeGestureRecognizer(tapGes)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

