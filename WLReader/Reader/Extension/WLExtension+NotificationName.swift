//
//  DKBookInfoModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/23.
//

import UIKit

extension Notification.Name {
    static let toNextPage = Notification.Name("WLReaderToNextPage")
    static let toPreviousPage = Notification.Name("WLReaderToPreviousPage")
    static let refreshNotesPage = Notification.Name("WLReaderRefreshNotesPage")
    static let markNoteAction = Notification.Name("WLReaderMarkNoteAction")
    static let disablePageControllerTapGesture = Notification.Name("WLReaderPageControllerTapGestureDisabled")
    static let readViewLongPress = Notification.Name("readViewLongPress")
}
