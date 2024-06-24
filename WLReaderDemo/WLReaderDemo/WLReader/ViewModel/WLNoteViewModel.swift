//
//  WLNoteViewModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//  笔记相关

import UIKit
import RxNetworks
import Booming

class WLNoteViewModel: NSObject {
    // MARK - 添加笔记
    func addNote(params:[String:Any], success:(() -> Void)?) {
        WLReaderAPI.addNote(params: params).HTTPRequest { json in
            print(json)
            success?()
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    // MARK - 修改笔记
    func editNote(params:[String:Any], success:(() -> Void)?) {
        WLReaderAPI.editNote(params: params).HTTPRequest { json in
            print(json)
            success?()
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    // MARK - 删除笔记
    func deleteNote(noteId:Int, success:(() -> Void)?) {
        WLReaderAPI.deleteNote(id: noteId).HTTPRequest { json in
            print(json)
            success?()
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    // MARK - 获取笔记列表
    
}
