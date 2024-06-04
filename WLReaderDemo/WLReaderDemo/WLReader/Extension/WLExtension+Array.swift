//
//  WLExtension+Array.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/22.
//

import Foundation

extension Array {
    /**
     Return index if is safe, if not return nil
     http://stackoverflow.com/a/30593673/517707
     */
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
