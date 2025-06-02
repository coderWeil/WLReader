//
//  WLReaderNoteCell.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/7.
//

import UIKit
import SnapKit
import Kingfisher

class WLReaderNoteCell: UITableViewCell {
    static let WLReaderNoteCellIdentifier = "WLReaderNoteCellIdentifier"
    weak var tableView:UITableView!
    // 内容视图
    private var containerView:UIView!
    // 头像
    private var iconImageView:UIImageView!
    // 昵称
    private var nickNameLabel:UILabel!
    // 笔记和引用的视图
    private var noteTextQuoteText:WLNoteTextQuoteText!
    private var noteTextQuoteImage:WLNoteTextQuoteImage!
    private var noteImageQuoteText:WLNoteImageQuoteText!
    private var noteImageQuoteImage:WLNoteImageQuoteImage!
    private var noteTextImageQuoteText:WLNoteTextImageQuoteText!
    private var noteTextImageQuoteImage:WLNoteTextImageQuoteImage!
    private var noteNullQuoteText:WLNoteNullQuoteText!
    private var noteNullQuoteImage:WLNoteNullQuoteImage!
    
    private var text_text_bottom:Constraint!
    private var text_image_bottom:Constraint!
    private var image_text_bottom:Constraint!
    private var image_image_bottom:Constraint!
    private var textImage_text_bottom:Constraint!
    private var textImage_image_bottom:Constraint!
    private var null_text_bottom:Constraint!
    private var null_image_bottom:Constraint!

    // 笔记数据
    public var noteModel:WLBookNoteModel! {
        didSet {
            configSubviews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initSubviews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView.layer.cornerRadius = 6
        containerView.backgroundColor = .white.withAlphaComponent(0.2)
        contentView.addSubview(containerView)
        
        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        containerView.addSubview(iconImageView)
        
        nickNameLabel = UILabel()
        nickNameLabel.font = WL_FONT(14)
        nickNameLabel.textColor = WL_READER_TEXT_COLOR
        containerView.addSubview(nickNameLabel)
        
        noteTextQuoteText = WLNoteTextQuoteText()
        containerView.addSubview(noteTextQuoteText)
        
        noteTextQuoteImage = WLNoteTextQuoteImage()
        containerView.addSubview(noteTextQuoteImage)
        
        noteImageQuoteText = WLNoteImageQuoteText()
        containerView.addSubview(noteImageQuoteText)
        
        noteImageQuoteImage = WLNoteImageQuoteImage()
        containerView.addSubview(noteImageQuoteImage)
        
        noteTextImageQuoteText = WLNoteTextImageQuoteText()
        containerView.addSubview(noteTextImageQuoteText)
        
        noteTextImageQuoteImage = WLNoteTextImageQuoteImage()
        containerView.addSubview(noteTextImageQuoteImage)
        
        noteNullQuoteText = WLNoteNullQuoteText()
        containerView.addSubview(noteNullQuoteText)
        
        noteNullQuoteImage = WLNoteNullQuoteImage()
        containerView.addSubview(noteNullQuoteImage)
        
        containerView?.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-15)
        })
        
        iconImageView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        })
        
        nickNameLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self.iconImageView!.snp.right).offset(10)
            make.centerY.equalTo(self.iconImageView!.snp.centerY)
        })
        
        noteTextQuoteText.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.text_text_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteTextQuoteImage.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.text_image_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteImageQuoteText.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.image_text_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteImageQuoteImage.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.image_image_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteTextImageQuoteText.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.textImage_text_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteTextImageQuoteImage.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.textImage_image_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteNullQuoteText.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.null_text_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
        
        noteNullQuoteImage.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            self.null_image_bottom = make.bottom.equalToSuperview().offset(-10).constraint
        }
    }
    class func cell(_ tableView:UITableView, indexPath:IndexPath) -> WLReaderNoteCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WLReaderNoteCell.WLReaderNoteCellIdentifier)
        if cell == nil {
            cell = WLReaderNoteCell(style: .default, reuseIdentifier: WLReaderNoteCell.WLReaderNoteCellIdentifier)
        }
        return cell as! WLReaderNoteCell
    }
    // MARK - 配置子视图
    private func configSubviews() {
        let noteViewType = noteModel.getNoteViewType()
        noteTextQuoteText.isHidden = noteViewType != .text_text
        noteTextQuoteImage.isHidden = noteViewType != .text_image
        noteImageQuoteText.isHidden = noteViewType != .image_text
        noteImageQuoteImage.isHidden = noteViewType != .image_image
        noteTextImageQuoteText.isHidden = noteViewType != .textImage_text
        noteTextImageQuoteImage.isHidden = noteViewType != .textImage_image
        noteNullQuoteText.isHidden = noteViewType != .null_text
        noteNullQuoteImage.isHidden = noteViewType != .null_image
        
        switch noteViewType {
        case .text_text:
            text_text_bottom.activate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteTextQuoteText.noteModel = noteModel
        case .text_image:
            text_text_bottom.activate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteTextQuoteImage.tableView = tableView
            noteTextQuoteImage.noteModel = noteModel
        case .image_text:
            image_text_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteImageQuoteText.tableView = tableView
            noteImageQuoteText.noteModel = noteModel
        case .image_image:
            image_image_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteImageQuoteImage.tableView = tableView
            noteImageQuoteImage.noteModel = noteModel
        case .textImage_text:
            textImage_text_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteTextImageQuoteText.tableView = tableView
            noteTextImageQuoteText.noteModel = noteModel
        case .textImage_image:
            textImage_image_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
            noteTextImageQuoteImage.tableView = tableView
            noteTextImageQuoteImage.noteModel = noteModel
        case .null_text:
            null_text_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_image_bottom.deactivate()
            noteNullQuoteText.noteModel = noteModel
        case .null_image:
            null_image_bottom.activate()
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            noteNullQuoteImage.tableView = tableView
            noteNullQuoteImage.noteModel = noteModel
        case .null:
            text_text_bottom.deactivate()
            text_text_bottom.deactivate()
            image_text_bottom.deactivate()
            image_image_bottom.deactivate()
            textImage_text_bottom.deactivate()
            textImage_image_bottom.deactivate()
            null_text_bottom.deactivate()
            null_image_bottom.deactivate()
        }
        
        iconImageView?.kf.setImage(with: URL(string: noteModel.avatar!))
        
        nickNameLabel?.text = noteModel.userName
        
        setNeedsLayout()
        layoutIfNeeded()
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}

