# 版本记录

本仓库记录规范文档的版本演进。规范正文当前版本见 `docs/java-backend-standard.md` 头部。

## v1.1 —— 仓库呈现与协作

**本次只改仓库呈现层与协作配套，规范正文条款未变。**

### README 语言策略调整（重要）

原先「不带语言后缀一律英文」，改为**按受众分两类**：

| 类别 | 文件 | 无后缀语言 | 原因 |
|---|---|---|---|
| 面向人的文档 | `README.md`、`CONTRIBUTING.md` | **中文** | Gitee / GitCode 首页只渲染 `README.md`；面向国内读者默认中文 |
| 面向 AI IDE 的文件 | `AGENTS.md`、`docs/*.md`、`SKILL.md` | **英文** | 英文表述在多数模型上指令遵循更稳定 |

- `README.md` → 中文（新），`README.en.md` → 英文（新增），删除 `README.zh-CN.md`。
- Gitee 会按浏览器语言自动选择：中文浏览器看 `README.md`，英文浏览器看 `README.en.md`。
- GitCode 只渲染 `README.md`，因此中文为唯一默认。
- GitHub 显示 `README.md`（中文），顶部提供 `README.en.md` 入口。

### README 视觉改版

- 居中标题 + 副标题 + 徽章行（JDK / Spring Boot / License / 文档体量 / PRs welcome / 平台入口）。
- 特性一行速览（emoji 分隔符），`<hr>` 分隔后进入正文。
- 章节标题统一 emoji 前缀（🧩 这是什么 / 📚 内容速览 / 🚀 快速使用 / 🌏 多平台与语言版本 / 🧷 十条红线 / 🤝 参与贡献 / 📁 目录结构）。
- 要点列表改为「emoji + 加粗短语 + 冒号 + 说明」的卡片式条目。
- 中英两版样式对齐。

### 协作配套（新增）

- `CONTRIBUTING.md` / `CONTRIBUTING.en.md`：贡献方向、PR 流程、提交前自查清单、写作风格约定。
- `PULL_REQUEST_TEMPLATE.md`：GitHub 根目录 PR 模板。
- `.github/ISSUE_TEMPLATE/`：Bug 报告、条款建议模板与 `config.yml`。
- `.gitee/`：`PULL_REQUEST_TEMPLATE.zh-CN.md`、`ISSUE_TEMPLATE.zh-CN.md`（Gitee 各自的模板目录规范）。
- README 增加「🤝 参与贡献（欢迎 PR）」章节，含可复制的 fork → branch → sync → PR 流程与自查清单。

### 多平台推送

- `script/push-all.sh` 新增 `--all` 预设，一条命令推送 GitHub / Gitee / GitCode 三个已建远端。
- 远端地址：`github` = wang200507、`gitee` = wangzy01、`gitcode` = gcw_hGwaIPtW。

## v1.0（初始版本）

**基线**：Java 17 / Java 21 ｜ Spring Boot 3.x（向下兼容 2.7）

### 语言版本（v1.0）

> 该约定已在 [v1.1](#v11--仓库呈现与协作) 中按受众拆分为两类，见上文。

规范提供**中英双语**，不带语言后缀的文件一律为英文：

| 语言 | 规则入口 | 完整手册 | 技能 |
|---|---|---|---|
| 英文（默认） | `AGENTS.md` | `docs/java-backend-standard.md` | `skills/java-backend-standard/SKILL.md` |
| 中文 | `AGENTS.zh-CN.md` | `docs/java-backend-standard.zh-CN.md` | `skills/java-backend-standard/SKILL.zh-CN.md` |

英文为默认版的原因：`AGENTS.md` 是 AI IDE 自动读取的文件名，英文表述在多数模型上指令遵循更稳定、分词更省 token。中文版为其忠实译本，内容逐条对应。

同步脚本支持语言切换：`bash script/sync-agent-rules.sh --lang zh`。技能包内**同时**保留两版手册副本。

### 相比《阿里巴巴 Java 开发手册（嵩山版）》的增强

- **JDK 17–21 语言特性**：可用性双列对照表（17 / 21）；`var`、`record`、文本块、`switch` 表达式、`instanceof` 模式匹配、`sealed`、不可变集合工厂、Stream 与 Optional、编译与 JVM 参数。
- **Spring Boot 3 后端工程规范**：分层与包结构、Controller / Service / 数据访问、统一返回与异常、参数校验、事务、缓存与分布式锁、鉴权与当前用户、公共字段与软删除、依赖注入、配置与可观测性。
- **单元测试**：升级到 JUnit 5 + Mockito + Testcontainers 实践。
- **Spring Boot 2.7 → 3.x 迁移指南**：`javax.*` → `jakarta.*` 对照、依赖坐标替换表、配置与行为变更、虚拟线程实践、9 步迁移清单。
- **附录**：错误码设计、迁移对照表（JDK 8→17、JDK 17→21 与 SB 2.7→3）、速查表与十句口诀。

### 核心决策

1. **时间类型策略**：新代码一律用 `LocalDateTime` 替代 `Date`，禁止新增 `Date` 字段 / 参数 / 返回值。
2. **预览特性红线**：任何环境的生产代码禁用 `--enable-preview`；JDK 21 上仍禁字符串模板、结构化并发、作用域值与未命名变量。
3. **版本可用性前置判断**：使用语言特性前必须先确认目标 JDK 版本，不确定时按 JDK 17 安全子集编写。
4. **不绑定具体项目**：所有条目均为通用约定，项目私有约定（统一返回体类名、鉴权组件、断言工具等）以占位与示例形式给出，落地时替换为项目实际实现。
