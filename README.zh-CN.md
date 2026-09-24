# Java 后端开发规范（通用版）

面向 **Java 17 / 21 + Spring Boot 3.x** 后端服务的通用编码规范与最佳实践。基于阿里巴巴《Java 开发手册》嵩山版核心规约，补充 JDK 17–21 语言特性与 Spring Boot 3 工程实践，**不绑定任何具体业务项目**，可直接用于新项目、代码评审与 AI 助手规则。

> English edition: [README.md](README.md)

## 语言版本

| 语言 | 规则入口 | 完整手册 | 技能 |
|---|---|---|---|
| **英文（默认）** | `AGENTS.md` | `docs/java-backend-standard.md` | `skills/java-backend-standard/SKILL.md` |
| 中文 | `AGENTS.zh-CN.md` | `docs/java-backend-standard.zh-CN.md` | `skills/java-backend-standard/SKILL.zh-CN.md` |

不带语言后缀的文件一律为英文。`AGENTS.md` 是 AI IDE 自动读取的那个文件名，因此默认放英文版——英文表述在多数模型上指令遵循更稳定。

## 内容

完整规范见 [`docs/java-backend-standard.md`](docs/java-backend-standard.md)（约 820 行）。

| 章节 | 内容 |
|---|---|
| 一 编程规约 | 命名、常量、格式、OOP、日期时间、集合、并发、控制语句、注释、接口、其他 |
| 二 JDK 17–21 语言特性 | 可用性双列对照、`var`、`record`、文本块、`switch` 表达式、模式匹配、`sealed`、不可变集合、Stream/Optional、编译参数 |
| 三 Spring Boot 3 工程规范 | 分层、Controller/Service/数据访问、统一返回与异常、参数校验、事务、缓存与分布式锁、鉴权、软删除、依赖注入、配置与可观测性 |
| 四 异常日志 | 错误码、异常处理、日志规约 |
| 五 单元测试 | JUnit 5 + Mockito 实践 |
| 六 安全规约 | 越权、脱敏、注入、反序列化、密钥管理 |
| 七 MySQL | 建表、索引、SQL 语句 |
| 八 工程结构与依赖 | 分层、Maven 依赖管理、服务器与 JVM |
| 九 设计规约 | 建模、设计原则、ADR |
| 十 Spring Boot 2.7 → 3.x 迁移 | `javax`→`jakarta`、依赖坐标、配置变更、虚拟线程、迁移清单 |
| 附录 A/B/C/D | 错误码、迁移对照表、速查表、变更说明 |

## 快速使用

### 1. 作为 AI 助手规则（推荐）

根目录 `AGENTS.md` 是精简版规则入口（红线 + 惯例 + 口诀），**Cursor / OpenCode / Codex / Copilot 等会原生读取**。要分发到更多 IDE（Trae / Cursor / JetBrains / Claude Code 等）：

```bash
bash script/sync-agent-rules.sh            # 只写入本仓库内落点（英文规则）
bash script/sync-agent-rules.sh --global   # 额外写入用户级全局落点
bash script/sync-agent-rules.sh --lang zh  # 改为分发中文规则
```

### 2. 作为技能安装

把 `skills/java-backend-standard/` 复制到对应目录即可：

```bash
# Claude Code
cp -r skills/java-backend-standard ~/.claude/skills/
# WorkBuddy
cp -r skills/java-backend-standard ~/.workbuddy/skills/
```

### 3. 直接阅读

打开 [`docs/java-backend-standard.zh-CN.md`](docs/java-backend-standard.zh-CN.md)，或看 [附录 C 速查表](docs/java-backend-standard.zh-CN.md#附录-c速查表cheat-sheet) 的十句口诀。

## 同步到多个代码平台

本仓库可同时托管在 GitHub / Gitee / GitCode。首次推送：

```bash
# 在三个平台分别创建空仓库后，执行：
bash script/push-all.sh \
  https://github.com/<用户名>/java-backend-standard.git \
  https://gitee.com/<用户名>/java-backend-standard.git \
  https://gitcode.com/<用户名>/java-backend-standard.git
```

脚本会依次添加 `github` / `gitee` / `gitcode` 三个远端并推送。后续更新只需 `git push github main` 等按需推送。

## 十条红线

1. 生产**永远禁用** `--enable-preview`。
2. JDK 17 上禁用虚拟线程 / `switch` 模式匹配 / `record` 解构 / 顺序集合。
3. 编译用 `<release>` 而非 `source/target`；Spring Boot 3 必须加 `-parameters`。
4. `record` 只做值对象，不能做 ORM 实体。
5. `var` 仅限局部变量且类型可一眼看出。
6. `List.of/Map.of` 不可变且不允许 null。
7. 禁止依赖 `sun.*` 内部 API（JEP 403 强封装）。
8. 时间类型新代码一律 `LocalDateTime`，禁止新增 `Date`。
9. SQL 参数用 `#{}`，禁止 `${}`；查询显式列 + 带软删除条件。
10. 事务 `rollbackFor = Exception.class`，事务内不调 RPC。

## 目录结构

```
.
├── README.md / README.zh-CN.md          仓库说明（英 / 中）
├── AGENTS.md / AGENTS.zh-CN.md          跨 IDE 精简规则入口（英 / 中）
├── LICENSE                              MIT
├── CHANGELOG.md                         版本记录
├── docs/
│   ├── java-backend-standard.md          完整规范正文（英）
│   └── java-backend-standard.zh-CN.md    完整规范正文（中）
├── script/
│   ├── sync-agent-rules.sh              分发规则到各 IDE 落点（支持 --lang）
│   └── push-all.sh                      推送到多平台远端
└── skills/
    └── java-backend-standard/
        ├── SKILL.md                      可直接安装为 AI 技能（英）
        ├── SKILL.zh-CN.md                可直接安装为 AI 技能（中）
        └── references/                   手册副本，由同步脚本生成
```

## 约定

- 规范正文**唯一来源**是 `AGENTS.md`（精简）+ `docs/java-backend-standard.md`（完整）；中文版为其同步译本。
- 各 IDE 落点文件由脚本生成，**不要直接编辑**（下次同步会被覆盖）。
- 修改规范：改 `AGENTS.md`（必要时同步改 `AGENTS.zh-CN.md`）→ 跑同步脚本 → 提交。

## License

[MIT](LICENSE)
