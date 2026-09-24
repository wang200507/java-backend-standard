---
name: java-backend-standard
description: General Java backend development standard and best practices (JDK 17/21 + Spring Boot 3.x + MyBatis-Plus). Use when writing, reviewing, refactoring or generating Java backend code, when checking whether naming/layering/exception/transaction/logging/collection/concurrency/SQL code complies with the standard, or when dealing with JDK 17→21 and Spring Boot 2.7→3.x migration (javax→jakarta, virtual threads, switch pattern matching). Trigger: Java 代码规范, 代码评审, 命名规约, JDK 17 新特性, JDK 21 虚拟线程, record, var, 文本块, 模式匹配, Spring Boot 3 迁移, MyBatis-Plus, 统一返回体, 全局异常处理, 事务 rollbackFor, Java coding standard, code review, Java conventions.
agent_created: true
---

# General Java Backend Development Standard

## Purpose

Provides the coding standard and best-practice criteria for **Java 17 / 21 + Spring Boot 3.x** backend projects. Not tied to any specific business project — usable directly for new projects, code reviews, and code generation.

## Tech Baseline

| Item | Current mainstream | Notes |
|---|---|---|
| JDK | **21** (recommended) / 17 | Spring Boot 3 requires a minimum of 17 |
| Framework | **Spring Boot 3.x** | `jakarta.*` namespace |
| ORM | MyBatis-Plus 3.5.4+ | `mybatis-plus-spring-boot3-starter` |
| Build | Maven multi-module | `<release>` + `-parameters` |

> Projects still on Spring Boot 2.7 / `javax.*`: the language-level conventions (chapters 1 and 2) still apply; handle dependency coordinates and namespaces per the migration chapter.

## Hard Rules (12)

1. **Never use `--enable-preview` in production.**
2. **Forbidden on JDK 17**: virtual threads, `switch` pattern matching, record deconstruction, sequenced collections. **Still forbidden on JDK 21**: string templates, structured concurrency, scoped values, unnamed variables (preview).
3. Compile with `<release>`; **Spring Boot 3 requires `-parameters`**.
4. `record` is for value objects only — **never an ORM entity**, never annotate with `@Data`.
5. `var` only for local variables with an obvious type.
6. `List.of/Map.of` are immutable and reject null.
7. Never depend on `sun.*` / `com.sun.*` internal APIs (JEP 403).
8. **All new date/time code uses `LocalDateTime`**; never add a new `Date`.
9. SQL uses `#{}`, never `${}`; queries list explicit columns and include the soft-delete condition.
10. Transactions use `rollbackFor = Exception.class`; never call RPC inside a transaction.
11. Logging uses placeholders (`@Slf4j`); never `System.out.println` or `e.printStackTrace()`.
12. `BigDecimal` equality uses `compareTo()`, never `equals()`; never `float`/`double` for money.

## Coding Conventions (quick reference)

- **Naming**: classes `UpperCamelCase` / methods and variables `lowerCamelCase` / constants `UPPER_SNAKE_CASE`; layer suffixes `Xxx`·`XxxDto`·`XxxReq`·`XxxResp`·`XxxVo`, consistent project-wide, never mixed.
- **Formatting**: 4-space indent, no tabs, max 120 chars, UTF-8, LF.
- **Responses**: unified response wrapper (`R<T>`/`Result<T>`) or paged wrapper (`PageResult<T>`); no raw generics, never hand-build a `Map`.
- **Exceptions**: custom business exception plus a global exception handler; no try-catch in controllers.
- **Transactions**: `@Transactional(rollbackFor = Exception.class)`, wrap only necessary DB work, self-invocation bypasses the proxy.
- **Logging**: `@Slf4j` with placeholders; never `System.out.println` / `e.printStackTrace()`.
- **Collections**: test emptiness with `isEmpty()`; never mutate inside foreach; `toMap` always needs a merge function.
- **Concurrency**: build `ThreadPoolExecutor` explicitly; always `remove()` `ThreadLocal`; never call RPC while holding a lock.
- **Injection**: prefer constructor injection; never mix both styles in one class.
- **SB3 packages**: `jakarta.annotation.*` / `jakarta.servlet.*` / `jakarta.validation.*`; API docs use `io.swagger.v3.oas.annotations`.
- **Idiomatic JDK 17+**: `switch` expressions, `instanceof` pattern matching, text blocks, `stream().toList()`, `Optional` only as a return type.

## Ten-Line Cheat Sheet

1. Validate with assertions; throw the unified business exception.
2. Return the unified response wrapper — no raw generics, no `Map`.
3. Always set `rollbackFor`; never call RPC inside a transaction.
4. Select explicit columns + soft-delete condition; `#{}`, not `${}`.
5. Always `LocalDateTime` (never a new `Date`); lowercase `yyyy` in patterns.
6. `record` for value objects, `var` only locally, arrow `switch`.
7. Check emptiness with `isEmpty()`; remember `List.of` is immutable.
8. Log with placeholders; `@Slf4j`, never `println`.
9. Always declare authorization annotations; resolve the current user through the shared helper.
10. No preview features in production; JDK 21 uses `release=21` + `-parameters`; SB3 uses `jakarta.*`.

## Retrieving the Full Manual

`references/java-backend-standard.md` chapter structure:

- 1 Coding Conventions (naming / constants / formatting / OOP / date-time / collections / concurrency / control flow / comments / API contract / misc)
- 2 JDK 17–21 Language Features and Best Practices (availability matrix / var / record / text blocks / switch expressions / pattern matching / sealed / immutable collections / Streams & Optional / compiler flags)
- 3 Spring Boot 3 Backend Engineering Standard (layering / controller / service / data access / unified response and exceptions / validation / transactions / caching and locks / authorization / soft delete / DI / configuration and observability)
- 4 Exceptions and Logging ｜ 5 Unit Testing (JUnit 5) ｜ 6 Security ｜ 7 MySQL ｜ 8 Project Structure and Dependency Management ｜ 9 Design Principles
- 10 Spring Boot 2.7 → 3.x Migration Guide (javax→jakarta / dependency coordinates / configuration changes / virtual threads / checklist)
- Appendix A error codes ｜ B migration tables ｜ C cheat sheet ｜ D change log

A Chinese edition of the manual is available at `references/java-backend-standard.zh-CN.md`.

## Decision Procedure

1. First establish the target version (JDK 17 or 21? SB 2.7 or 3?) before judging feature availability.
2. For an uncertain construct, look it up in the full manual chapter listed above.
3. If the manual does not cover it: **match the existing project style** rather than a personal preference, and never introduce a second style into a module.
4. For technology choices, layering changes or dependency swaps, prompt for an ADR instead of changing things silently.

## Source

This skill packages the standard from this repository. The full text is `references/java-backend-standard.md`, synced from `docs/` by `script/sync-agent-rules.sh` — do not edit the copy directly.
