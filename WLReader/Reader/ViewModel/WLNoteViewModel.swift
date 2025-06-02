//
//  WLNoteViewModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//  笔记相关

import UIKit
import RxSwift
import RxCocoa


class WLNoteViewModel: NSObject {
//    private let provider = DKAPIProvider<WLReaderAPI>()
    private let disposeBag = DisposeBag()
    
    // Input
    // 添加,修改，删除笔记参数
    let addNoteParams = PublishSubject<[String: Any]>()
    // 修改
    let editNoteParams = PublishSubject<[String:Any]>()
    // 删除
    let delNoteParams = PublishSubject<[String:Any]>()
    // 笔记列表参数
    let noteListParams = PublishSubject<[String:Any]>()
    // 图片上传参数
    let uploadParams = PublishSubject<UIImage>()
    
    // 添加笔记之后的回调
    let noteHandler = PublishSubject<Void?>()
    
    // 笔记列表数据
    let noteListModel = PublishSubject<WLNoteListModel?>()
        
    // 图片上传
    let uploadHandler = PublishSubject<String?>()
    
    private var tempNoteModel:WLBookNoteModel?
    
    override init() {
        super.init()
        // 添加，删除，更新笔记
//        let _ = addNoteParams
//            .flatMapLatest { [weak self] params -> Observable<DKBaseModel<WLBookNoteModel>?> in
//                return self!.provider.request(.addNote(params: params), for: DKBaseModel<WLBookNoteModel>.self)
//            }
//            .subscribe(onNext: { [weak self] res in
//                if res?.resultCode == .success {
//                    self?.noteHandler.onNext(nil)
//                }
//            }, onCompleted: { [weak self] in
//                self?.noteHandler.onCompleted()
//            })
//            .disposed(by: disposeBag)
//        // 编辑
//        let _ = editNoteParams
//            .flatMapLatest { [weak self] params -> Observable<DKBaseModel<WLBookNoteModel>?> in
//                return self!.provider.request(.editNote(params: params), for: DKBaseModel<WLBookNoteModel>.self)
//            }
//            .subscribe(onNext: { [weak self] res in
//                if res?.resultCode == .success {
//                    self?.noteHandler.onNext(nil)
//                }
//            }, onCompleted: { [weak self] in
//                self?.noteHandler.onCompleted()
//            })
//            .disposed(by: disposeBag)
//        // 删除
//        let _ = delNoteParams
//            .flatMapLatest { [weak self] params -> Observable<DKBaseModel<WLBookNoteModel>?> in
//                return self!.provider.request(.deleteNote(params: params), for: DKBaseModel<WLBookNoteModel>.self)
//            }
//            .subscribe(onNext: { [weak self] res in
//                if res?.resultCode == .success {
//                    self?.noteHandler.onNext(nil)
//                }
//            }, onCompleted: { [weak self] in
//                self?.noteHandler.onCompleted()
//            })
//            .disposed(by: disposeBag)
//        // 笔记列表
//        let _ = noteListParams
//            .flatMapLatest { [weak self] params -> Observable<DKBaseModel<WLNoteListModel>?> in
//                return self!.provider.request(.notePage(params: params), for: DKBaseModel<WLNoteListModel>.self)
//            }
//            .subscribe(onNext: { [weak self] res in
//                if res?.resultCode == .success {
//                    self?.noteListModel.onNext(res?.data)
//                }
//            }, onCompleted: { [weak self] in
//                self?.noteListModel.onCompleted()
//            })
//            .disposed(by: disposeBag)
//        // 文件上传
//        let _ = uploadParams
//            .flatMapLatest { [weak self] params -> Observable<DKBaseModel<Any>?> in
//                return self!.provider.request(.upload(image: params), for: DKBaseModel<Any>.self)
//            }
//            .flatMap { [weak self] response -> Observable<DKBaseModel<Any>?> in
//                self?.tempNoteModel?.noteContent?.imageUrl = response?.data as? String
//                let params:[String:Any] = [
//                    "bookId": WLBookConfig.shared.bookModel.bookId as Any,
//                    "chapterNumber": WLBookConfig.shared.bookModel.chapterIndex as Any,
//                    "startLocation": self?.tempNoteModel?.startLocation as Any,
//                    "endLocation": self?.tempNoteModel?.endLocation as Any,
//                    "noteContent": self?.tempNoteModel?.noteContent?.toJSON() as Any,
//                    "noteType": self?.tempNoteModel?.noteType.rawValue as Any,
//                    "sourceContent": self?.tempNoteModel?.sourceContent?.toJSON() as Any
//                ]
//                self?.tempNoteModel = nil
//                return self!.provider.request(.addNote(params: params), for: DKBaseModel<Any>.self)
//            }
//            .subscribe(onNext: { [weak self] res in
//                self?.noteHandler.onNext(nil)
//            }, onCompleted: { [weak self] in
//                self?.noteHandler.onCompleted()
//            })
//            .disposed(by: disposeBag)
        
    }
    
    
    
    // MARK - 添加笔记
    func addNote(params:[String:Any], success: (()->Void)?) {
        addNoteParams.onNext(params)
    }
    // MARK - 修改笔记
    func editNote(params:[String:Any], success: (()->Void)?) {
        editNoteParams.onNext(params)
    }
    // MARK - 删除笔记
    func deleteNote(noteId:String, success: (()->Void)?) {
        delNoteParams.onNext(["id": noteId])
    }
    // MARK - 获取笔记列表
    func noteList(pageNumber:Int = 1, _ pageSize: Int = 500, bookId:String, chapterNumber:Int, success: ((_ listModel: WLNoteListModel?)->Void)?) {
        let params:[String:Any] = ["pageNumber": pageNumber, "pageSize":pageSize, "bookId": bookId, "chapterNumber":chapterNumber, "userId": 1]
        noteListParams.onNext(params)
    }
    // MARK - 上传图片
    func upload(image:UIImage, noteModel:WLBookNoteModel?) {
        tempNoteModel = noteModel
        uploadParams.onNext(image)
    }
}
