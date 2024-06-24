//
//  WLReaderNoteView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/24.
//

import UIKit
import SnapKit

class WLReaderNoteView: WLReaderMenuBaseView, UITableViewDelegate, UITableViewDataSource {
    private var closeBtn:UIButton!
    private var lineView:UIView!
    // 评论列表
    private var noteListView:WLReaderBaseTableView!
    // 笔记数据
    private var noteData:[WLBookNoteModel]! = []
    
    override func addSubviews() {
        super.addSubviews()
        initCloseBtn()
    }
    private func initCloseBtn() {
        lineView = UIView()
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        addSubview(lineView)
        
        closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.addTarget(self, action: #selector(_onCloseEvent), for: .touchUpInside)
        closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -90 / 180)
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        addSubview(closeBtn)
        
        noteListView = WLReaderBaseTableView(frame: .zero, style: .plain)
        noteListView.backgroundColor = .clear
        addSubview(noteListView)
        
        
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.top.equalTo(20)
            make.width.height.equalTo(15)
        }
        noteListView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.closeBtn.snp.bottom).offset(10)
        }
    }
    
    @objc private func _onCloseEvent() {
        menu.showNoteView(show: false)
    }
    
    public func updateMainColor() {
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
    }
    public func configNotesArr() {
        noteData = WLNoteConfig.shared.readNotes()
    }
}

extension WLReaderNoteView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
