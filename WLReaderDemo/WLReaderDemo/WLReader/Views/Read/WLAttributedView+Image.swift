//
//  WLAttributedView+Image.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import DTCoreText

extension WLAttributedView {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment.isKind(of: DTImageTextAttachment.self) {
            let imageView = WLCustomLazyImageView()
            imageView.url = attachment.contentURL
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRectMake((attributedTextContentView.frame.width - frame.width) / 2.0, frame.origin.y, frame.width, frame.height)
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(_onTapImage(tap:)))
            imageView.addGestureRecognizer(tap)
            // 查看当前视图所在的位置，是否与笔记位置重合
            guard let notes = WLNoteConfig.shared.readChapterNotes() else { return imageView }
            for note in notes {
                if note.noteType == .note || note.noteType == .line {
                    if note.sourceContent?.type == 1 {
                        if note.sourceContent?.imageSource == attachment.contentURL.relativePath {
                            imageView.imageIdentifier = note.noteIdStr
                            imageView.layer.borderColor = WL_READER_CURSOR_COLOR.cgColor
                            imageView.layer.borderWidth = 2.0
                            break
                        }
                    }
                }
            }
            return imageView
        }
        return nil
    }
    
    @objc private func _onTapImage(tap:UITapGestureRecognizer) {
        let imageView = tap.view as! WLCustomLazyImageView
        
        currentClickImageView = imageView
        
        if let noteId = imageView.imageIdentifier {
            self.becomeFirstResponder()
            currentNoteId = noteId
            let menuController = UIMenuController.shared
            let detailItem = UIMenuItem.init(title: "查看", action: #selector(toImageNoteDetail))
            let deleteItem = UIMenuItem(title: "删除", action: #selector(deleteImageNote))
            let bigImageItem = UIMenuItem.init(title: "大图", action: #selector(lookBigImage))
            menuController.menuItems = [detailItem, bigImageItem, deleteItem]
            menuController.showMenu(from: self, rect: imageView.frame)
            return
        }
        
        lookBigImage()
    }
    private func sourceFrames(imageView:DTLazyImageView) -> [CGRect] {
        let viewFrame = imageView.convert(imageView.bounds, to: NSObject.wl_topController()?.view)
        return [viewFrame]
    }
    private func photos(image:UIImage) -> [WLReaderPhotoModel] {
        let model = WLReaderPhotoModel()
        model.image = image
        return [model]
    }
    @objc private func toImageNoteDetail() {
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
    @objc private func deleteImageNote() {
        WLNoteConfig.shared.removeNote(noteId: currentNoteId)
    }
    @objc private func lookBigImage() {
        guard let imageView = currentClickImageView else { return }
        let transitionParam = WLReaderPhotoTransition()
        transitionParam.transitionImage = imageView.image
        transitionParam.sourceFrames = sourceFrames(imageView: imageView)
        transitionParam.transitionIndex = 0
        transitionParam.openSpring = false
        transitionParam.duration = 0.25
        animatedTransition = nil
        animatedTransition = WLReaderPhotoInteractive()
        animatedTransition?.transition = transitionParam
        
        let browser = WLReaderPhotoBroswer()
        browser.showPageIndicator = true
        browser.photos = photos(image: imageView.image!)
        browser.animationTransition = animatedTransition
        browser.transitioningDelegate = animatedTransition
        browser.modalPresentationStyle = .fullScreen
        NSObject.wl_topController()?.present(browser, animated: true)
        browser.reload()
    }
    public func hideImageNoteMenu() {
        let menuController = UIMenuController.shared
        menuController.hideMenu(from: self)
        self.resignFirstResponder()
        currentNoteId = nil
        currentClickImageView = nil
    }
}
