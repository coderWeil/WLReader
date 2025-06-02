//
// Created by qiuwenchen on 2024/8/15.
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

#pragma once

#include "Config.hpp"
#include "InnerHandle.hpp"

namespace WCDB {

class AutoVacuumConfig final : public Config {
public:
    AutoVacuumConfig(bool incremental);
    ~AutoVacuumConfig() override final;

    bool invoke(InnerHandle* handle) override final;

private:
    int m_mode = 0;
    const StatementPragma m_getAutoVacuumMode;
    const StatementPragma m_setAutoVacuumMode;
};

} // namespace WCDB
