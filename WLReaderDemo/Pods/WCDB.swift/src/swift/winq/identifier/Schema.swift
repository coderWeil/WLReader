//
// Created by qiuwenchen on 2022/5/26.
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

import Foundation
import WCDB_Private

public final class Schema: Identifier<CPPSchema> {
    public convenience init(with name: String) {
        self.init(with: WCDBSchemaCreateWithName(name.cString))
    }

    nonisolated(unsafe) public static let main: Schema = Schema(with: WCDBSchemaMain())
    nonisolated(unsafe) public static let temp: Schema = Schema(with: WCDBSchemaTemp())
}

extension Schema: SchemaConvertible {
    public func asSchema() -> Schema {
        return self
    }
}

extension String: SchemaConvertible {
    public func asSchema() -> Schema {
        return Schema(with: self)
    }
}
