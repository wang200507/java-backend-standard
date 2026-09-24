---
description: General Java backend development standard (JDK 17/21 + Spring Boot 3.x + MyBatis-Plus). Follow when writing, reviewing, refactoring or generating Java backend code; includes JDK 17-21 and Spring Boot 2.7-3.x migration guidance.
alwaysApply: true
---

# Java Backend Development Standard — AI Rules Entry

> This file holds the **condensed rules** read by AI coding assistants (Cursor / OpenCode / Codex / Copilot / Trae / Claude Code).
> **Full standard**: `docs/java-backend-standard.md` (tech baseline, migration guide, lookup tables).
> Tech baseline: **Java 17 / Java 21 · Spring Boot 3.x** (backward compatible with 2.7).
> 中文版见 `AGENTS.zh-CN.md`.

## 1. Hard Rules (violating any of these causes production risk)

1. **Never use `--enable-preview` in production.** Preview features change or disappear between releases.
2. **Not available on JDK 17**: virtual threads, `switch` pattern matching, record deconstruction, sequenced-collection `getFirst/getLast` (all JDK 21).
   **Still unavailable on JDK 21**: string templates, structured concurrency, scoped values, unnamed variables (all preview).
3. Compile with **`<release>`** instead of `source`/`target`; **Spring Boot 3 requires `-parameters`**.
4. **`record` is for value objects only** — never an ORM entity (no no-arg constructor, no setters); never annotate with Lombok `@Data`.
5. **`var` is limited to local variables** whose type is obvious from the right-hand side. Never for fields, parameters, return types, or `null` initialization.
6. **`List.of/Set.of/Map.of` are immutable and reject null.** For a mutable list use `new ArrayList<>(List.of(...))`.
7. **Never depend on `sun.*` / `com.sun.*` internal APIs** (JDK 17 JEP 403 strong encapsulation).
8. **Date/time: all new code uses `LocalDateTime`.** Never add new `Date` fields, parameters, or return values. Date-only → `LocalDate`; timestamp → `Instant`.
9. SQL parameters must use `#{}`, **never `${}`**. Queries must **list columns explicitly** and **always include the soft-delete condition** (`del_flag`).
10. Transactions: **`@Transactional(rollbackFor = Exception.class)`**. **Never make RPC / remote calls or large file I/O inside a transaction.**
11. Logging uses placeholders — `log.info("id={}", id)`. **Never `System.out.println` or `e.printStackTrace()`.**
12. `BigDecimal` equality uses **`compareTo()`**, never `equals()`. Never use `float`/`double` for money.

## 2. Coding Conventions

- **Naming**: classes `UpperCamelCase`; methods/variables `lowerCamelCase`; constants `UPPER_SNAKE_CASE`. Layer suffixes must be consistent across the project (`Xxx` / `XxxDto` / `XxxReq` / `XxxResp` / `XxxVo`) — **never mix two naming schemes**.
- **Formatting**: 4-space indent, no tabs, max 120 chars per line, UTF-8, **LF line endings**.
- **Responses**: controllers return a unified response wrapper (`R<T>` / `Result<T>`) or a paged wrapper (`PageResult<T>`). **Never omit the generic type; never hand-build a `Map` as the response body.**
- **Exceptions**: throw a custom business exception (e.g. `ServiceException`); never `throw new RuntimeException()`. **Controllers must not contain try-catch** — the global exception handler owns that.
- **Validation**: JSR-303 (`jakarta.validation.*`) with validation groups; use the shared assertion utility for simple preconditions.
- **Data access**: use `LambdaQueryWrapper`; every update must set `update_time` and touch only changed columns.
- **Dependency injection**: prefer constructor injection; **never mix** constructor and field injection in the same class.
- **Annotation packages (SB3)**: `jakarta.annotation.*` / `jakarta.servlet.*` / `jakarta.validation.*`; API docs use `io.swagger.v3.oas.annotations` (`@Tag` / `@Operation` / `@Schema`).
- **Idiomatic JDK 17+**: `switch` expressions (`->` / `yield`) for multi-branch logic; `instanceof` pattern matching; text blocks for multi-line SQL/JSON; `stream().toList()`; `Optional` only as a return type.
- **Concurrency**: build thread pools with `ThreadPoolExecutor` explicitly (never `Executors` convenience factories); always `remove()` `ThreadLocal`; never call RPC while holding a lock; `Lock.lock()` outside `try`, `unlock()` inside `finally`.
- **Comments**: class Javadoc must contain `@author` / `@since`; every enum constant needs a business-meaning comment; delete dead code instead of commenting it out.

## 3. Ten-Line Cheat Sheet

1. Validate with assertions; throw the unified business exception.
2. Return the unified response wrapper — no raw generics, no `Map`.
3. Always set `rollbackFor`; never call RPC inside a transaction.
4. Select explicit columns + soft-delete condition; use `#{}`, not `${}`.
5. Always `LocalDateTime` (never a new `Date`); lowercase `yyyy` in patterns.
6. `record` for value objects, `var` only locally, arrow `switch`.
7. Check emptiness with `isEmpty()`; remember `List.of` is immutable.
8. Log with placeholders; `@Slf4j`, never `println`.
9. Always declare authorization annotations; resolve the current user through the shared helper.
10. No preview features in production; JDK 21 uses `release=21` + `-parameters`; Spring Boot 3 uses `jakarta.*`.

## 4. When Unsure

1. Look up the matching chapter of `docs/java-backend-standard.md` (1 Coding Conventions / 2 JDK Features / 3 Engineering / 10 SB 2.7→3 Migration).
2. If the standard does not cover it, **match the existing code** rather than a personal preference — do not introduce a second style into a module.
3. Before using a language feature, **confirm the project's JDK version**. If unknown, write against the JDK 17 safe subset.
4. For architectural decisions (technology choice, layering changes, dependency swaps), prompt the user to record an ADR instead of changing things silently.
