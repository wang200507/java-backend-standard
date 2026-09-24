<div align="center">

# Java 后端开发规范（通用版）

**面向 Java 17 / 21 + Spring Boot 3.x 的编码规范与最佳实践**

[![JDK](https://img.shields.io/badge/JDK-17%20%7C%2021-orange)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F)](https://spring.io/projects/spring-boot)
[![License](https://img.shields.io/badge/LICENSE-MIT-blue)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-830%20%E8%A1%8C-informational)](docs/java-backend-standard.zh-CN.md)
[![PRs](https://img.shields.io/badge/PRs-welcome-ff69b4)](#-参与贡献欢迎-pr)
[![Offline](https://img.shields.io/badge/%E8%A7%84%E8%8C%83-%E4%B8%8D%E4%BE%9D%E8%B5%96%E5%85%B7%E4%BD%93%E9%A1%B9%E7%9B%AE-9cf)](#-这是什么)

[![GitHub](https://img.shields.io/badge/GitHub-wang200507-181717?logo=github)](https://github.com/wang200507/java-backend-standard)
[![Gitee](https://img.shields.io/badge/Gitee-wangzy01-c71d23?logo=gitee)](https://gitee.com/wangzy01/java-backend-standard)
[![GitCode](https://img.shields.io/badge/GitCode-wangzhy01-2f6fed)](https://gitcode.com/wangzhy01/java-backend-standard)

[English](README.en.md) · [完整手册](docs/java-backend-standard.zh-CN.md) · [速查表](docs/java-backend-standard.zh-CN.md#附录-c速查表cheat-sheet)

</div>

🧾 编程规约 · ⚡ JDK 17–21 语言特性 · 🧱 Spring Boot 3 工程规范 · 🩺 异常日志 · 🧪 单元测试 · 🔐 安全 · 🗄 MySQL · 📦 工程结构与依赖 · 🧠 设计规约 · 🚚 SB 2.7 → 3.x 迁移

---

## 🧩 这是什么

一份**不绑定任何具体业务项目**的 Java 后端开发规范。以阿里巴巴《Java 开发手册》（嵩山版）核心规约为底座，补上 JDK 17–21 的语言/API 实践与 Spring Boot 3 工程约定，可直接用于新项目立项、代码评审和 AI 助手规则。

- 🎯 **一句话**：打开 `AGENTS.md` 当红线，翻 `docs/` 当手册，跑一个脚本让 Trae / Cursor / JetBrains / Claude Code 全部守同一套规矩。

- 🧱 **不依赖具体项目**：项目名、包名、自研工具类全部剥离，只留可迁移的通用条款；行业业务词汇零残留。

- ⚡ **JDK 17 与 21 双列对照**：每条特性都标了「17 能不能用、21 怎么用」，避开「写了 21 的代码在 17 上编译失败」这类事故；预览特性单独列为禁区。

- 🚚 **升级路径成对给出**：`javax.*` → `jakarta.*` 对照、依赖坐标替换、配置项变更、虚拟线程启用条件，配 9 步迁移清单。

- 🤖 **为 AI IDE 而生**：`AGENTS.md` 是 Cursor / OpenCode / Codex / Copilot 原生读取的文件名，英文表述让模型指令遵循更稳；一条命令即可物化到各 IDE 的规则目录。

- 🧾 **可评审、可执行**：规约分【强制】/【推荐】/【参考】，配错误码表、迁移对照表和十句口诀，评审时能直接引用条款。

## 📚 内容速览

完整规范见 [`docs/java-backend-standard.md`](docs/java-backend-standard.md)（英文，约 830 行）／[`docs/java-backend-standard.zh-CN.md`](docs/java-backend-standard.zh-CN.md)（中文）。

| 章节 | 内容 |
|---|---|
| 一 编程规约 | 命名、常量、格式、OOP、日期时间、集合、并发、控制语句、注释、接口契约、其他 |
| 二 JDK 17–21 语言特性 | 可用性双列对照、`var`、`record`、文本块、`switch` 表达式、模式匹配、`sealed`、不可变集合、Stream / Optional、编译参数 |
| 三 Spring Boot 3 工程规范 | 分层、Controller / Service / 数据访问、统一返回与异常、参数校验、事务、缓存与分布式锁、鉴权、软删除、依赖注入、配置与可观测性 |
| 四 异常日志 | 错误码、异常处理、日志规约 |
| 五 单元测试 | JUnit 5 + Mockito 实践、Testcontainers |
| 六 安全规约 | 越权、脱敏、注入、反序列化、密钥管理 |
| 七 MySQL | 建表、索引、SQL 语句 |
| 八 工程结构与依赖 | 分层、Maven 依赖管理、服务器与 JVM |
| 九 设计规约 | 建模、设计原则、ADR |
| 十 Spring Boot 2.7 → 3.x 迁移 | `javax`→`jakarta`、依赖坐标、配置变更、虚拟线程、迁移清单 |
| 附录 A / B / C / D | 错误码、迁移对照表、速查表、变更说明 |

## 🚀 快速使用

**1. 作为 AI 助手规则（推荐）**

根目录 `AGENTS.md` 是精简版规则入口（红线 + 惯例 + 口诀），Cursor / OpenCode / Codex / Copilot 会**原生读取**。要分发到更多 IDE（Trae / Cursor / JetBrains / Claude Code 等）：

```bash
bash script/sync-agent-rules.sh            # 只写入本仓库内落点（英文规则）
bash script/sync-agent-rules.sh --global   # 额外写入用户级全局落点
bash script/sync-agent-rules.sh --lang zh  # 改为分发中文规则
```

**2. 作为技能安装**

```bash
# Claude Code
cp -r skills/java-backend-standard ~/.claude/skills/
# WorkBuddy
cp -r skills/java-backend-standard ~/.workbuddy/skills/
```

**3. 直接阅读**

```bash
# 中文版十句口诀
docs/java-backend-standard.zh-CN.md  →  附录 C 速查表
```

## 🌏 多平台与语言版本

| 平台 | 地址 | 默认展示 |
|---|---|---|
| GitHub | [wang200507/java-backend-standard](https://github.com/wang200507/java-backend-standard) | 中文（附英文入口） |
| Gitee | [wangzy01/java-backend-standard](https://gitee.com/wangzy01/java-backend-standard) | 中文（英文浏览器自动切英文） |
| GitCode | [wangzhy01/java-backend-standard](https://gitcode.com/wangzhy01/java-backend-standard) | 中文 |

| 用途 | 中文 | English |
|---|---|---|
| 仓库说明 | `README.md`（本文件） | `README.en.md` |
| 规则入口（AI IDE 读） | `AGENTS.zh-CN.md` | **`AGENTS.md`（默认）** |
| 完整手册 | `docs/java-backend-standard.zh-CN.md` | `docs/java-backend-standard.md` |
| 技能 | `SKILL.zh-CN.md` | `SKILL.md`（默认） |
| 贡献指南 | `CONTRIBUTING.md` | `CONTRIBUTING.en.md` |

> 命名约定分两类：**面向人的文档**（README / CONTRIBUTING）无后缀为**中文**，因为代码托管平台首页对国内读者默认中文；**面向 AI IDE 的文件**（`AGENTS.md` / `docs/*.md` / `SKILL.md`）无后缀为**英文**，英文表述在多数模型上指令遵循更稳定。

## 🧷 十条红线

1. 生产**永远禁用** `--enable-preview`。
2. JDK 17 上禁用虚拟线程 / `switch` 模式匹配 / `record` 解构 / 顺序集合。
3. 编译用 `<release>` 而非 `source`/`target`；Spring Boot 3 必须加 `-parameters`。
4. `record` 只做值对象，不能做 ORM 实体。
5. `var` 仅限局部变量且类型可一眼看出。
6. `List.of` / `Map.of` 不可变且不允许 null。
7. 禁止依赖 `sun.*` 内部 API（JEP 403 强封装）。
8. 时间类型新代码一律 `LocalDateTime`，禁止新增 `Date`。
9. SQL 参数用 `#{}`，禁止 `${}`；查询显式列 + 带软删除条件。
10. 事务 `rollbackFor = Exception.class`，事务内不调 RPC。

## 🤝 参与贡献（欢迎 PR）

**Issue、PR、讨论都欢迎**，哪怕只是「这条规约表述不清」「这个示例在 JDK 21 上跑不通」这种小反馈，也很有价值。

你可以在这些方向发力：

- 🐛 **纠错**：条款与 JDK / Spring Boot 官方行为不一致、示例代码有误
- ✨ **补充**：新特性（JDK 21+）、新组件（GraalVM / Spring Modulith / jOOQ …）的实践条款
- 🌏 **翻译**：英文版措辞优化，或新增其他语言版本
- 🧪 **示例**：把抽象条款换成能跑的最小可运行示例
- 🧩 **工具**：改进 `script/` 下的分发与推送脚本

提 PR 的流程：

```bash
# 1. Fork 本仓库，克隆到本地
git clone https://github.com/<你的用户名>/java-backend-standard.git
cd java-backend-standard

# 2. 开一个语义化分支
git checkout -b feat/jdk21-sequenced-collection

# 3. 改完必须跑一次同步（落点文件由脚本生成，别手改）
bash script/sync-agent-rules.sh

# 4. 提交并推送，然后在平台上发起 Pull Request
git commit -m "docs: 补充 JDK 21 顺序集合条款"
git push origin feat/jdk21-sequenced-collection
```

提交前请自查：

- [ ] 规范正文只改 `AGENTS.md` 与 `docs/`，**没有直接编辑各 IDE 落点文件**（会被同步脚本覆盖）
- [ ] 中英两版保持**逐条对应**，改了中文就同步英文
- [ ] 新增条款标明规约等级（【强制】/【推荐】/【参考】）与适用 JDK 版本
- [ ] 条款含可运行示例或明确的反例

详见 [CONTRIBUTING.md](CONTRIBUTING.md)（[English](CONTRIBUTING.en.md)）。PR 请使用仓库自带的模板。

## 📁 目录结构

```
.
├── README.md / README.en.md                   仓库说明（中 / 英）
├── CONTRIBUTING.md / CONTRIBUTING.en.md       贡献指南（中 / 英）
├── AGENTS.md / AGENTS.zh-CN.md                跨 IDE 精简规则入口（英 / 中，英文默认）
├── PULL_REQUEST_TEMPLATE.md                   PR 模板
├── LICENSE                                    MIT
├── CHANGELOG.md                               版本记录
├── docs/
│   ├── java-backend-standard.md               完整规范正文（英）
│   └── java-backend-standard.zh-CN.md         完整规范正文（中）
├── script/
│   ├── sync-agent-rules.sh                    分发规则到各 IDE 落点（支持 --lang）
│   └── push-all.sh                            推送到多平台远端
├── .github/                                    Issue / PR 模板、Copilot 指令
└── skills/
    └── java-backend-standard/
        ├── SKILL.md                           可直接安装为 AI 技能（英）
        ├── SKILL.zh-CN.md                     可直接安装为 AI 技能（中）
        └── references/                        手册副本，由同步脚本生成
```

## 🧭 约定

- 规范正文**唯一来源**是 `AGENTS.md`（精简）+ `docs/java-backend-standard.md`（完整）；中文版为其同步译本。
- 各 IDE 落点文件由脚本生成，**不要直接编辑**（下次同步会被覆盖）。
- 修改规范：改 `AGENTS.md`（必要时同步改 `AGENTS.zh-CN.md`）→ 跑同步脚本 → 提交。
- 推送多平台：`bash script/push-all.sh --all`，或单独 `git push github main` / `git push gitee main` / `git push gitcode main`。

## 📄 License

[MIT](LICENSE) —— 可自由用于个人与商业项目。
