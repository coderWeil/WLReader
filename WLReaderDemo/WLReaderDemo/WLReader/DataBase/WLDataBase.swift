//
//  WLDataBase.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/23.
//  此类为数据库管理类，主要针对于阅读记录数据的增删改查
//  需要建立书籍记录表，包含字段如下
//  书籍id, 书籍名，当前阅读的进度值，当前阅读章节，当前章节的阅读的location（用于定位到是第几页）

//  第二张表是数据阅读的配置表，包含信息如下
//  字体名，字体大小，翻页方式，行间距信息，阅读背景

import Foundation
import WCDBSwift

public let WLBOOK_CONFIG_TABLE_NAME = "WL_BOOK_CONFIG" // 存储的是配置相关的信息
public let WLBOOK_MARK_TABLE_NAME = "WLBOOK_MARK" // 存储的是书签信息
public let WLBOOK_TABLE_NAME = "WLBOOK_TABLE" // 以书籍为维度存储的表

class WLDataBase: NSObject {
    static let shared = WLDataBase()
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/DB/reader.db"
    var db: Database?
    
    private func createDB()  {
        if db != nil {
            db?.close()
        }
         db = Database(at: dbPath)
    }
    public func connectDB() {
        createDB()
        createTables()
    }
    /// 所有的表都在这里创建
    public func createTables() {
        do {
            try db?.create(table: WLBOOK_CONFIG_TABLE_NAME, of: WLBookConfig.self)
            try db?.create(table: WLBOOK_MARK_TABLE_NAME, of: WLBookMarkModel.self)
            try db?.create(table: WLBOOK_TABLE_NAME, of: WLBookModel.self)
        } catch {
            print(error)
        }
    }
    /// 关闭数据库
    public func closeDB() {
        db?.close()
        db = nil
    }
}

extension WLDataBase {
    /// 插入
    func insert<T: TableCodable>(_ objects: [T], tableName: String) {
            try? db?.insert(objects, intoTable: tableName)
        }
        
    func insertOrReplace<T: TableCodable>(_ objects: [T], _ property:[PropertyConvertible]?, tableName: String) {
        do {
            try db?.insertOrReplace(objects, on: property, intoTable: tableName)
        } catch {
            print(error)
        }
    }
    /// 删除
    func delete(
            _ tableName: String,
            where condition: Condition? = nil,
            orderBy orderList: [OrderBy]? = nil,
            limit: Limit? = nil,
            offset: Offset? = nil)
        {
            do {
                try db?.delete(fromTable: tableName, where: condition, orderBy: orderList, limit: limit, offset: offset)
            } catch {
                print(error)
            }
        }
    /// 更改
    func update<T: TableCodable>(
            _ tableName: String,
            on propertyConvertibleList: [PropertyConvertible],
            with object: T,
            where condition: Condition? = nil,
            orderBy orderList: [OrderBy]? = nil,
            limit: Limit? = nil,
            offset:Offset? = nil)
        {
          
            do {
                try db?.update(table: tableName,
                                      on: propertyConvertibleList,
                                      with: object,
                                      where: condition,
                                      orderBy: orderList,
                                      limit: limit,
                                      offset: offset)
            } catch {
                print(error)
            }
        }
    func update(
            _ tableName: String,
            on propertyConvertibleList: PropertyConvertible...,
            with row: [ColumnEncodable],
            where condition: Condition? = nil,
            orderBy orderList: [OrderBy]? = nil,
            limit: Limit? = nil,
            offset:Offset? = nil)
        {
            try? db?.update(table: tableName, on: propertyConvertibleList, with: row, where: condition, orderBy: orderList, limit: limit, offset: offset)
        }
    /// 查询
    /// 查对象数组
        func getObjects<T: TableCodable>(
            _ tableName: String,
            where condition: Condition? = nil,
            orderBy orderList: [OrderBy]? = nil,
            limit: Limit? = nil,
            offset: Offset? = nil) -> [T]?
        {
            let objects: [T]? = try? db?.getObjects(fromTable: tableName, where: condition, orderBy: orderList, limit: limit, offset: offset)
            return objects
        }
    /// 查单个对象
        func getObject<T: TableCodable>(
            _ tableName: String,
            on propertyConvertibleList: [PropertyConvertible],
            where condition: Condition? = nil,
            orderBy orderList: [OrderBy]? = nil,
            offset: Offset? = nil) -> T?
        {            
            let object: T? = try? db?.getObject(on:propertyConvertibleList ,fromTable: tableName, where: condition, orderBy: orderList, offset: offset)
            return object
        }
    func getObject<T: TableCodable>(
        _ tableName: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        offset: Offset? = nil) -> T?
    {
        let object: T? = try? db?.getObject(fromTable: tableName, where: condition, orderBy: orderList, offset: offset)
        return object
    }
    /// 销毁表
}
