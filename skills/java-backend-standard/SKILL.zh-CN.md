---
name: java-backend-standard
description: 通用 Java 后端开发规范与最佳实践（JDK 17/21 + Spring Boot 3.x + MyBatis-Plus）。当需要编写、评审、重构、生成 Java 后端代码，或判断命名/分层/异常/事务/日志/集合/并发/SQL 写法是否合规，或涉及 JDK 17→21、Spring Boot 2.7→3.x 迁移（javax→jakarta、虚拟线程、switch 模式匹配）时使用。Trigger: Java 代码规范、代码评审、命名规约、JDK 17 新特性、JDK 21 虚拟线程、record、var、文本块、模式匹配、Spring Boot 3 迁移、MyBatis-Plus、统一返回体、全局异常处理、事务 rollbackFor。
agent_created: true
---

# 通用 Java 后端开发规范

## 用途

为 **Java 17 / 21 + Spring Boot 3.x** 后端项目提供编码规范与最佳实践判据。不绑定具体业务项目，可直接用于新项目、代码评审、代码生成。

## 技术基线

| 项 | 当前主流 | 说明 |
|---|---|---|
| JDK | **21**（推荐）/ 17 | Spring Boot 3 最低 17 |
| 框架 | **Spring Boot 3.x** | `jakarta.*` 命名空间 |
| ORM | MyBatis-Plus 3.5.4+ | `mybatis-plus-spring-boot3-starter` |
| 构建 | Maven 多模块 | `<release>` + `-parameters` |

> 仍在 Spring Boot 2.7 / `javax.*` 的项目：语言风格规范（一、二章）通用，依赖坐标与命名空间按迁移章节处理。

## 强制红线（10 条）

1. 生产**永远禁用** `--enable-preview`。
2. **JDK 17 禁用**：虚拟线程、`switch` 模式匹配、`record` 解构、顺序集合。**JDK 21 仍禁**：字符串模板、结构化并发、作用域值、未命名变量（预览）。
3. 编译用 `<release>`；**Spring Boot 3 必须加 `-parameters`**。
4. `record` 只做值对象，**不能做 ORM 实体**，不加 `@Data`。
5. `var` 仅限局部变量且类型可一眼看出。
6. `List.of/Map.of` 不可变且不允许 null。
7. 禁止 `sun.*` / `com.sun.*` 内部 API（JEP 403）。
8. 时间类型**新代码一律 `LocalDateTime`**，禁止新增 `Date`。
9. SQL 用 `#{}` 禁 `${}`；查询显式列 + 带软删除条件。
10. 事务 `rollbackFor = Exception.class`，事务内禁 RPC。

## 编码惯例（速记）

- 命名：类大驼峰 / 方法变量小驼峰 / 常量全大写；分层命名 `Xxx`·`XxxDto`·`XxxReq`·`XxxResp`·`XxxVo`，全项目统一不混用。
- 格式：4 空格、禁 Tab、单行 ≤ 120、UTF-8、LF。
- 返回：统一响应体（`R<T>`/`Result<T>`）或分页体（`PageResult<T>`）；禁裸泛型、禁拼 `Map`。
- 异常：自定义业务异常 + 全局异常处理器；Controller 不写 try-catch。
- 事务：`@Transactional(rollbackFor = Exception.class)`，只包必要 DB 操作，同类内部调用不生效。
- 日志：`@Slf4j` + 占位符；禁 `System.out.println` / `e.printStackTrace()`。
- 集合：`isEmpty()` 判空；foreach 内禁增删；`toMap` 必传合并函数。
- 并发：`ThreadPoolExecutor` 显式构造；`ThreadLocal` 必 `remove()`；锁内禁 RPC。
- 注入：优先构造器注入，同类不混用两种风格。
- SB3 包名：`jakarta.annotation.*` / `jakarta.servlet.*` / `jakarta.validation.*`；API 文档 `io.swagger.v3.oas.annotations`。
- JDK 17+ 惯用：`switch` 表达式、`instanceof` 模式匹配、文本块、`stream().toList()`、`Optional` 仅作返回值。

## 十句口诀

1. 参数校验用断言，异常统一业务异常类。
2. 返回统一响应体，不裸泛型、不拼 `Map`。
3. 事务 `rollbackFor` 必写，事务内不调 RPC。
4. 查询显式列 + 软删除条件，`#{}` 不用 `${}`。
5. 时间一律 `LocalDateTime`（禁新增 `Date`），pattern 小写 `yyyy`。
6. `record` 做值对象，`var` 只在局部，`switch` 用箭头。
7. 集合判空用 `isEmpty()`，`List.of` 记得不可变。
8. 日志用占位符，`@Slf4j` 不 `println`。
9. 鉴权注解必写，当前用户走统一入口。
10. 生产禁 preview；JDK 21 用 `release=21` + `-parameters`，SB3 用 `jakarta.*`。

## 检索完整手册

`references/java-backend-standard.md` 章节结构：

- 一 编程规约（命名 / 常量 / 格式 / OOP / 日期时间 / 集合 / 并发 / 控制语句 / 注释 / 接口 / 其他）
- 二 JDK 17–21 语言特性与最佳实践（可用性对照 / var / record / 文本块 / switch 表达式 / 模式匹配 / sealed / 不可变集合 / Stream & Optional / 编译参数）
- 三 Spring Boot 3 后端工程规范（分层 / Controller / Service / 数据访问 / 统一返回与异常 / 校验 / 事务 / 缓存与锁 / 鉴权 / 软删除 / DI / 配置与可观测性）
- 四 异常日志 ｜ 五 单元测试（JUnit 5）｜ 六 安全规约 ｜ 七 MySQL ｜ 八 工程结构与依赖管理 ｜ 九 设计规约
- 十 Spring Boot 2.7 → 3.x 迁移指南（javax→jakarta / 依赖坐标 / 配置行为变更 / 虚拟线程 / 清单）
- 附录 A 错误码 ｜ B 迁移对照表 ｜ C 速查表 ｜ D 变更说明

## 判定流程

1. 先确认代码目标版本（JDK 17 还是 21？SB 2.7 还是 3？），再判断特性可用性。
2. 拿不准的写法，查完整手册对应章节。
3. 手册未覆盖时：**与项目现有风格一致** 优先于个人偏好，不在同一模块引入第二套风格。
4. 涉及选型、分层调整、依赖替换 → 提示记录 ADR。

## 来源

本技能封装自本仓库的规范文档，完整正文见同目录下 `references/java-backend-standard.md`（由 `script/sync-agent-rules.sh` 从 `docs/` 同步，勿直接编辑）。
