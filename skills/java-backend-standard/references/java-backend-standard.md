# Java Backend Development Standard

> **Baseline**: Java 17 / Java 21 · Spring Boot 3.x (backward compatible with 2.7) · MyBatis-Plus · Maven multi-module
> **Scope**: any Java backend service on the Spring Boot stack — not tied to a specific business project
> **Rule levels**: [MUST] mandatory, violations carry production risk ｜ [SHOULD] best practice ｜ [MAY] reference only
> **Source**: core rules of Alibaba *Java Development Manual* (Songshan edition) + JDK 17/21 language and API enhancements + Spring Boot 3 migration and engineering practice
> **Applicability**: entries tagged [JDK21] require JDK 21+; entries tagged [SB3] require Spring Boot 3.x. Using them on lower versions either fails to compile or changes behavior — **do not use them early**.
> 中文版见 `java-backend-standard.zh-CN.md`.

## Table of Contents

- [1. Coding Conventions](#1-coding-conventions)
- [2. JDK 17–21 Language Features and Best Practices](#2-jdk-1721-language-features-and-best-practices)
- [3. Spring Boot 3 Backend Engineering Standard](#3-spring-boot-3-backend-engineering-standard)
- [4. Exceptions and Logging](#4-exceptions-and-logging)
- [5. Unit Testing](#5-unit-testing)
- [6. Security](#6-security)
- [7. MySQL](#7-mysql)
- [8. Project Structure and Dependency Management](#8-project-structure-and-dependency-management)
- [9. Design Principles](#9-design-principles)
- [10. Spring Boot 2.7 → 3.x Migration Guide](#10-spring-boot-27--3x-migration-guide)
- [Appendix A: Error Code Design](#appendix-a-error-code-design)
- [Appendix B: Migration Lookup Tables](#appendix-b-migration-lookup-tables)
- [Appendix C: Cheat Sheet](#appendix-c-cheat-sheet)
- [Appendix D: Change Log](#appendix-d-change-log)

---

## 1. Coding Conventions

### 1.1 Naming

1. [MUST] Names must not begin or end with an underscore or dollar sign. Never mix pinyin and English, and never name things in Chinese (internationally recognized proper nouns excepted).
2. [MUST] Classes use `UpperCamelCase`; methods, parameters, member variables and local variables use `lowerCamelCase`; constants are `UPPER_SNAKE_CASE`.
3. [MUST] Abstract classes start with `Abstract`; exception classes end with `Exception`; test classes are `<ClassUnderTest>Test`.
4. [MUST] Declare arrays as `int[] arrayDemo`, never `String args[]`.
5. [MUST] **POJO boolean properties must not use an `is` prefix** (an `isSuccess` style property breaks serialization in some frameworks); map database `is_xxx` columns to `xxx` properties via `resultMap`.
6. [MUST] Package names are all lowercase and singular. A subclass must not redeclare a parent field, and local variables in different blocks of one method must not collide.
7. [MUST] Service and Mapper (DAO) implementations end with `Impl`; service interfaces start with `I` (e.g. `IOrderService`).
8. [MUST] Never use temporary names such as `XxxNew`, `XxxTemp2`, `XxxUtils2`. Mark deprecated classes with `@Deprecated` and name the replacement instead of distinguishing by suffix.
9. [SHOULD] Layer naming convention (apply consistently — **never mix two schemes**):

   | Layer | Recommended name | Notes |
   |---|---|---|
   | Database entity | `Xxx` or `XxxDO` | one-to-one with a table |
   | Inter-service transfer | `XxxDto` | internal transport object |
   | Request payload | `XxxReq` / `XxxQuery` | received by the controller |
   | Response payload | `XxxResp` / `XxxVo` | returned to callers |
   | Data access | `XxxMapper` or `XxxDao` | pick one, never both |

10. [SHOULD] Service / Mapper method names: single object `get`; multiple `list`; counting `count`; insert `save` / `insert`; delete `remove` / `delete`; update `update`.
11. [MAY] Enum classes end with `Enum`; enum constants are `UPPER_SNAKE_CASE`; **every enum constant must carry a business-meaning comment**.

### 1.2 Constants

1. [MUST] No magic values in business code — define a constant or enum.
2. [MUST] Assign `Long` with an uppercase `L`, never lowercase `l` (easily confused with the digit 1).
3. [SHOULD] Split constant classes by business domain instead of maintaining one giant `Constants` class.
4. [SHOULD] Prefer `enum` for fixed value sets; add an enum constant for every new status instead of scattering string literals.
5. [SHOULD][JDK17] When an enum needs multiple associated values, use an enum with fields plus a static lookup `Map` instead of `switch(name)` or repeated `values()` scans.

### 1.3 Formatting

1. [MUST] Empty blocks are written `{}`. For non-empty blocks the opening brace stays on the same line and the closing brace goes on its own line; `else` follows the closing brace on the same line.
2. [MUST] **Indent with 4 spaces, never tabs.** Enforce this with `.editorconfig` (`indent_style=space`, `indent_size=4`, `end_of_line=lf`, `charset=utf-8`).
3. [MUST] Put a space between `if/for/while/switch` and the parenthesis; spaces around binary and ternary operators; a cast is `(int) first` with no space before the variable.
4. [MUST] Maximum 120 characters per line. When wrapping, let operators and dots stay at the end of the line, wrap after commas, and never put a line break before a parenthesis.
5. [MUST] UTF-8 encoding and **LF** line endings (never CRLF — it breaks shell scripts and floods diffs).
6. [SHOULD] Keep methods under 80 lines; separate distinct business steps with a blank line and never use multiple consecutive blank lines.
7. [MUST] Never put business logic in a controller — respect the layering strictly.
8. [SHOULD] Extract duplicated code into a shared method and move it into the common module rather than copying it three times.

### 1.4 OOP

1. [MUST] Access static variables and methods through the class name, never through an instance reference.
2. [MUST] Overriding methods must carry `@Override`.
3. [MUST] Never change the signature of a published interface; deprecate with `@Deprecated` and point to the replacement.
4. [MUST] Compare wrapper types with `equals()`, never `==`. Prefer `Objects.equals(a, b)`.
5. [MUST] Store money as an integer in the smallest currency unit (cents) or as `BigDecimal` / a `decimal` column. Never use `float`/`double` for money.
6. [MUST] Compare `BigDecimal` values with **`compareTo()`**, never `equals()`. Never construct via `new BigDecimal(double)` — use `new BigDecimal("0.1")` or `BigDecimal.valueOf(0.1)`.
7. [MUST] Never compare floating-point values with `==`; use a tolerance or `BigDecimal`.
8. [MUST] POJO properties and RPC parameters/return values use wrapper types; local variables prefer primitives.
9. [MUST] **Never set default values on POJO fields** — on update, unset fields would overwrite existing data with defaults.
10. [MUST] POJOs must implement `toString` (Lombok `@Data` generates it — do not hand-write `isXxx()` alongside `getXxx()`).
11. [MUST] Concatenate strings inside loops with `StringBuilder.append()` or `String.join`, never `str = str + "x"`.
12. [MUST] Keep access as tight as possible: `private` first, then `protected`, and use `public` sparingly.
13. [MUST][JDK17] **Never depend on JDK internal APIs** (`sun.*`, `com.sun.*`) or reflectively access private members — Java 17 strong encapsulation (JEP 403) forbids it by default. If `--add-opens` is genuinely required, declare it explicitly in the startup script and comment why.
14. [SHOULD][JDK17] Prefer composition over inheritance, and mark classes and immutable fields `final` to narrow the inheritance surface. Use `sealed` when the set of permitted subclasses must be exact (see [2.7](#27-sealed-classes-and-interfaces)).

### 1.5 Date and Time

1. [MUST] In patterns the **year is lowercase `yyyy`**, never uppercase `YYYY` (week-based year produces wrong results at year boundaries). Distinguish `M` month / `m` minute and `H` 24-hour / `h` 12-hour.
2. [MUST] New code uses `java.time` (`LocalDateTime`) exclusively. **Never add a `Date` field, parameter, or return value.**
   - Date only → `LocalDate`; timestamp → `Instant`; duration → `Duration`.
   - Annotate with `@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")` (or configure it globally) for a consistent wire format.
   - Convert to/from `java.util.Date` **only at boundaries** (legacy APIs, third-party SDKs): `Date.from(instant)`, `localDateTime.atZone(ZoneId.systemDefault()).toInstant()`.
   - Migrate existing `Date` fields incrementally as modules are refactored. Never let two date types coexist for the same semantic field.
3. [MUST] Never use `java.sql.Date` / `java.sql.Time` / `java.sql.Timestamp`; never use `Calendar`.
4. [MUST] Get the current epoch millis via `System.currentTimeMillis()` or `Instant.now()`, not `new Date().getTime()`.
5. [MUST] Never make `SimpleDateFormat` `static` (not thread-safe). **`DateTimeFormatter` is thread-safe and may be a `static final` constant.**
6. [SHOULD][JDK17] Compute date differences with `ChronoUnit.DAYS.between(a, b)` instead of `(t2 - t1) / 86400000`. Never hardcode 365 days — use `LocalDate.now().lengthOfYear()`.
7. [SHOULD] Centralize format constants instead of scattering pattern strings:
   ```java
   public static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
   ```

### 1.6 Collections

1. [MUST] Overriding `equals` requires overriding `hashCode`. Objects stored in a `Set` or used as a custom `Map` key must override both.
2. [MUST] Test emptiness with `isEmpty()`, not `size() == 0`.
3. [MUST] `Collectors.toMap()` requires a merge function (duplicate keys throw) and rejects null values (NPE). Prefer `toMap(k, v, (a, b) -> a, LinkedHashMap::new)`.
4. [MUST] `ArrayList.subList` returns an internal **view** — never cast it to `ArrayList`. Structural changes to the parent list make iteration throw `ConcurrentModificationException`.
5. [MUST] The collections returned by `Map#keySet/values/entrySet` reject `add`.
6. [MUST] Convert a collection to an array with `list.toArray(new String[0])`, never the no-arg `toArray()` followed by a cast.
7. [MUST] The list returned by `Arrays.asList()` rejects `add/remove/clear` and remains backed by the original array.
8. [MUST] **Never add to or remove from a collection inside a foreach loop.** Use an `Iterator` or `removeIf`.
9. [MUST] Size collections up front when possible; a `HashMap` initial capacity is `(expected size / 0.75) + 1`.
10. [SHOULD] Iterate maps through `entrySet` rather than `keySet` plus a second lookup.
11. [SHOULD] Follow PECS for generics: `<? extends T>` is read-only, `<? super T>` is write-only.
12. [SHOULD][JDK17] For small, fixed collections use `List.of()/Set.of()/Map.of()` to create **immutable** collections. ⚠️ They **reject null elements** and are immutable (use `new ArrayList<>(List.of(...))` when mutability is needed).
13. [SHOULD][JDK16+] `stream().collect(Collectors.toList())` simplifies to `stream().toList()` (which returns an **immutable** list). For a mutable or specific collection type keep `Collectors.toCollection(ArrayList::new)`.

| Collection type | Null key allowed | Null value allowed | Notes |
|---|---|---|---|
| `HashMap` | ✅ | ✅ | not thread-safe |
| `ConcurrentHashMap` | ❌ | ❌ | thread-safe |
| `Hashtable` | ❌ | ❌ | obsolete |
| `TreeMap` | ❌ | ✅ | ordered, not thread-safe |
| `List.of` / `Map.of` | ❌ | ❌ | any null element throws NPE |

### 1.7 Concurrency

1. [MUST] Custom threads and thread factories must set meaningful thread names so `jstack` is usable.
2. [MUST] Business threads must come from a thread pool. Never call `new Thread()` in business code.
3. [MUST] Never create pools through the `Executors` convenience factories (`newFixedThreadPool` / `newCachedThreadPool` can both OOM). Construct `ThreadPoolExecutor` explicitly.
4. [MUST] Always `remove()` a `ThreadLocal` in a `finally` block; on pooled threads a leak is a memory leak.
5. [MUST] Keep lock scope small — lock a block, not an entire method. **Never call a remote service while holding a lock.**
6. [MUST] When locking multiple objects or tables, always acquire in the same order to avoid deadlock.
7. [MUST] Call `Lock.lock()` **outside** the `try` block and `unlock()` in `finally`.
8. [MUST] Scheduled work must not use `Timer`; use `ScheduledExecutorService` or the project's scheduling framework.
9. [MUST] In double-checked locking the singleton field must be `volatile`.
10. [MUST] `volatile` only guarantees visibility; compound operations such as `count++` remain unsafe — use `AtomicInteger` / `LongAdder` for counters.
11. [SHOULD] For concurrent-update conflicts under 20% probability use optimistic locking (`version`); money-sensitive flows require pessimistic locking.
12. [SHOULD] Never share a `Random` instance across threads — use `ThreadLocalRandom`; on JDK 17+ `RandomGenerator` is a unified entry point.
13. [SHOULD] Orchestrate multi-step async work with `CompletableFuture` instead of chaining blocking `Future.get()` calls. **Always** handle failures (`exceptionally` / `handle`) and pass an explicit executor — **never** run blocking I/O on `ForkJoinPool.commonPool()`.
14. [MUST][JDK17] **Java 17 has no virtual threads** (they are finalized only in JDK 21). On 17 keep using a properly sized thread pool plus async orchestration; enable virtual threads gradually after upgrading, see [10.4](#104-virtual-threads-jdk-21).

### 1.8 Control Flow

1. [MUST] Every `switch` case must end with `break`/`continue`/`return` or an explicit fall-through comment, and the `switch` must have a `default`.
2. [MUST] Null-check a `String` `switch` argument before switching on it.
3. [MUST] Always wrap `if/for/while/do-while` bodies in braces, even for a single statement.
4. [MUST] Watch for auto-unboxing NPEs in ternary expressions.
5. [MUST] Under high concurrency do not use `==` as a loop exit condition — use a range comparison.
6. [SHOULD] Use guard clauses with early `return` to reduce nesting; never nest deeper than 3 levels.
7. [SHOULD] Assign complex conditions to a well-named boolean variable; never assign inside a condition expression.
8. [SHOULD][JDK17] Replace long if-else chains with a **switch expression** (`->` plus `yield`), see [2.5](#25-switch-expressions).
9. [SHOULD][JDK17] Replace type-check-plus-cast with **`instanceof` pattern matching**, see [2.6](#26-instanceof-pattern-matching).

### 1.9 Comments

1. [MUST] Use Javadoc `/** */` for classes, class fields and public methods — not single-line `//`.
2. [MUST] Interface and abstract methods must document purpose, parameters, return value and exceptions.
3. [MUST] Class Javadoc must contain `@author` and `@since`.
4. [MUST] Every enum constant must carry a comment explaining its business meaning.
5. [MUST] Update comments together with the code. **Delete dead code instead of commenting it out.** Mark `TODO` / `FIXME` with an owner and a date.
6. [SHOULD] Keep the comment language consistent across the project, and keep API documentation coherent with the code comments rather than telling two different stories.

### 1.10 API and Frontend Contract

1. [MUST] Production APIs must use HTTPS. URL paths use plural nouns, lowercase with hyphen or underscore separators, and never a file extension such as `.json`.
2. [MUST] Return `[]` rather than `null` for an empty list so the frontend can skip null checks.
3. [MUST] Error responses carry four elements: HTTP status code, `errorCode`, `errorMessage`, and a user-friendly message.
4. [MUST] All JSON keys use `lowerCamelCase`.
5. [MUST] Oversized `Long` values (order numbers, serial numbers above 2^53) must be serialized as `String` for the frontend to avoid JavaScript `Number` precision loss (`@JsonSerialize(using = ToStringSerializer.class)`).
6. [MUST] URL query parameters must stay under 2048 bytes; large payloads go in the request body.
7. [SHOULD] Paging: when `pageNo < 1` return the first page; when `pageNo` exceeds the last page return the last page.
8. [SHOULD] Use `forward` for internal navigation; external redirect targets must be generated by a proxy module and validated against a whitelist.

### 1.11 Miscellaneous

1. [MUST] Precompile `Pattern` as a `static` constant instead of calling `compile` inside a method (guards against ReDoS and repeated cost).
2. [MUST] Never use Apache Commons `BeanUtils` for object copying; use Spring `BeanUtils`, CGLIB `BeanCopier`, or MapStruct.
3. [SHOULD][JDK17] Prefer native string APIs over utility classes: `isBlank()`, `strip()`, `repeat(n)`, `lines()`, `formatted(...)`, `String.join`.
4. [MUST] Never call `System.setSecurityManager` (deprecated for removal in JDK 17); push security concerns into the framework layer.

---

## 2. JDK 17–21 Language Features and Best Practices

> The goal of this chapter: use modern syntax **correctly** — neither writing Java 8 code on Java 17/21, nor adopting features for their own sake.

### 2.1 Feature Availability

| Feature | Finalized in | Java 17 | Java 21 | Recommendation |
|---|---|---|---|---|
| Local variable `var` | 10 | ✅ | ✅ | use carefully, see 2.2 |
| Text blocks `"""` | 15 | ✅ | ✅ | recommended (SQL/JSON) |
| `switch` expressions (`->`/`yield`) | 14 | ✅ | ✅ | recommended |
| `instanceof` pattern matching | 16 | ✅ | ✅ | recommended |
| `record` classes | 16 | ✅ | ✅ | recommended (value objects) |
| `sealed` classes/interfaces | 17 | ✅ | ✅ | for domain modeling |
| `Stream.toList()` | 16 | ✅ | ✅ | recommended |
| `HexFormat` | 17 | ✅ | ✅ | recommended (bytes → hex) |
| Helpful NPE messages | 14/15 | ✅ on by default | ✅ | keep enabled |
| **`switch` pattern matching** | 21 | ❌ preview only | ✅ | forbidden on 17; recommended on 21 |
| **Record deconstruction** | 21 | ❌ | ✅ | forbidden on 17; recommended on 21 |
| **Virtual threads** | 21 | ❌ | ✅ | forbidden on 17; adopt cautiously on 21, see [10.4](#104-virtual-threads-jdk-21) |
| **Sequenced collections** | 21 | ❌ | ✅ | forbidden on 17; recommended on 21 |
| String templates `STR."..."` | preview | ❌ | ❌ preview only | **forbidden** |
| Structured concurrency / scoped values | preview | ❌ | ❌ preview only | **forbidden** |
| Unnamed variables `_` | preview | ❌ | ❌ preview only | **forbidden** |

> 🔴 **[MUST] Never enable `--enable-preview` in production.** Preview features may change or be removed, breaking compilation on the next upgrade.
> ⚠️ **[MUST] Features marked ❌ are forbidden on that JDK**: on JDK 17 no virtual threads, `switch` pattern matching, record deconstruction, or sequenced collections; on JDK 21 still no string templates, structured concurrency, scoped values, or unnamed variables.

### 2.2 Local Variable Type Inference (`var`)

- [SHOULD] Use `var` only for **local variables** whose type is obvious from the initializer:
  ```java
  var userList = userService.listByIds(ids);                          // ✅ type is obvious
  var formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"); // ✅
  ```
- [MUST] Never use it for fields, method parameters, return types, `null` initialization, or chained calls whose result type is unclear:
  ```java
  var result = service.doBiz();   // ❌ type cannot be seen at a glance
  var x = null;                   // ❌ does not compile
  ```
- [MUST] Never combine `var` with the diamond operator or lambdas in a way that makes inference ambiguous.

### 2.3 `record` Classes

- [SHOULD] Use records as **immutable value carriers**: read-only VOs/responses, configuration entries, in-method aggregates, entry-like objects for maps.
  ```java
  public record UserBrief(Long id, String name) { }
  ```
- [MUST] A `record` **cannot** be an ORM entity (no no-arg constructor, no setters).
- [MUST] Never annotate a `record` with Lombok `@Data` (conflicts), and never add setters.
- [SHOULD] Validate input in a **compact constructor**:
  ```java
  public record PageParam(int pageNum, int pageSize) {
      public PageParam {
          if (pageNum < 1 || pageSize < 1) {
              throw new IllegalArgumentException("Invalid paging parameters");
          }
      }
  }
  ```
- [MUST] Confirm serializer support before exposing a record (Jackson ≥ 2.12 supports records natively; Spring Boot 3 ships Jackson 2.15+, so it is fine).

### 2.4 Text Blocks

- [SHOULD] Use text blocks for multi-line SQL, JSON, shell snippets and test data instead of `"\n"` concatenation.
  ```java
  String sql = """
          SELECT id, name, create_time
          FROM tb_order
          WHERE status = ?
          """;
  ```
- [MUST] Do not mix `\t` into a text block. Indentation is relative to the closing `"""` — place it deliberately so an unintended amount of leading whitespace is not introduced.
- [MUST] When the content contains `"""` or needs escaped backslashes, consider a normal string or parameterized assembly instead, for readability.
- ⚠️ Not applicable to ORM XML mapping files (those are XML). Text blocks are for SQL/JSON embedded in Java code.

### 2.5 `switch` Expressions

- [SHOULD] Use arrow syntax and `yield` to eliminate fall-through and `break`:
  ```java
  String label = switch (status) {
      case 0, 1 -> "Pending";
      case 2 -> "In progress";
      case 3 -> {
          log.info("completed status={}", status);
          yield "Completed";        // a block branch returns via yield
      }
      default -> throw new ServiceException("Unknown status: " + status);
  };
  ```
- [MUST] A `switch` expression must be exhaustive: cover every enum constant plus a `default` guard so a newly added constant cannot silently fall through.
- [MUST] Arrow branches must not contain `break` / `continue` / `return`.
- [SHOULD] Centralize "enum → text/code" mappings in a static method on the enum rather than scattering `switch` statements.

### 2.6 `instanceof` Pattern Matching

- [SHOULD] Replace the check-then-cast pair:
  ```java
  // ✅ JDK 16+
  if (obj instanceof SysUser user) {
      return user.getNickName();
  }
  // ❌ old style
  if (obj instanceof SysUser) {
      SysUser user = (SysUser) obj;
      ...
  }
  ```
- [MUST] Scope of the pattern variable: in `if (a instanceof T t && t.check())` the variable `t` is visible only after the condition holds — do not reference it outside that scope.

### 2.7 `sealed` Classes and Interfaces

- [MAY] When a domain model has a fixed set of types that must be handled exhaustively, declare it `sealed`:
  ```java
  public sealed interface PayChannel permits WechatPay, AlipayPay, UnionPay { }
  public final class WechatPay implements PayChannel { }
  ```
- [MUST] Every permitted subtype must be explicitly `final`, `sealed`, or `non-sealed`.
- [MAY] **Prefer enums** for fixed value sets; use `sealed` for families of types that carry different data, and never replace an enum just to use a new feature.

### 2.8 Immutable Collection Factories

- [SHOULD] For small fixed collections prefer `List.of/Set.of/Map.of` over `new ArrayList<>` plus `add`.
- [MUST] ⚠️ These factories are **immutable and reject null**: `List.of(a, null)` throws NPE immediately, and `Set.of` / `Map.of` reject duplicate keys.
- [MUST] Never pass the result of `List.of(...)` to downstream code that adds or removes elements (`UnsupportedOperationException`).
- [MUST] Return defensive copies to callers via `List.copyOf` or `Collections.unmodifiableList`.

### 2.9 Streams and Optional

- [SHOULD] Prefer `stream().toList()` over `collect(Collectors.toList())`.
- [MUST] Never nest streams more than 2 levels; extract complex logic into a method. Do not put side-effecting logic inside a stream pipeline.
- [SHOULD] Use `Collectors.groupingBy` / `partitioningBy` / `teeing` for grouping and aggregation instead of hand-rolled `Map` accumulation.
- [MUST] Use `parallelStream()` sparingly: only for **pure computation, no blocking, no shared mutable state** and a large enough data set. It is **forbidden** where database or remote calls, `ThreadLocal`, or transaction context are involved.
- [SHOULD] Use `Optional` to express a **return value that may be absent**:
  ```java
  return Optional.ofNullable(userMapper.selectById(id))
          .map(User::getDeptId)
          .orElseThrow(() -> new ServiceException("User not found"));
  ```
- [MUST] `Optional` must **not** be used as a field type, method parameter, collection element, or `Map` value; never call `get()` without checking (use `orElseThrow`).
- [MUST] Do not overuse `Optional` — if a single null check suffices, do not wrap it.

### 2.10 Helpful NPE Messages

- [SHOULD] Keep helpful NPEs enabled (default since JDK 15). The message names the exact variable or method call that was null, which dramatically speeds up diagnosis.
- [MAY] A log line such as `Cannot invoke "..." because "..." is null` is a helpful NPE — **do not** disable it.

### 2.11 Compilation and JVM Flags

- [MUST] Use `<release>` in `maven-compiler-plugin` instead of `source`/`target` so APIs newer than the target cannot be used accidentally:
  ```xml
  <configuration>
      <release>21</release>
      <encoding>UTF-8</encoding>
      <compilerArgs>
          <arg>-parameters</arg>   <!-- required by Spring Boot 3 -->
      </compilerArgs>
  </configuration>
  ```
- [MUST] No `--enable-preview` in production.
- [MUST] In production set `-Xms` equal to `-Xmx` to avoid heap resizing during GC.
- [MUST] Always add `-XX:+HeapDumpOnOutOfMemoryError` so an OOM writes a heap dump.
- [SHOULD] G1 is the default GC; for latency-sensitive services evaluate ZGC (on JDK 21 prefer **Generational ZGC**: `-XX:+UseZGC -XX:+ZGenerational`).
- [MUST] Before a JDK upgrade, scan for internal API usage with `jdeps --multi-release <N>` and remove flags that no longer exist (for example `-XX:+UseBiasedLocking`, removed in 15).

---

## 3. Spring Boot 3 Backend Engineering Standard

### 3.1 Layering and Package Structure

```
<root> (pom aggregator, Maven multi-module)
├── <app>-admin     — bootstrap/Web layer: controller, job, config
├── <app>-service   — business/persistence layer: domain, mapper, service, framework
└── <app>-common    — shared layer: core, enums, exception, utils, constant
```

- [MUST] Strict layering: `Controller → Service → Mapper/Repository → database`.
- [MUST] A controller only receives and validates parameters, calls a service, and wraps the result. **No business logic and no direct mapper calls in a controller.**
- [MUST] One-way module dependencies: `admin → service → common`. **No reverse dependency**, and the common module must not depend on business modules.
- [SHOULD] Package naming `com.<company>.<app>.<domain>.<layer>`, all lowercase and singular.

### 3.2 Controller

1. [MUST] Annotate the class with `@RestController` and `@RequestMapping("/xxx")` (lowercase, plural noun).
2. [MUST] Return a **unified response wrapper** (`R<T>` / `Result<T>`) or a **paged wrapper** (`TableDataInfo<T>` / `PageResult<T>`). **Never omit the generic type, and never hand-build a `Map` as the response body.**
3. [MUST] Authorization must be declared explicitly; nothing is open by default. With Sa-Token use `@SaCheckPermission("module:business:action")`; with Spring Security use `@PreAuthorize("hasAuthority('...')")`.
4. [SHOULD] Add idempotency protection to write endpoints (for example `@RepeatSubmit`) and rate limiting (for example `@RateLimiter`).
5. [MUST] **Do not write try-catch in a controller** — the global exception handler converts exceptions uniformly.
6. [SHOULD] Keep the endpoint path and the permission string aligned: `/order/batchAdd` ↔ `order:order:batchAdd`.
7. [MUST][SB3] API documentation annotations come from `io.swagger.v3.oas.annotations` (`@Tag` / `@Operation` / `@Schema`); the 1.x annotations `io.swagger.annotations` (`@Api` / `@ApiOperation`) are **no longer used**.

### 3.3 Service

1. [MUST] Interfaces are named `IXxxService` and implementations `XxxServiceImpl`.
2. [MUST] Business preconditions go through the **project's shared assertion utility** instead of scattered `if (...) throw new RuntimeException(...)`:
   ```java
   Assert.isNotNull(req.getSupplierId(), "Supplier ID must not be null");
   Assert.isTrue(ids.size() == depts.size(), "Some suppliers do not exist; please review and retry");
   ```
3. [MUST] Object conversion uses MapStruct / `BeanUtils` / the shared converter — never hand-written field-by-field `set` calls (except where special processing is required).
4. [MUST] Cross-service orchestration belongs in the service layer, not in a controller or mapper.
5. [SHOULD] Keep each method single-purpose; extract complex methods into private helpers and mark the main flow with comments.

### 3.4 Data Access

1. [MUST] Mappers extend MyBatis-Plus `BaseMapper<T>` (or the project's `BaseMapperPlus<M,T,V>`) to reuse the common capabilities.
2. [MUST] Build query criteria with `LambdaQueryWrapper` / `Wrappers.query()`. **Never hardcode concatenated column names.**
3. [MUST] Define a `resultMap` plus `<sql id="Base_Column_List">` in XML, and **list columns explicitly** — **`SELECT *` is forbidden**.
4. [MUST] Bind dynamic parameters with `#{}`; **`${}` is forbidden** (SQL injection).
5. [MUST] The soft-delete condition (for example `del_flag = '0'`) **must always be present**. If `@TableLogic` is not fully enabled this must be checked at every query site — a missing condition silently returns deleted rows.
6. [MUST] Every update must set `update_time` and touch only the changed columns rather than overwriting the whole row.
7. [MUST] Page through the project's paging object (for example `PageQuery`), which validates sort fields and prevents injection; return the unified paged wrapper.
8. [SHOULD] For complex multi-table queries, consider a database view or a search engine instead of an ever-growing SQL statement.

### 3.5 Unified Response and Exceptions

1. [MUST] Return the unified structure on success (for example `R.ok(data)`); on failure throw a business exception and let the global handler convert it.
2. [MUST] Use a **custom business exception** (for example `ServiceException`). **Never throw `RuntimeException` / `Exception` directly.**
3. [MUST] Return the paged wrapper for list endpoints instead of hand-building `total`/`rows`.
4. [SHOULD] See [Appendix A](#appendix-a-error-code-design) for error code semantics. Error codes are for program logic and **must not be shown to end users**.

### 3.6 Validation

1. [MUST] Validate request objects with JSR-303 (`jakarta.validation`) annotations — `@NotNull`, `@NotBlank`, `@Size`, `@Valid` — and use **validation groups** to distinguish create, update and query scenarios.
2. [SHOULD] Use the assertion utility for simple preconditions and `@Valid` with groups for complex forms. Pick one approach and keep it consistent.
3. [MUST] Validate every user-supplied parameter to guard against SSRF, ReDoS and deserialization attacks (see chapter 6).
4. [MUST][SB3] Validation annotation packages are `jakarta.validation.*` (previously `javax.validation.*`).

### 3.7 Transactions

1. [MUST] Use `@Transactional(rollbackFor = Exception.class)` — `rollbackFor` is **mandatory**, since the default rolls back only on `RuntimeException`.
2. [MUST] A transactional method should wrap only the necessary database work. **Never make RPC or remote calls or perform large file I/O inside a transaction** — long transactions hold table locks and exhaust the connection pool.
3. [MUST] `@Transactional` only takes effect on `public` methods, and **self-invocation inside the same class (`this.xxx()`) bypasses the proxy**. Self-inject or extract to another bean.
4. [MAY] Declare `@Transactional(readOnly = true)` for read-only operations as an optimization.
5. [SHOULD] If you catch an exception inside a transaction and still need a rollback, call `TransactionAspectSupport.currentTransactionStatus().setRollbackOnly()`.

### 3.8 Caching and Distributed Locks

1. [MUST] Guard cross-node concurrency with a distributed lock (Lock4j `@Lock4j` or Redisson). **Never** use `synchronized` / `ReentrantLock` for multi-instance concurrency.
2. [MUST] Centralize cache keys in a constants class using the format `module:business:identifier`; never scatter raw strings.
3. [SHOULD] Update the database first and then evict the cache. Avoid large keys and hot keys, and always set a TTL.
4. [MUST] Explicitly protect against cache penetration, breakdown and avalanche (null caching, mutual rebuilding, jittered TTLs).

### 3.9 Authorization and the Current User

1. [MUST] Resolve the current user through the shared entry point (for example RuoYi-style `LoginHelper.getLoginUser()`, or `SecurityContextHolder` with Spring Security) and **handle the null case** of an expired session.
2. [MUST] Permission strings must match the authorization annotations. Never bypass authorization to reach business logic directly.
3. [MUST] Sensitive operations (export, delete, money movement) must additionally enforce **data-level authorization** to prevent horizontal privilege escalation.

### 3.10 Audit Fields and Soft Delete

1. [MUST] Auto-populate `createBy` / `createTime` / `updateBy` / `updateTime` (MyBatis-Plus `MetaObjectHandler` or the auditing mechanism).
2. [MUST] Soft-delete business data (a `del_flag` column plus its enum) rather than issuing a physical delete, unless explicitly required.
3. [MAY] The `del_flag` type and delete value must be uniform across the project (`tinyint(0/1)` or `varchar('0'/'2')`); new tables follow the existing convention.

### 3.11 Dependency Injection

1. [SHOULD] Prefer **constructor injection** (officially recommended by Spring: testable, allows `final` fields, surfaces circular dependencies).
2. [MUST] **Never mix** constructor injection and field injection in the same class; keep the project consistent.
3. [MUST] Never `new` a service to call business methods — always use container injection.
4. [MUST][SB3] Injection and lifecycle annotation packages changed: `javax.annotation.Resource` → `jakarta.annotation.Resource`, and likewise `@PostConstruct` / `@PreDestroy`.
5. [MUST][SB3] **Circular references are disabled by default** (`spring.main.allow-circular-references=false`); self-injection must be refactored into a separate bean.

### 3.12 Configuration and Observability

1. [MUST] Externalize configuration per environment (`application-{env}.yml` or a configuration center). **Never hardcode** secrets or database passwords in code.
2. [MUST] Store sensitive configuration in environment variables or an encrypted configuration store. **Never commit real credentials to the repository.**
3. [SHOULD] Bind structured configuration with `@ConfigurationProperties` (validated via `@Validated`) instead of scattering `@Value`.
4. [MUST][SB3] Auto-configuration registration moved from `META-INF/spring.factories` to `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` — in-house starters must be updated.
5. [SHOULD] Enable Actuator health checks and metrics, and expose only the necessary endpoints in production via an explicit allowlist (`management.endpoints.web.exposure.include`).
6. [SHOULD] Propagate a trace ID on critical paths (MDC or distributed tracing) so log lines can be correlated.

---

## 4. Exceptions and Logging

### 4.1 Error Codes

1. [MUST] Use a uniform error code structure (for example 5 characters: an origin letter plus a 4-digit number) — `A` for client-side errors, `B` for internal system errors, `C` for third-party call failures.
2. [MUST] Successful business responses return `00000`.
3. [MUST] Error codes are for program logic and **must not be shown directly to end users**.

### 4.2 Exception Handling

1. [MUST] Do not catch predictable `RuntimeException`s (NPE, index out of bounds) — guard with an early `if` instead.
2. [MUST] Never use exceptions as flow control.
3. [MUST] Never write an oversized `try-catch`; catch narrow exception types.
4. [MUST] A caught exception must be handled — logged or rethrown. The outermost entry point must convert exceptions into the unified structure (global exception handler).
5. [MUST] Close resources in `finally`; on JDK 7+ prefer **try-with-resources**. **Never `return` from a `finally` block.**
6. [MUST] Catch `Throwable` around RPC calls and reflective calls into third-party libraries.
7. [MUST] Throw the custom business exception rather than `new RuntimeException()`.
8. [SHOULD][JDK17] For a "cannot happen" branch in a `switch`, throw `IllegalStateException` or a custom exception so the problem surfaces, instead of silently returning null.
9. [SHOULD] Guard NPE-prone spots (unboxing, chained getters, remote calls returning null) with `Optional` or an early check, see [2.9](#29-streams-and-optional).

### 4.3 Logging

1. [MUST] Log through SLF4J (Lombok `@Slf4j`), never against the logback/log4j implementation directly.
2. [MUST] Use **placeholders**: `log.info("orderId={}", orderId)`. Never concatenate strings.
3. [MUST] Guard `debug`/`trace` output with `log.isDebugEnabled()`.
4. [MUST] **Never** use `System.out.println` or `e.printStackTrace()`.
5. [MUST] Log **both the input parameters and the stack trace** for an exception; do not log a JSON serialization of an object — call its `toString`.
6. [MUST] Disable debug in production. Use `warn` for bad business parameters, and reserve `error` for genuine system failures.
7. [MUST] Mask sensitive data (phone numbers, ID numbers, amounts) before logging. Never log plaintext passwords or tokens.
8. [MUST] Retention: ordinary logs ≥ 15 days; security and sensitive-operation logs ≥ 6 months, backed up on multiple machines.

---

## 5. Unit Testing

> Standardize on **JUnit 5 (Jupiter)** plus Mockito; use Testcontainers for integration tests.

1. [MUST] Follow the **AIR principles**: Automatic execution, Independent cases, Repeatable runs.
2. [MUST] Never verify results with `System.out` — use assertions (`Assertions.*`).
3. [MUST] Mock external dependencies (database, Redis, RPC, third parties). A unit test must not require a real external environment.
4. [MUST] Test code lives in `src/test/java`, never in the production source tree.
5. [SHOULD] Follow **BCDE**: Border values, Correct input, Design documents, Error input.
6. [SHOULD] Coverage: ≥ 70% statement coverage for ordinary modules; 100% statement and branch coverage for core business modules.
7. [SHOULD][JUnit5]
   - Use `@DisplayName` for readable case descriptions, `@Nested` to organize scenarios, and `@ParameterizedTest` with `@ValueSource`/`@CsvSource` for boundary values.
   - Aggregate assertions with `assertAll(...)`; assert exceptions with `assertThrows(ServiceException.class, () -> ...)`.
   - Use `@BeforeEach`/`@AfterEach` for lifecycle; test classes and methods need not be `public`.
   - `@Disabled` must always carry a reason — no undocumented skipped tests.
   - Use `@Tag` to separate unit tests from integration tests, aligned with the Maven `groups`/`excludedGroups` configuration.

---

## 6. Security

1. [MUST] Every access to a user's private data must enforce **horizontal authorization** to prevent privilege escalation.
2. [MUST] Mask sensitive data (phone numbers, ID numbers, bank cards) before returning it to the frontend.
3. [MUST] Never concatenate SQL strings — bind all parameters to prevent SQL injection.
4. [MUST] Validate every user-supplied parameter to guard against SSRF, ReDoS and deserialization vulnerabilities.
5. [MUST] Escape user input rendered into HTML; enable CSRF protection for forms and AJAX endpoints.
6. [MUST] Validate external redirect targets against a **whitelist**; rate-limit SMS and verification-code endpoints.
7. [MUST][JDK17] Do not depend on JDK internal APIs or unsafe reflection (JEP 403 strong encapsulation). Never deserialize untrusted data with `ObjectInputStream` — deserialization is a high-yield vulnerability class.
8. [MUST] Use the standard library or a compliant national-cryptography implementation for encryption and hashing. **Never invent your own algorithm and never hardcode keys in code.**
9. [MUST] Enforce both API authorization and data authorization. Validate the type, size and content of uploaded files and store them in an isolated location.

---

## 7. MySQL

### 7.1 Table Design

1. [MUST] Name boolean columns `is_xxx` with type `unsigned tinyint`, where 1 means true and 0 means false.
2. [MUST] Table and column names are all lowercase, never start with a digit, and avoid MySQL reserved keywords.
3. [MUST] Use singular table names. Index naming: `pk_` primary key, `uk_` unique index, `idx_` ordinary index.
4. [MUST] Store money as `decimal`. Never `float`/`double`.
5. [MUST] Keep `varchar` at 5000 or below; beyond that use `text` and split into a separate table.
6. [MUST] Every business table has three required columns: `id bigint unsigned` auto-increment primary key, `create_time datetime`, `update_time datetime`.
7. [SHOULD] Consider sharding only when a table is projected to exceed 5 million rows or 2 GB.

### 7.2 Indexes

1. [MUST] Any field with a business uniqueness constraint must have a unique index — do not rely on application-level checks alone.
2. [MUST] Join no more than 3 tables; joined columns must have identical types and both sides must be indexed.
3. [MUST] Specify a prefix length when indexing a `varchar` column.
4. [MUST] Never use a leading wildcard (`%xxx`) with `like`; use a search engine for full-text search rather than `like`.
5. [SHOULD] Place `order by` columns at the end of a composite index; columns after a range condition cannot be used for filtering.
6. [SHOULD] Aim for covering indexes to avoid table lookups (`EXPLAIN` shows `Using index`).
7. [SHOULD] Optimize large `offset` paging with a deferred join subquery.
8. [SHOULD] In a composite index put equality-condition columns leftmost, and avoid implicit type conversion which disables the index.

### 7.3 SQL Statements

1. [MUST] Count rows with `count(*)`, never `count(column)`.
2. [MUST] `sum` may return null — wrap it as `IFNULL(SUM(col), 0)`.
3. [MUST] Test for NULL with `ISNULL()`. Never write `= null` or `!= null`.
4. [MUST] No database foreign keys or cascading updates/deletes — handle it in the application layer. No stored procedures.
5. [MUST] Qualify every column with a table alias in multi-table queries. Never `select *`.
6. [MUST] Keep `IN` lists under 1000 elements. Never issue `truncate table` from business code.

---

## 8. Project Structure and Dependency Management

### 8.1 Application Layers

```
Open API layer / presentation layer
  → Web request handling layer (Controller)
  → Service business logic layer
  → Manager general-purpose layer (caching, third parties, multi-mapper assembly)
  → Mapper/DAO persistence layer
  → Storage / third-party services
```

- Web layer: request routing, parameter validation, simple handling.
- Service layer: business logic.
- Manager layer: wraps third-party services, cache logic, and multi-mapper assembly.
- Mapper layer: database interaction.

[MUST] Never pass more than 2 query parameters as a `Map` — define a request object.

**Exception handling by layer:**
1. The DAO layer wraps exceptions into DAO exceptions, logs nothing, and rethrows.
2. The service layer catches and logs the full context, or throws a business exception.
3. The web layer returns a friendly message; the open API returns the unified error code.

### 8.2 Maven Dependencies

1. [MUST] Follow the GAV convention: `groupId` = `com.<company>.<line>[.<subline>]`; `artifactId` = product line + module; `version` = major.minor.patch.
2. [MUST] Production **must never depend on a `SNAPSHOT`** version.
3. [MUST] Declare versions centrally in `<dependencyManagement>`; `<dependencies>` lists only `groupId` and `artifactId`.
4. [MUST] The same GAV must not appear with multiple versions in one pom.
5. [SHOULD] A shared library's public API returns POJOs and **must not contain enum types** (deserialization breaks when versions differ).
6. [SHOULD] Pin the JDK and dependency versions with `maven-enforcer-plugin`, and check for upgrades with `versions-maven-plugin`.

### 8.3 Servers and JVM

1. [MUST] In production set `-Xms` equal to `-Xmx`, and always enable `-XX:+HeapDumpOnOutOfMemoryError`.
2. [SHOULD] Tune `tcp_fin_timeout` down on Linux to reduce `time_wait`, and raise the file descriptor limit.
3. [SHOULD] In containers size the heap against the container limit (`-XX:MaxRAMPercentage`) to avoid being OOMKilled.
4. [MUST] Record every startup-parameter change in an ADR or operations document — never lose a hand-tuned production flag.

---

## 9. Design Principles

1. [MUST] Changes to storage, table structures or data structures require review and a written design document.
2. [SHOULD] UML guidance:
   - more than one user role or five business use cases: use-case diagram
   - more than three object states: state diagram
   - call chains spanning more than three objects: sequence diagram
   - more than five models with complex dependencies: class diagram
   - complex multi-object collaboration: activity diagram
3. [MUST] Design principles: single responsibility; prefer composition and aggregation over inheritance; dependency inversion; open-closed; DRY.
4. [SHOULD] The core of extensibility is identifying the points of change and isolating them (strategy, factory, SPI).
5. [MUST] Code is not a substitute for a design document — complex systems must retain documentation.
6. [MUST] Record **ADRs** (Architecture Decision Records) for technology choices and architectural trade-offs: context, decision, alternatives, consequences. At minimum explain "why not the other option".
7. [SHOULD] Public interfaces should be idempotent (write operations keyed by a business unique key), retryable, and observable (trace ID).

---

## 10. Spring Boot 2.7 → 3.x Migration Guide

> **Prerequisite**: Spring Boot 3.x is built on Spring Framework 6 and **requires Java 17 or later**, with Java 21 recommended.

### 10.1 `javax.*` → `jakarta.*` (biggest trap — a global replacement)

| Before (SB 2.7) | After (SB 3.x) | Typical impact |
|---|---|---|
| `javax.annotation.Resource` | `jakarta.annotation.Resource` | every `@Resource` injection point |
| `javax.servlet.*` | `jakarta.servlet.*` | filters, interceptors, request/response wrappers |
| `javax.validation.*` | `jakarta.validation.*` | `@NotNull`/`@Valid` and validation groups |
| `javax.persistence.*` | `jakarta.persistence.*` | if JPA is used |
| `javax.annotation.PreDestroy/PostConstruct` | `jakarta.annotation.*` | lifecycle callbacks |

### 10.2 Dependency Coordinates

| Capability | SB 2.7 coordinate | SB 3.x coordinate |
|---|---|---|
| Authorization | `sa-token-spring-boot-starter` | `sa-token-spring-boot3-starter` |
| ORM | `mybatis-plus-boot-starter` | `mybatis-plus-spring-boot3-starter` (3.5.4+) |
| API docs | springdoc 1.x + `io.swagger.annotations` | springdoc 2.x + `io.swagger.v3.oas.annotations` |
| Multi-datasource | `dynamic-datasource-spring-boot-starter` 3.x | 4.x |
| Distributed lock | `lock4j-redisson-spring-boot-starter` 2.2.3 | 2.2.4+ |
| Redisson | `redisson-spring-data-27` | `redisson-spring-data-3x` matching the SB version |
| Workflow | Flowable 6.8.x | Flowable 7.x |
| Admin/monitoring | `spring-boot-admin` 2.7.x | 3.x |

> ⚠️ Verify version numbers against the official compatibility matrix before upgrading.

### 10.3 Configuration and Behavior Changes

1. [MUST] Auto-configuration registration: `META-INF/spring.factories` → **`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`**.
2. [MUST] Redis configuration prefix: `spring.redis.*` → **`spring.data.redis.*`**.
3. [MUST] Path matching defaults to `PathPatternParser` and **trailing-slash matching is off by default** (`/api/user/` ≠ `/api/user`). Verify frontend call sites.
4. [MUST] Circular references are disabled by default; refactor self-injection into a separate bean.
5. [MUST] Compile with `-parameters` or `@RequestParam` and parameter binding may fail.
6. [MUST] `@ConfigurationProperties` binding rules changed (a single constructor no longer needs an explicit `@ConstructorBinding`).
7. [SHOULD] `spring.mvc.throw-exception-if-no-handler-found` and static-resource matching changed — regression-test 404s and static resources.

### 10.4 Virtual Threads (JDK 21) [JDK21]

Spring Boot 3.2+ enables them with one line: `spring.threads.virtual.enabled=true`.

- [MUST] **Never pool virtual threads.** A virtual thread is one-task-one-thread, discard-on-completion; do not feed them into a `ThreadPoolExecutor`. Create them with `Executors.newVirtualThreadPerTaskExecutor()` and limit concurrency with a `Semaphore`.
- [MUST] Virtual threads **only improve throughput for blocking I/O** — they do **not** help CPU-bound work. Keep a fixed-size platform thread pool for CPU-bound tasks.
- [MUST] Beware of `ThreadLocal`: with millions of virtual threads, caching large objects per thread causes immediate OOM. Pass values explicitly. `ScopedValue` is still **preview** on 21 — forbidden.
- [MUST] On JDK 21 `synchronized` **pins** the carrier thread; use `ReentrantLock` for blocking critical sections.
- [SHOULD] Once concurrency is amplified the bottleneck moves downstream: reassess connection-pool `maximumPoolSize`, Redis connections, and third-party rate limits.
- [MUST] **Load-test before and after** (TPS, latency, memory, pool wait time) before rolling out. Never "enable and see".

### 10.5 Migration Checklist

1. Upgrade the JDK; compile with `<release>` and `-parameters`.
2. Replace `javax.*` with `jakarta.*` globally (`Resource` / `servlet` / `validation` first).
3. Swap dependency coordinates per [10.2](#102-dependency-coordinates) and verify the compatibility matrix.
4. API docs: springdoc 1.x → 2.x and move to `io.swagger.v3.oas.annotations`.
5. Upgrade middleware starters to their SB3 variants (authorization / ORM / multi-datasource / Redis / lock / workflow).
6. Verify configuration: `spring.data.redis`, trailing-slash matching, circular references, `AutoConfiguration.imports`.
7. Regression-test authorization, paging, transactions, file upload/download, scheduled jobs and report export.
8. Evaluate and canary virtual threads (see [10.4](#104-virtual-threads-jdk-21)); roll out fully only after load tests pass.
9. Record an ADR covering the trade-offs, risks and rollback plan.

---

## Appendix A: Error Code Design

| Code | Category |
|---|---|
| 00000 | Success |
| A0001 | Client-side error (parameters, login, permission, upload, operation) |
| B0001 | Internal system error (timeout, rate limiting, resource exhaustion) |
| C0001 | Third-party service error (RPC, cache, messaging, middleware) |

---

## Appendix B: Migration Lookup Tables

### B.1 JDK 8 → 17 API migration

| Scenario | Old style (avoid) | New style (prefer) |
|---|---|---|
| Collect to list | `collect(Collectors.toList())` | `stream().toList()` (16+, immutable) |
| Immutable collection | `Collections.unmodifiableList(...)` | `List.of(...)` / `List.copyOf(...)` |
| Blank-string check | `str == null \|\| str.trim().isEmpty()` | `str == null \|\| str.isBlank()` |
| Trim whitespace | `str.trim()` | `str.strip()` |
| String formatting | `String.format("%s-%s", a, b)` | `"%s-%s".formatted(a, b)` (15+) |
| Multi-line string | `"a\n" + "b\n"` | text block `"""..."""` (15+) |
| Type check | `if (o instanceof T) { T t = (T) o; }` | `if (o instanceof T t) {}` (16+) |
| Multi-branch assignment | `if/else if` chain | `switch` expression (14+) |
| Current time | `new Date()` / `Calendar` | `LocalDateTime.now()` / `Instant.now()` |
| Time formatting | `new SimpleDateFormat("yyyy-MM-dd")` | `DateTimeFormatter.ofPattern(...)` (thread-safe) |
| Day difference | `(a.getTime()-b.getTime())/86400000` | `ChronoUnit.DAYS.between(b, a)` |
| Value object | hand-written getters/setters/equals/hashCode | `record` (16+) |
| File I/O | manual `InputStream` loop | `Files.readString(path)` / `Files.writeString(...)` (11+) |
| Bytes to hex | `String.format` loop | `HexFormat.of().formatHex(bytes)` (17+) |
| Random numbers | `new Random()` | `ThreadLocalRandom.current()` / `RandomGenerator` (17+) |
| Date/time type (new code) | `private Date createTime;` | `private LocalDateTime createTime;` |
| Internal APIs | `sun.misc.Unsafe` etc. | public APIs; if unavoidable, an explicit commented `--add-opens` |

### B.2 JDK 17 → 21 and Spring Boot 2.7 → 3.x migration

| Scenario | JDK 17 / SB 2.7 | JDK 21 / SB 3.x |
|---|---|---|
| Injection annotation | `javax.annotation.Resource` | `jakarta.annotation.Resource` |
| Web/filter | `javax.servlet.*` | `jakarta.servlet.*` |
| Validation | `javax.validation.*` | `jakarta.validation.*` |
| Authorization starter | `sa-token-spring-boot-starter` | `sa-token-spring-boot3-starter` |
| ORM starter | `mybatis-plus-boot-starter` | `mybatis-plus-spring-boot3-starter` |
| API docs | springdoc 1.x + `io.swagger.annotations` | springdoc 2.x + `io.swagger.v3.oas.annotations` |
| Redis configuration | `spring.redis.*` | `spring.data.redis.*` |
| Auto-configuration discovery | `spring.factories` | `AutoConfiguration.imports` |
| Type dispatch | `if/else` plus cast | `switch` pattern matching (JEP 441) |
| Deconstructing a record | getter per component | `instanceof Point(int x, int y)` (JEP 440) |
| First/last element | `list.get(0)` / `list.get(size()-1)` | `list.getFirst()` / `list.getLast()` (JEP 431) |
| Blocking-I/O concurrency | platform thread pool (`ThreadPoolExecutor`) | virtual threads (`spring.threads.virtual.enabled=true`) |
| Large critical sections | `synchronized` is fine | watch for virtual-thread pinning; use `ReentrantLock` |

---

## Appendix C: Cheat Sheet

**Standard skeleton for a new business module**

```
<service module>
  domain/Xxx.java                    # entity: @Data @TableName("tb_xxx")
                                     # date/time fields always LocalDateTime (no new Date)
  domain/dto/XxxDto.java             # inter-service transport
  domain/req/XxxReq.java             # request (extends the paging base for lists)
  domain/resp/XxxResp.java           # response
  mapper/XxxMapper.java              # extends BaseMapper<Xxx>
  service/IXxxService.java           # extends IService<Xxx>
  service/impl/XxxServiceImpl.java   # @Slf4j @Service
  resources/mapper/XxxMapper.xml     # BaseResultMap + Base_Column_List
<admin module>
  controller/XxxController.java      # @RestController + @Tag
```

**Controller template**

```java
@Operation(summary = "Paged query")                 // SB3: io.swagger.v3.oas.annotations
@PostMapping("/pageList")
@SaCheckPermission("order:order:pageList")          // Spring Security: @PreAuthorize
public PageResult<OrderResp> pageList(@RequestBody @Valid OrderQuery query) {
    return PageResult.build(orderService.pageList(query));
}
```

**Service validation and conversion**

```java
Assert.isNotNull(id, "ID must not be null");         // assertion → business exception
Order entity = orderMapper.selectById(id);
Assert.isNotNull(entity, "Record not found");
OrderResp resp = orderConverter.toResp(entity);      // MapStruct conversion
```

**Ten-line cheat sheet**

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

---

## Appendix D: Change Log

### D.1 Enhancements over the Alibaba *Java Development Manual* (Songshan edition)

| Chapter | Enhancement |
|---|---|
| 2 | **JDK 17–21 language features**: availability matrix, `var`, `record`, text blocks, `switch` expressions, `instanceof` pattern matching, `sealed`, immutable collections, Streams/Optional, compiler flags |
| 3 | **Spring Boot 3 backend engineering standard**: layering, controller/service/data access, unified response and exceptions, validation, transactions, caching and distributed locks, authorization, soft delete, dependency injection, configuration and observability |
| 5 | Unit testing upgraded to **JUnit 5** with Mockito and Testcontainers |
| 10 | **Spring Boot 2.7 → 3.x migration guide**: `javax`→`jakarta`, dependency coordinates, configuration and behavior changes, virtual threads, migration checklist |
| Appendix B | Migration tables (B.1 JDK 8→17, B.2 JDK 17→21 and SB 2.7→3) |

### D.2 Key hard rules (one-liner list)

- **Never `--enable-preview` in production.**
- On JDK 17, no virtual threads, `switch` pattern matching, record deconstruction, or sequenced collections.
- Compile with `<release>`, not `source`/`target`; SB3 requires `-parameters`.
- `record` is for value objects only — never an ORM entity.
- `var` only for local variables with an obvious type.
- `List.of/Map.of` are immutable and reject null.
- Never depend on `sun.*` internal APIs (JEP 403).
- All new date/time code uses `LocalDateTime`; never add a new `Date`.
- Keep helpful NPE messages enabled.

---

*Version: v1.0 (English edition)*
*Baseline: Java 17 / Java 21 ｜ Spring Boot 3.x (backward compatible with 2.7)*
*Chinese edition: `java-backend-standard.zh-CN.md`*
