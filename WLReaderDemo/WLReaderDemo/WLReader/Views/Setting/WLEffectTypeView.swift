//
//  WLEffectTypeView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//

import UIKit
import SnapKit

class WLEffectTypeCell: UITableViewCell {
    
    private var nameLabel:UILabel!
    var model:WLEffectTypeModel! {
        didSet {
            nameLabel.text = model.name
            nameLabel.textColor = model.type == WLBookConfig.shared.effetType ? WL_READER_CURSOR_COLOR : WL_READER_TEXT_COLOR
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
    class func cell(tableView:UITableView) -> WLEffectTypeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "WLEffectTypeCell")
        if cell == nil {
            cell = WLEffectTypeCell(style: .default, reuseIdentifier: "WLEffectTypeCell")
        }
        return cell as! WLEffectTypeCell
    }
    
}

class WLEffectTypeView: WLReaderMenuBaseView, UITableViewDelegate, UITableViewDataSource {
    private var effectTypeModels:[WLEffectTypeModel] = [WLEffectTypeModel]()
    private var effectList:WLReaderBaseTableView!
    private var closeBtn:UIButton!
    private var lineView:UIView!
    
    override func addSubviews() {
        super.addSubviews()
        
        effectTypes.enumerated().forEach { (index, item) in
            var model = WLEffectTypeModel()
            model.index = index
            model.name = item
            model.type = WLEffectType(rawValue: index)
            effectTypeModels.append(model)
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
        
        effectList = WLReaderBaseTableView(frame: .zero, style: .plain)
        effectList.showsVerticalScrollIndicator = false
        effectList.showsHorizontalScrollIndicator = false
        effectList.delegate = self
        effectList.dataSource = self
        effectList.separatorStyle = .none
        addSubview(effectList)
        
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.top.equalTo(20)
            make.width.height.equalTo(15)
        }
        
        effectList.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(self.closeBtn.snp.bottom).offset(20)
            make.bottom.equalTo(-WL_BOTTOM_HOME_BAR_HEIGHT)
        }
    }
    @objc private func _onCloseEvent() {
        menu.showEffectTypeView(show: false)
    }
    public func updateMainColor() {
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        effectList.reloadData()
    }
    
}
extension WLEffectTypeView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return effectTypeModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WLEffectTypeCell.cell(tableView: tableView)
        cell.model = effectTypeModels[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if WLBookConfig.shared.effectTypeIndex == indexPath.row {
            return
        }
        WLBookConfig.shared.effectTypeIndex = indexPath.row
        tableView.reloadData()
        // 更改字体
        menu.delegate?.readerMenuChangeEffectType?(menu: menu)
        menu.settingView.reload()
    }
}
