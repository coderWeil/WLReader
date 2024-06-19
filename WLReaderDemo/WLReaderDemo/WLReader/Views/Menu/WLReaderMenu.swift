//
//  WLReaderMenu.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import Foundation
import UIKit

@objc protocol WLReaderMenuProtocol: NSObjectProtocol {
    /// 返回事件
    @objc optional func readerMenuBackEvent()
    /// 分享
    @objc optional func readerMenuShareEvent()
    /// 书签
    @objc optional func readerMenuMarkEvent(selected:Bool)
    /// 上一章
    @objc optional func readerMenuPreviousEvent()
    /// 下一章
    @objc optional func readerMenuNextEvent()
    /// 拖拽章节进度
    @objc optional func readerMenuDraggingProgress(progress:Float)
    /// 点击章节列表
    @objc optional func readerMenuClickCatalogueEvent(menu:WLReaderMenu!)
    /// 点击设置
    @objc optional func readerMenuClickSettingEvent(menu:WLReaderMenu!)
    /// 改变字体大小
    @objc optional func readerMenuChangeFontSize(menu:WLReaderMenu!)
    /// 改变字体类型
    @objc optional func readerMenuChangeFontType(menu:WLReaderMenu!)
    /// 改变行间距
    @objc optional func readerMenuChangeLineSpacing(menu:WLReaderMenu!)
    /// 改变翻页方式
    @objc optional func readerMenuChangeEffectType(menu:WLReaderMenu!)
    /// 改变阅读背景
    @objc optional func readerMenuChangeBgColor(menu:WLReaderMenu!)
    /// 亮度值更改
    @objc optional func readerMenuChangeBrightness(value:Float)
    /// 点击笔记事件
    @objc optional func readerMenuClickNoteEvent()
}

class WLReaderMenu: NSObject, UIGestureRecognizerDelegate {
    
    public weak var readerVc:WLReadContainer!
    private weak var contentView:WLContainerView!
    weak var readerViewController:WLReadViewController!
    weak var delegate:WLReaderMenuProtocol?
    /// 顶部
    private var topView:WLReaderTopView!
    /// 底部
    private var bottomView:WLReaderBottomView!
    /// 设置
    public var settingView:WLReaderSettingView!
    /// 字体类型切换视图
    private var fontTypeView:WLFontTypeView!
    /// 笔记视图
    private var noteView:WLReaderNoteView!
    /// 翻页切换视图
    private var effectView:WLEffectTypeView!
    /// 阅读背景视图
    private var bgColorView:WLBgColorView!
    /// 菜单是否显示
    private var isMenuShow:Bool = false
    private var isAnimateComplete:Bool = true
    private var tapGesture:UITapGestureRecognizer!
    
    override init() {
        super.init()
    }
    
    convenience init(readerVc:WLReadContainer, delegate:WLReaderMenuProtocol?) {
        self.init()
        self.readerVc = readerVc
        self.contentView = readerVc.container
        self.delegate = delegate
        
        initTapGesture()
        
        initTopView()
        initBottomView()
        initSettingView()
        initFontTypeView()
        initEffectTypeView()
        initBgColorView()
        initNoteView()
    }
    
    // MARK - 主视图点击手势
    private func initTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
        self.tapGesture = tap
    }
    @objc func onTap() {
        showMenu(show: !isMenuShow)
    }
    /// 点击这些控件不需要执行手势
    private let ignoreGestureViews:[String] = ["WLReaderTopView","WLReaderBottomView","WLReaderSettingView", "WLBottomFunctionView","WLFontTypeView","WLEffectTypeView","WLBGColorView","WLBottomProgressView","UIControl", "UIButton","UISlider", "UITableViewCellContentView"]
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let classString = String(describing: type(of: touch.view!))
        var isCanRecognize:Bool = true
        if ignoreGestureViews.contains(classString) {
            isCanRecognize = false
        }
        return isCanRecognize
    }    
    // MARK - 顶部工具栏
    private func initTopView() {
        topView = WLReaderTopView(menu: self)
        contentView.addSubview(topView)
        topView.frame = CGRectMake(0, -WL_NAV_BAR_HEIGHT, WL_SCREEN_WIDTH, WL_NAV_BAR_HEIGHT)
    }
    // MARK - 底部工具栏
    private func initBottomView() {
        bottomView = WLReaderBottomView(menu: self)
        contentView.addSubview(bottomView)
        bottomView.frame = CGRectMake(0, WL_READER_BOTTOM_HEIGHT + WL_SCREEN_HEIGHT, WL_SCREEN_WIDTH, WL_READER_BOTTOM_HEIGHT)
    }
    // MARK - 设置页面
    private func initSettingView() {
        settingView = WLReaderSettingView(menu: self)
        contentView.addSubview(settingView)
        settingView.frame = CGRectMake(0, WL_READER_SETTING_HEIGHT + WL_SCREEN_HEIGHT, WL_SCREEN_WIDTH, WL_READER_SETTING_HEIGHT)
    }
    // MARK - 字体类型切换视图
    private func initFontTypeView() {
        fontTypeView = WLFontTypeView(menu: self)
        contentView.addSubview(fontTypeView)
        fontTypeView.frame = CGRectMake(0, WL_READER_FONTTYPE_HEIGHT + WL_SCREEN_HEIGHT, WL_SCREEN_WIDTH, WL_READER_FONTTYPE_HEIGHT)
    }
    // MARK - 翻页切换视图
    private func initEffectTypeView() {
        effectView = WLEffectTypeView(menu: self)
        contentView.addSubview(effectView)
        effectView.frame = CGRectMake(0, WL_READER_EFFECTTYPE_HEIGHT + WL_SCREEN_HEIGHT, WL_SCREEN_WIDTH, WL_READER_EFFECTTYPE_HEIGHT)
    }
    // MARK - 阅读背景视图
    private func initBgColorView() {
        bgColorView = WLBgColorView(menu: self)
        contentView.addSubview(bgColorView)
        bgColorView.frame = CGRectMake(0, WL_SCREEN_HEIGHT + WL_READER_BACKGROUND_HEIGHT, WL_SCREEN_WIDTH, WL_READER_BACKGROUND_HEIGHT)
    }
    // MARK - 笔记视图
    private func initNoteView() {
        noteView = WLReaderNoteView(menu: self)
        contentView.addSubview(noteView)
        noteView.frame = CGRectMake(0, WL_SCREEN_HEIGHT + WL_READER_NOTE_HEIGHT, WL_SCREEN_WIDTH, WL_READER_NOTE_HEIGHT)
    }
    public func showMenu(show:Bool) {
        if isMenuShow == show || !isAnimateComplete {
            return
        }
        isMenuShow = show
        isAnimateComplete = false
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.topView.frame.origin.y = 0
                self.bottomView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_BOTTOM_HEIGHT
            } completion: { _ in
                self.isAnimateComplete = true
            }
        }else {
            settingView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_SETTING_HEIGHT
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.topView.frame.origin.y = -WL_NAV_BAR_HEIGHT
                self.bottomView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_BOTTOM_HEIGHT
                self.fontTypeView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_FONTTYPE_HEIGHT
                self.effectView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_EFFECTTYPE_HEIGHT
                self.bgColorView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_BACKGROUND_HEIGHT
                self.noteView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_NOTE_HEIGHT
            } completion: { _ in
                self.isAnimateComplete = true
            }
        }
    }
    public func showSettingView(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.settingView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_SETTING_HEIGHT
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.settingView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_SETTING_HEIGHT
            }
        }
    }
    public func showFontTypeView(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.fontTypeView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_FONTTYPE_HEIGHT
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.fontTypeView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_FONTTYPE_HEIGHT
            }
        }
    }
    public func showEffectTypeView(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.effectView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_EFFECTTYPE_HEIGHT
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.effectView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_EFFECTTYPE_HEIGHT
            }
        }
    }
    public func showBgColorView(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.bgColorView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_BACKGROUND_HEIGHT
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.bgColorView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_BACKGROUND_HEIGHT
            }
        }
    }
    public func showNoteView(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.noteView.frame.origin.y = WL_SCREEN_HEIGHT - WL_READER_NOTE_HEIGHT
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.noteView.frame.origin.y = WL_SCREEN_HEIGHT + WL_READER_NOTE_HEIGHT
            }
        }
    }
    public func reloadReadProgress() {
        bottomView.reloadProgress()
    }
    public func caclReadProgress() -> Float {
        return readerVc.caclCurrentReadProgress()
    }
    public func updateSubviewBackground() {
        topView.backgroundColor  = WL_READER_MENU_BG_COLOR
        bottomView.backgroundColor = WL_READER_MENU_BG_COLOR
        settingView.backgroundColor = WL_READER_MENU_BG_COLOR
        fontTypeView.backgroundColor = WL_READER_MENU_BG_COLOR
        effectView.backgroundColor = WL_READER_MENU_BG_COLOR
        bgColorView.backgroundColor = WL_READER_MENU_BG_COLOR
        topView.updateMainColor()
        bottomView.updateMainColor()
        settingView.updateMainColor()
        effectView.updateMainColor()
        fontTypeView.updateMainColor()
        bgColorView.updateMainColor()
    }
    // 刷新顶部
    public func updateTopView() {
        topView.updateTopView()
    }
}
