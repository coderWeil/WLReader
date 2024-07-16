//
//  WLNoteDetailController.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//

import UIKit
import SnapKit
import YPImagePicker
import RxSwift
import Popover

class WLNoteDetailController: WLReadBaseController, WLNoteBottomViewDelegate {
    
    // 底部操作栏
    private var bottomView:WLNoteBottomView?
    // 笔记模型
    public var noteModel:WLBookNoteModel!
    // 底部栏的bottom约束
    private var bottomViewBottomConstraint: Constraint?
    // 记录选中的图片，目前仅支持一张图片
    private var selectedImage:UIImage?
    private let noteViewModel = WLNoteViewModel()
    private let disposeBag = DisposeBag()
    // 右侧视图
    private var rightBarItem:UIBarButtonItem?
    
    // 删除弹层
    private var rightPop:Popover?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    deinit {
        // 移除键盘通知
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNoteData()
        addNotify()
        
        // 右侧按钮
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("...", for: .normal)
        rightButton.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        rightButton.titleLabel?.font = WL_FONT(20)
        rightButton.addTarget(self, action: #selector(rightButtonTapped(btn:)), for: .touchUpInside)
        let righeItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = righeItem
    }
    override func addChildViews() {
        super.addChildViews()
                
        bottomView?.snp.makeConstraints({ make in
            make.left.right.equalTo(0)
            self.bottomViewBottomConstraint = make.bottom.equalToSuperview().offset(0).constraint
        })
            
        
    }
    private func addNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 设置绑定
    private func setupBindings() {
        WLNoteConfig.shared
            .noteHandler
            .subscribe(onNext: { [weak self] res in
                self?.navigationController?.popViewController(animated: true)
            }, onCompleted: {
                print("请求完成")
            })
            .disposed(by: disposeBag)
    }
    @objc private func rightButtonTapped(btn:UIButton) {
        let width = 100.0
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        let delBtn = UIButton(type: .custom)
        delBtn.setTitle("删除", for: .normal)
        delBtn.setTitleColor(.red, for: .normal)
        delBtn.addTarget(self, action: #selector(delNote), for: .touchUpInside)
        aView.addSubview(delBtn)
        delBtn.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        let options = [
          .type(.down),
          .cornerRadius(10),
          .animationIn(0.3),
          .blackOverlayColor(UIColor.clear),
          .arrowSize(CGSize.zero)
          ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView: btn)
        self.rightPop = popover
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
       adjustInputTextFieldPosition(notification: notification, isKeyboardShowing: true)
   }

   @objc private func keyboardWillHide(_ notification: Notification) {
       adjustInputTextFieldPosition(notification: notification, isKeyboardShowing: false)
   }
    private func adjustInputTextFieldPosition(notification: Notification, isKeyboardShowing: Bool) {
       guard let userInfo = notification.userInfo,
             let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
             let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
           return
       }
       
       let keyboardHeight = keyboardFrame.height
       let newTopOffset: CGFloat = isKeyboardShowing ? -keyboardHeight : 0
       
       bottomViewBottomConstraint?.update(offset: newTopOffset)
       
       UIView.animate(withDuration: animationDuration) {
           self.view.layoutIfNeeded()
       }
   }
    // MARK - 设置数据
    private func setupNoteData() {
    }

}

extension WLNoteDetailController {
    @objc func delNote() {
        rightPop?.dismiss()
        WLNoteConfig.shared.removeNote(note: noteModel)
    }
    func didClickSubmit() {
        let noteContent = WLNoteContentModel()
        let text = self.bottomView?.getInputText()
        noteContent.text = text
        noteModel.noteContent = noteContent
        // 查看是否有图片，如果有，则先上传图片
        if let image = self.selectedImage {
            noteViewModel.upload(image: image, noteModel: noteModel)
        }else {
            WLNoteConfig.shared.addNote(note: noteModel, nil)
        }
    }
    func didClickSelectImage() {
        var config = YPImagePickerConfiguration()
                
        // 设置默认选中图库页面
        config.startOnScreen = .library
        
        // 配置选择器选项
        config.screens = [.library]
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 1
        config.library.defaultMultipleSelection = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false

        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            for item in items {
                switch item {
                case .photo(let photo):
                    self.displaySelectedImage(image: photo.image)
                default:
                    break
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)

    }
    // 显示选中的图片
    func displaySelectedImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        self.view.addSubview(imageView)
        self.selectedImage = image
    }
}
