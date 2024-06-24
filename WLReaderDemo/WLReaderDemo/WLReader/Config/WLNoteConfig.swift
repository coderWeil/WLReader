//
//  WLNoteConfig.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/15.
//  笔记相关的数据处理类

import UIKit

class WLNoteConfig: NSObject {
    static let shared = WLNoteConfig()
    // 记录当前章节选中的范围，这个是以章节为维度
    private var selectedRanges:[Int:[NSRange]]! = [Int:[NSRange]]()
    // 用来保存所有的章节笔记数据
    private var noteDataDic:[Int: [WLBookNoteModel]]! = [Int:[WLBookNoteModel]]()
    // 记录下当前展示的章节
    var currentChapterModel:WLBookChapter!
    // 记录当前页选中的笔记范围，这个只会保留一个，如果在笔记，划线之后，是需要删除的，只有在跨页选择的时候这个才有用
    var currentSelectedRange:NSRange?
    
    class func clear() {
        WLNoteConfig.shared.noteDataDic = [:]
        WLNoteConfig.shared.selectedRanges = [:]
        WLNoteConfig.shared.currentChapterModel = nil
    }
    public func addNotes(notes:[WLBookNoteModel]?) {
        guard let notes = notes else { return }
        // 先根据章节index取出已缓存的笔记数据
        var notesArr = noteDataDic[currentChapterModel.chapterIndex]
        if var arr = notesArr { // 如果原本存在，则追加
            arr.append(contentsOf: notes)
            noteDataDic[currentChapterModel.chapterIndex] = arr
        }else {// 否则就新增
            noteDataDic[currentChapterModel.chapterIndex] = notes
        }
        // 重新计算选中的range
        notesArr = noteDataDic[currentChapterModel.chapterIndex]
        var newRanges = [NSRange]()
        for note in notesArr! {
            newRanges.append(note.range)
        }
        selectedRanges[currentChapterModel.chapterIndex] = newRanges
    }
    public func readNotes() -> [WLBookNoteModel]? {
        guard let currentChapterModel = currentChapterModel else { return [] }
        return noteDataDic[currentChapterModel.chapterIndex]
    }
    // 获取所有的选中范围
    public func readSelectedRanges() -> [NSRange]? {
        guard let currentChapterModel = currentChapterModel else { return [] }
        return selectedRanges[currentChapterModel.chapterIndex]
    }
    // 移除本章节的内容
    public func removeNotes(chapteModel:WLBookChapter?) {
        guard let chapteModel = chapteModel else { return}
        noteDataDic[chapteModel.chapterIndex] = nil
    }
    
}
