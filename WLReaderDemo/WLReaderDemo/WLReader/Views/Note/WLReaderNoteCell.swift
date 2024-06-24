//
//  WLReaderNoteCell.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/7.
//

import UIKit

class WLReaderNoteCell: UITableViewCell {
    static let WLReaderNoteCellIdentifier = "WLReaderNoteCellIdentifier"
    // 头像
    private var iconImageView:UIImageView?
    // 昵称
    private var nickNameLabel:UILabel?
    // 引用文本
    private var quoteContent:WLReadQuoteContent?
    // 图片
    private var noteImage:WLReadNoteImage?
    // 音频
    private var noteAudio:WLReadNoteAudio?
    // 笔记文本
    private var noteText:WLReadNoteText?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initSubviews() {
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        noteText = WLReadNoteText()
        noteText?.isHidden = true
        contentView.addSubview(noteText!)
        
        noteImage = WLReadNoteImage()
        noteImage?.isHidden = true
        contentView.addSubview(noteImage!)
        
        noteAudio = WLReadNoteAudio()
        noteAudio?.isHidden = true
        contentView.addSubview(noteAudio!)
    }
    class func cell(_ tableView:UITableView, indexPath:IndexPath) -> WLReaderNoteCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WLReaderNoteCell.WLReaderNoteCellIdentifier)
        if cell == nil {
            cell = WLReaderNoteCell(style: .default, reuseIdentifier: WLReaderNoteCell.WLReaderNoteCellIdentifier)
        }
        return cell as! WLReaderNoteCell
    }
}

