//
//  WLNoteConfig.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/15.
//  笔记相关的数据处理类

import UIKit
import RxSwift

class WLNoteConfig: NSObject {
    static let shared = WLNoteConfig()
    // 按章节维度进行存储
    var chapterNoteMap:[Int: [WLBookNoteModel]] = [Int: [WLBookNoteModel]]()
    // 记录下当前展示的章节
    var currentChapterModel:WLBookChapter!
    // 记录当前页选中的笔记范围，这个只会保留一个，如果在笔记，划线之后，是需要删除的，只有在跨页选择的时候这个才有用
    var currentSelectedRange:NSRange?
    private let noteVM:WLNoteViewModel! = WLNoteViewModel()
    private let disposeBag = DisposeBag()
    
    // 请求结果返回
    let noteHandler = PublishSubject<Void?>()
    
    class func clear() {
        WLNoteConfig.shared.chapterNoteMap.removeAll()
        WLNoteConfig.shared.currentChapterModel = nil
    }
    
    override init() {
        super.init()
        self.setupBindings()
    }
    
    // MARK - 设置绑定
    private func setupBindings() {
       let _ = noteVM
            .noteHandler
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .refreshNotesPage, object: nil, userInfo: nil)
                self?.noteHandler.onNext(nil)
            }, onCompleted: {
                print("完毕")
            })
            .disposed(by: disposeBag)
    }
    
    
    // 这个是为了每一次请求最新的笔记数据，进行保存
    public func addNotes(notes:[WLBookNoteModel]?) {
        guard let notes = notes else { return }
        var notesArr = chapterNoteMap[currentChapterModel.chapterIndex] ?? []
        // 追加
        notesArr.append(contentsOf: notes)
        chapterNoteMap[currentChapterModel.chapterIndex] = notesArr
    }
    public func addNote(note:WLBookNoteModel?, _ success:(() -> Void)?) {
        guard let note = note else { return }
        var params:[String:Any] = [String:Any]()
        params["bookId"] = WLBookConfig.shared.bookModel.bookId
        params["chapterNumber"] = WLBookConfig.shared.bookModel.chapterIndex
        params["startLocation"] = note.startLocation
        params["endLocation"] = note.endLocation
        params["noteContent"] = note.noteContent?.toJSON()
        params["sourceContent"] = note.sourceContent?.toJSON()
        params["noteType"] = note.noteType.rawValue            
        noteVM.addNote(params: params, success: nil)
    }
    // 移除本章节的内容
    public func removeNotes(chapterModel:WLBookChapter?) {
        guard let chapterModel = chapterModel else { return}
        chapterNoteMap[chapterModel.chapterIndex] = nil
    }
    // 根据note移除对应的内容
    public func removeNote(note:WLBookNoteModel?) {
        guard let note = note else { return }
        noteVM.deleteNote(noteId: note.noteIdStr!, success: nil)
    }
    // 根据NoteId移除
    public func removeNote(noteId:String?) {
        guard let noteId = noteId else { return }
        noteVM.deleteNote(noteId: noteId, success: nil)
    }
    // 读取当前章节的笔记数据
    public func readChapterNotes() -> [WLBookNoteModel]? {
        guard let currentChapterModel = currentChapterModel else { return [] }
        let notes = chapterNoteMap[currentChapterModel.chapterIndex] ?? []
        return notes
    }
}
