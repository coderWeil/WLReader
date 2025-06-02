//
// Created by qiuwenchen on 2022/11/13.
//

/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if WCDB_SWIFT_BRIDGE_OBJC

import Foundation
import WCDB_Private

public extension Select {
    /// Get next selected object with type. You can do an iteration using it.
    ///
    /// - Parameter type: Type of table decodable object
    /// - Returns: Table decodable object. Nil means the end of iteration.
    /// - Throws: `Error`
    func nextObject<Object: WCTTableCoding>(of type: Object.Type = Object.self) throws -> Object? {
        assert(!properties[0].isSwiftProperty(), "Properties must belong to objc obj.")
        let prepareStatement = try getOrCreatePrepareStatement()
        guard try next() else {
            return nil
        }
        return WCTAPIBridge.extractObject(onResultColumns: properties.asWCTBridgeProperties(), from: prepareStatement.getRawStatement()) as? Object
    }

    /// Get all selected objects.
    ///
    /// - Parameter type: Type of table decodable object
    /// - Returns: Table decodable objects.
    /// - Throws: `Error`
    func allObjects<Object: WCTTableCoding>(of type: Object.Type = Object.self) throws -> [Object] {
        assert(!properties[0].isSwiftProperty(), "Properties must belong to objc obj.")
        let prepareStatement = try getOrCreatePrepareStatement()
        var objects: [Object] = []
        while try next() {
            if let obj = WCTAPIBridge.extractObject(onResultColumns: properties.asWCTBridgeProperties(), from: prepareStatement.getRawStatement()) {
                objects.append(obj as! Object)
            }
        }
        return objects
    }
}

#endif
