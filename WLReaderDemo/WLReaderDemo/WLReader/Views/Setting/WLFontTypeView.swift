//
//  WLFontTypeView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//  字体更改

import UIKit
import SnapKit

class WLFontTypeCell: UITableViewCell {
    private var nameLabel:UILabel!
    var model:WLFontTypeModel! {
        didSet {
            nameLabel.text = model.name
            nameLabel.textColor = model.type == WLBookConfig.shared.fontType ? WL_READER_CURSOR_COLOR : WL_READER_TEXT_COLOR
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        nameLabel = UILabel()
        nameLabel.font = WL_READER_FONT_14
        nameLabel.textColor = WL_READER_TEXT_COLOR
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
    }
    class func cell(tableView:UITableView) -> WLFontTypeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "WLFontTypeCell")
        if cell == nil {
            cell = WLFontTypeCell(style: .default, reuseIdentifier: "WLFontTypeCell")
        }
        return cell as! WLFontTypeCell
    }
}

class WLFontTypeView: WLReaderMenuBaseView, UITableViewDelegate, UITableViewDataSource {
    /// 列表
    private var fontTypeModels:[WLFontTypeModel]! = [WLFontTypeModel]()
    private var fontList:WLReaderBaseTableView!
    private var closeBtn:UIButton!
    private var lineView:UIView!
    
    override func addSubviews() {
        super.addSubviews()
        
        fontNames.enumerated().forEach { (index, item) in
            var model = WLFontTypeModel()
            model.index = index
            model.name = item
            model.type = WLReadFontNameType(rawValue: index)
            fontTypeModels.append(model)
        }
        initFontList()
    }
    private func initFontList() {
        
        lineView = UIView()
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        addSubview(lineView)
        
        closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.addTarget(self, action: #selector(_onCloseEvent), for: .touchUpInside)
        closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -90 / 180)
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        addSubview(closeBtn)
        
        fontList = WLReaderBaseTableView(frame: .zero, style: .plain)
        fontList.showsVerticalScrollIndicator = false
        fontList.showsHorizontalScrollIndicator = false
        fontList.delegate = self
        fontList.dataSource = self
        fontList.separatorStyle = .none
        addSubview(fontList)
        
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.top.equalTo(20)
            make.width.height.equalTo(15)
        }
        
        fontList.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(self.closeBtn.snp.bottom).offset(20)
            make.bottom.equalTo(-WL_BOTTOM_HOME_BAR_HEIGHT)
        }
    }
    @objc private func _onCloseEvent() {
        menu.showFontTypeView(show: false)
    }
    public func updateMainColor() {
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        fontList.reloadData()
    }
}

extension WLFontTypeView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontTypeModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WLFontTypeCell.cell(tableView: tableView)
        cell.model = fontTypeModels[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if WLBookConfig.shared.fontTypeIndex == indexPath.row {
            return
        }
        WLBookConfig.shared.fontTypeIndex = indexPath.row
        tableView.reloadData()
        // 更改字体
        menu.delegate?.readerMenuChangeFontType?(menu: menu)
        menu.settingView.reload()
    }
}
