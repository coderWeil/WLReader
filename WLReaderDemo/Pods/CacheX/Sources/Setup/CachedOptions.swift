//
//  CachedOptions.swift
//  CacheX
//
//  Created by Condy on 2023/3/30.
//

import Foundation

public struct CachedOptions: OptionSet, Hashable {
    public let rawValue: UInt16
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
    
    /// Do not use any cache.
    public static let none = CachedOptions(rawValue: 1 << 0)
    /// Cache the data in memory.
    public static let memory = CachedOptions(rawValue: 1 << 1)
    /// Cache the data in disk.
    public static let disk = CachedOptions(rawValue: 1 << 2)
    /// Use memory and disk cache at the same time to read memory first.
    public static let diskAndMemory: CachedOptions = [.memory, .disk]
    /// All cache types.
    public static let all: CachedOptions = [.memory, .disk]
}

extension CachedOptions {
    func cacheNameds() -> [String] {
        var nameds = [String]()
        if contains(.memory) {
            nameds.append(Memory.named)
        }
        if contains(.disk) {
            nameds.append(Disk.named)
        }
        return nameds
    }
    
    func caches() -> [String: Cacheable] {
        var caches = [String: Cacheable]()
        if contains(.memory) {
            caches[Memory.named] = Memory()
        }
        if contains(.disk) {
            caches[Disk.named] = Disk()
        }
        return caches
    }
}

@objc public enum OCCachedOptions: Int {
    case none = 0
    case memory
    case disk
    case diskAndMemory
    case all
    
    var options: CachedOptions {
        switch self {
        case .none:
            return .none
        case .memory:
            return .memory
        case .disk:
            return .disk
        case .diskAndMemory:
            return .diskAndMemory
        case .all:
            return .all
        }
    }
}
