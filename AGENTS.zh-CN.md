# Java 后端开发规范（AI 助手规则入口）

> 本文件是给 AI 编码助手读取的**精简规则**，供 Cursor / OpenCode / Codex / Copilot / Trae / Claude Code 等使用。
> **完整规范**：`docs/java-backend-standard.md`（技术栈、迁移指南、对照表都在里面）
> 技术基线：**Java 17 / Java 21 · Spring Boot 3.x**（向下兼容 2.7）
> 英文版见 `AGENTS.md`（IDE 默认自动读取的是英文版）。

## 一、强制红线（违反必有线上风险）

1. **生产禁用 `--enable-preview`**。预览特性会随版本变更或删除。
2. **JDK 17 上禁用**：虚拟线程、`switch` 模式匹配、`record` 解构、顺序集合 `getFirst/getLast`（均为 JDK 21 特性）。
   **JDK 21 上仍禁用**：字符串模板、结构化并发、作用域值、未命名变量（均为预览）。
3. 编译用 **`<release>`** 而非 `source/target`；**Spring Boot 3 必须加 `-parameters`**。
4. **`record` 只做值对象**，禁止做 ORM 实体（无无参构造 / 无 setter），禁止加 Lombok `@Data`。
5. **`var` 仅限局部变量**且右侧初始化即可明确类型；禁用于字段、参数、返回值、`null` 初始化。
6. **`List.of/Set.of/Map.of` 不可变且不允许 null**；需要可变用 `new ArrayList<>(List.of(...))`。
7. **禁止依赖 `sun.*` / `com.sun.*` 内部 API**（JDK 17 JEP 403 强封装）。
8. **时间类型：新代码一律 `LocalDateTime`**，禁止新增 `Date` 字段 / 参数 / 返回值；只需日期用 `LocalDate`，时间戳用 `Instant`。
9. SQL 参数用 `#{}`，**禁止 `${}`**；查询**显式列字段** + **必须带软删除条件**（`del_flag`）。
10. 事务 **`@Transactional(rollbackFor = Exception.class)`**，**事务内禁止 RPC / 远程调用 / 大文件 IO**。
11. 日志用占位符 `log.info("id={}", id)`；**禁止 `System.out.println` / `e.printStackTrace()`**。
12. `BigDecimal` 等值比较用 `compareTo()`，**禁止 `equals()`**；金额禁用 `float`/`double`。

## 二、编码惯例

- **命名**：类大驼峰；方法/变量小驼峰；常量全大写。分层命名全项目统一（`Xxx` / `XxxDto` / `XxxReq` / `XxxResp` / `XxxVo`），**不混用两套**。
- **格式**：4 空格缩进、禁 Tab、单行 ≤ 120、UTF-8、**LF 换行**。
- **统一返回**：Controller 返回统一响应体（`R<T>` / `Result<T>`）或分页响应体（`PageResult<T>`）；**禁止裸泛型、禁止拼 `Map`**。
- **异常**：业务异常用自定义异常（如 `ServiceException`），禁止 `throw new RuntimeException()`；Controller **不写 try-catch**，交给全局异常处理器。
- **校验**：JSR-303（`jakarta.validation.*`）+ 分组；简单前置条件用统一断言工具。
- **数据访问**：`LambdaQueryWrapper`；更新必须带 `update_time`，只更新变更字段。
- **依赖注入**：优先**构造器注入**，同一类**不混用**字段注入。
- **注解包名（SB3）**：`jakarta.annotation.*` / `jakarta.servlet.*` / `jakarta.validation.*`；API 文档用 `io.swagger.v3.oas.annotations`（`@Tag`/`@Operation`/`@Schema`）。
- **JDK 17+ 惯用法**：多分支用 `switch` 表达式（`->` / `yield`）；类型判断用 `instanceof` 模式匹配；多行 SQL/JSON 用文本块；`stream().toList()`；`Optional` 只作返回值。
- **并发**：线程池用 `ThreadPoolExecutor` 显式构造（禁 `Executors` 快捷方法）；`ThreadLocal` 必须 `remove()`；锁内禁止 RPC；`Lock.lock()` 在 try 外、`unlock()` 在 finally。
- **注释**：类注释含 `@author` / `@since`；枚举项必须注释业务含义；无用代码直接删除，不要注释保留。

## 三、速查口诀

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

## 四、不确定时怎么办

1. 先查 `docs/java-backend-standard.md` 对应章节（一 编程规约 / 二 JDK 特性 / 三 工程规范 / 十 SB2→3 迁移）。
2. 规范未覆盖时，**与现有代码保持一致**优先于个人偏好；不要在一个模块里引入第二套风格。
3. 判断「能否使用某语言特性」前，**先确认项目 JDK 版本**；不确定就按 JDK 17 的安全子集写。
4. 涉及架构取舍（选型、分层调整、依赖替换）时，提示记录 ADR，不要静默改动。
