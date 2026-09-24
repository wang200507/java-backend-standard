# Java 后端开发规范（通用版）

> **技术基线**：Java 17 / Java 21 · Spring Boot 3.x（向下兼容 2.7）· MyBatis-Plus · Maven 多模块
> **适用范围**：通用 Java 后端服务（Spring Boot 技术栈），不绑定任何具体业务项目
> **规约等级**：【强制】必须遵守，违反有线上风险 ｜【推荐】最佳实践，尽量遵守 ｜【参考】按需参考
> **来源**：阿里巴巴《Java 开发手册》嵩山版核心规约 + JDK 17/21 语言与 API 增强 + Spring Boot 3 迁移与工程实践
> **时效性**：标【JDK21】的条目需 JDK 21+；标【SB3】的条目需 Spring Boot 3.x。在低版本上使用会编译失败或行为不一致，**禁止提前使用**。

## 目录

- [一、编程规约](#一编程规约)
- [二、JDK 17–21 语言特性与最佳实践](#二jdk-1721-语言特性与最佳实践)
- [三、Spring Boot 3 后端工程规范](#三spring-boot-3-后端工程规范)
- [四、异常日志](#四异常日志)
- [五、单元测试](#五单元测试)
- [六、安全规约](#六安全规约)
- [七、MySQL 数据库](#七mysql-数据库)
- [八、工程结构与依赖管理](#八工程结构与依赖管理)
- [九、设计规约](#九设计规约)
- [十、Spring Boot 2.7 → 3.x 迁移指南](#十spring-boot-27--3x-迁移指南)
- [附录 A：错误码设计](#附录-a错误码设计)
- [附录 B：迁移对照表](#附录-b迁移对照表)
- [附录 C：速查表（Cheat Sheet）](#附录-c速查表cheat-sheet)
- [附录 D：变更说明](#附录-d变更说明)

---

## 一、编程规约

### 1.1 命名风格

1. 【强制】命名不能以下划线、美元符号开头或结尾；禁止拼音英文混合、直接中文命名（国际通用专有名词除外）。
2. 【强制】类名大驼峰 `UpperCamelCase`；方法、参数、成员变量、局部变量小驼峰 `lowerCamelCase`；常量全大写 + 下划线分隔。
3. 【强制】抽象类以 `Abstract` 开头；异常类以 `Exception` 结尾；测试类 = 被测类名 + `Test`。
4. 【强制】数组定义用 `int[] arrayDemo`，禁止 `String args[]`。
5. 【强制】POJO 布尔属性**禁止加 `is` 前缀**（`isSuccess` 这类会导致部分序列化框架解析错位）；数据库 `is_xxx` 字段通过 `resultMap` 映射到 `xxx` 属性。
6. 【强制】包名全小写、使用单数；禁止父子类成员重名、同方法内不同代码块局部变量重名。
7. 【强制】Service / Mapper（DAO）实现类统一后缀 `Impl`；Service 接口统一前缀 `I`（如 `IOrderService`）。
8. 【强制】禁止 `XxxNew`、`XxxTemp2`、`XxxUtils2` 这类临时命名；废弃类用 `@Deprecated` 并标注替代类，不靠后缀区分。
9. 【推荐】分层命名约定（全项目一致，**不要混用两套**）：

   | 分层 | 推荐命名 | 说明 |
   |---|---|---|
   | 数据库实体 | `Xxx` 或 `XxxDO` | 与表一一对应 |
   | 服务间传输 | `XxxDto` | 内部传输对象 |
   | 请求入参 | `XxxReq` / `XxxQuery` | Controller 接收 |
   | 响应出参 | `XxxResp` / `XxxVo` | 对外返回 |
   | 数据访问 | `XxxMapper` 或 `XxxDao` | 二选一，别混用 |

10. 【推荐】Service / Mapper 方法命名：取单个对象 `get`；取多个 `list`；计数 `count`；新增 `save`/`insert`；删除 `remove`/`delete`；修改 `update`。
11. 【参考】枚举类名后缀 `Enum`；枚举成员全大写、下划线分隔；**每个枚举项必须注释业务含义**。

### 1.2 常量定义

1. 【强制】禁止魔法值，必须预定义常量或枚举。
2. 【强制】`Long` 赋值用大写 `L`，禁止小写 `l`（易与数字 1 混淆）。
3. 【推荐】按业务域拆分常量类，不要用一个巨型 `Constants` 承载全部常量。
4. 【推荐】取值固定有限的集合优先用 `enum`；新增状态必须加枚举，禁止散落字符串。
5. 【推荐·JDK17】枚举需要多值关联时，用「带字段的枚举 + 静态 `Map` 查找」替代 `switch(name)` 与 `values()` 遍历。

### 1.3 代码格式

1. 【强制】空代码块直接 `{}`；非空代码块左大括号不换行，右大括号前换行；`else` 紧跟右大括号。
2. 【强制】缩进 **4 个空格，禁止 Tab**；用 `.editorconfig` 固化（`indent_style=space`、`indent_size=4`、`end_of_line=lf`、`charset=utf-8`）。
3. 【强制】`if/for/while/switch` 关键字与括号间加空格；双目、三目运算符左右加空格；强制转换 `(int) first` 括号与变量间无空格。
4. 【强制】单行字符数上限 120；超长时运算符、点号跟随下文，参数在逗号后换行，禁止括号前换行。
5. 【强制】文件编码 UTF-8，换行符 **LF**（禁止 CRLF，避免脚本失效、Diff 泛滥）。
6. 【推荐】单个方法不超过 80 行；不同业务逻辑之间空一行，禁止多个连续空行。
7. 【强制】禁止在 Controller 层写业务逻辑，严格执行分层。
8. 【推荐】重复代码抽取为公共方法并沉淀到公共模块，而不是复制三份。

### 1.4 OOP 规约

1. 【强制】静态变量 / 静态方法用**类名访问**，不用实例引用访问。
2. 【强制】重写方法必须加 `@Override`。
3. 【强制】对外暴露的接口禁止修改方法签名；废弃接口加 `@Deprecated` 并标注替代接口。
4. 【强制】包装类值比较必须用 `equals()`，禁止 `==`；推荐 `Objects.equals(a, b)`。
5. 【强制】金额以最小单位整型（分）存储，或 `BigDecimal` / `decimal` 列；禁止 `float`/`double` 表示金额。
6. 【强制】`BigDecimal` 等值比较用 `compareTo()`，**禁止 `equals()`**；禁止 `new BigDecimal(double)`，用 `new BigDecimal("0.1")` 或 `BigDecimal.valueOf(0.1)`。
7. 【强制】浮点数不用 `==` 判等；用误差阈值或 `BigDecimal`。
8. 【强制】POJO 属性、RPC 入参返回值用**包装类型**；局部变量优先基本类型。
9. 【强制】POJO 类**不要设置字段默认值**（避免更新时把未赋值字段覆盖成默认值）。
10. 【强制】POJO 必须实现 `toString`（用 Lombok `@Data` 自动生成即可，禁止 `isXxx()` 与 `getXxx()` 共存）。
11. 【强制】循环内字符串拼接用 `StringBuilder.append()` 或 `String.join`，禁止 `str = str + "x"`。
12. 【强制】访问权限从严：优先 `private`，其次 `protected`，谨慎 `public`。
13. 【强制·JDK17】**禁止依赖 JDK 内部 API**（`sun.*`、`com.sun.*`）与反射访问私有成员——Java 17 强封装（JEP 403）已默认禁止。确需 `--add-opens` 时必须在启动脚本显式声明并注释原因。
14. 【推荐·JDK17】「组合优于继承」同时，用 `final` 修饰类与不可变字段缩小继承面；需要精确控制可继承者时用 `sealed`（见 [2.7](#27-sealed-密封类接口)）。

### 1.5 日期时间

1. 【强制】pattern 中**年份必须小写 `yyyy`**，禁止大写 `YYYY`（周年份会跨年出错）；区分 `M` 月 / `m` 分、`H` 24 小时 / `h` 12 小时。
2. 【强制】新代码一律用 `java.time`（`LocalDateTime`），**禁止新增 `Date` 字段 / 参数 / 返回值**：
   - 只需日期用 `LocalDate`，时间戳用 `Instant`，时长用 `Duration`；
   - 统一加 `@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")`（或全局配置），保持一致；
   - 与 `java.util.Date` 互转**只在边界**（老接口 / 第三方 SDK）发生：`Date.from(instant)`、`localDateTime.atZone(ZoneId.systemDefault()).toInstant()`；
   - 存量 `Date` 随模块重构**逐步迁移**，同一语义字段禁止两套类型长期共存。
3. 【强制】禁止 `java.sql.Date` / `java.sql.Time` / `java.sql.Timestamp`；禁止 `Calendar`。
4. 【强制】获取当前毫秒用 `System.currentTimeMillis()` 或 `Instant.now()`，不要 `new Date().getTime()`。
5. 【强制】`SimpleDateFormat` 禁止 `static`（线程不安全）；**`DateTimeFormatter` 线程安全，可定义为 `static final` 常量**。
6. 【推荐·JDK17】时间差用 `ChronoUnit.DAYS.between(a, b)`，不要手写 `(t2 - t1) / 86400000`；禁止硬编码 365 天，用 `LocalDate.now().lengthOfYear()`。
7. 【推荐】格式常量集中定义，避免到处写 pattern 字符串：
   ```java
   public static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
   ```

### 1.6 集合处理

1. 【强制】覆写 `equals` 必须覆写 `hashCode`；`Set` 存对象、`Map` 自定义 key 必须同时覆写。
2. 【强制】判空用 `isEmpty()` 而非 `size() == 0`。
3. 【强制】`Collectors.toMap()` 必须传合并函数（key 重复会抛异常），value 不能为 null（会 NPE）；推荐 `toMap(k, v, (a, b) -> a, LinkedHashMap::new)`。
4. 【强制】`ArrayList.subList` 返回的是**内部视图**，不能强转 `ArrayList`；父集合增删会导致遍历抛 `ConcurrentModificationException`。
5. 【强制】`Map#keySet/values/entrySet` 返回集合不允许 `add`。
6. 【强制】集合转数组用 `list.toArray(new String[0])`，禁止无参 `toArray()` 再强转。
7. 【强制】`Arrays.asList()` 结果不支持 `add/remove/clear`，底层仍绑定原数组。
8. 【强制】**foreach 中禁止集合 `add / remove`**；删除元素用 `Iterator` 或 `removeIf`。
9. 【强制】集合初始化尽量指定容量；`HashMap` 初始容量 = `(预计元素数 / 0.75) + 1`。
10. 【推荐】Map 遍历优先 `entrySet`，避免 `keySet` 二次取值。
11. 【推荐】泛型遵循 PECS：`<? extends T>` 只读，`<? super T>` 只写。
12. 【推荐·JDK17】元素少且确定时用 `List.of()/Set.of()/Map.of()` 创建**不可变集合**；⚠️ 它们**不允许 null 元素**，且不可变（需可变用 `new ArrayList<>(List.of(...))`）。
13. 【推荐·JDK16+】`stream().collect(Collectors.toList())` 可简化为 `stream().toList()`（返回**不可变**列表）；需要可变集合仍用 `Collectors.toCollection(ArrayList::new)`。

| 集合类型 | key 可为 null | value 可为 null | 备注 |
|---|---|---|---|
| `HashMap` | ✅ | ✅ | 线程不安全 |
| `ConcurrentHashMap` | ❌ | ❌ | 线程安全 |
| `Hashtable` | ❌ | ❌ | 已过时 |
| `TreeMap` | ❌ | ✅ | 有序，线程不安全 |
| `List.of / Map.of` | ❌ | ❌ | 任何 null 元素抛 NPE |

### 1.7 并发处理

1. 【强制】自定义线程 / 线程工厂必须设置有意义的线程名，便于 `jstack` 排查。
2. 【强制】业务线程必须由线程池提供，禁止业务代码 `new Thread()`。
3. 【强制】禁止用 `Executors` 快捷方法创建线程池（`newFixedThreadPool`/`newCachedThreadPool` 均可能 OOM），必须用 `ThreadPoolExecutor` 显式构造。
4. 【强制】`ThreadLocal` 用完必须 `remove()`，放在 `try-finally`；线程池场景尤需注意内存泄漏。
5. 【强制】锁粒度尽量小，优先锁代码块而非整个方法；**锁内禁止调用 RPC 远程接口**。
6. 【强制】多对象 / 多表加锁保持统一顺序，防死锁。
7. 【强制】`Lock.lock()` 写在 `try` 块**外**，`unlock()` 放 `finally`。
8. 【强制】定时任务禁止 `Timer`，用 `ScheduledExecutorService` 或调度框架。
9. 【强制】双重检查锁单例，成员变量必须 `volatile`。
10. 【强制】`volatile` 只解决可见性；`count++` 等复合操作不保证原子性，计数用 `AtomicInteger` / `LongAdder`。
11. 【推荐】并发更新冲突概率 < 20% 用乐观锁 `version`；资金敏感场景强制悲观锁。
12. 【推荐】多线程不共用 `Random` 实例，用 `ThreadLocalRandom`；JDK 17+ 可统一走 `RandomGenerator`。
13. 【推荐】多步异步编排用 `CompletableFuture`，避免手工 `Future.get()` 串行阻塞；**必须**处理异常（`exceptionally/handle`）并显式传入自定义线程池，**禁止**用 `ForkJoinPool.commonPool()` 跑阻塞 IO。
14. 【强制·JDK17】**Java 17 没有虚拟线程**（JDK 21 才正式）。17 上高并发 IO 仍用「合理配置的线程池 + 异步编排」；升级到 21 后参考 [10.4](#104-虚拟线程实践jdk-21) 逐步启用。

### 1.8 控制语句

1. 【强制】`switch` 每个 `case` 必须有 `break/continue/return` 或明确注释穿透；必须含 `default`。
2. 【强制】`switch` 入参为 `String` 时必须提前判 `null`。
3. 【强制】`if/for/while/do-while` 即使只有一行，也必须用大括号。
4. 【强制】三目运算符警惕自动拆箱 NPE。
5. 【强制】高并发场景不用 `==` 作为循环退出条件，改用区间判断。
6. 【推荐】用卫语句提前 `return` 减少嵌套；嵌套层数不超过 3 层。
7. 【推荐】复杂条件提前赋给语义化布尔变量；禁止在条件表达式中写赋值语句。
8. 【推荐·JDK17】多分支赋值 / 映射用 **switch 表达式**（`->` + `yield`）替代冗长 if-else 链，见 [2.5](#25-switch-表达式与箭头语法)。
9. 【推荐·JDK17】类型判断 + 强转用 **`instanceof` 模式匹配**，见 [2.6](#26-instanceof-模式匹配)。

### 1.9 注释规约

1. 【强制】类、类属性、公共方法用 Javadoc `/** */`，不用单行 `//`。
2. 【强制】接口方法、抽象方法必须写 Javadoc，说明功能、参数、返回值、异常。
3. 【强制】类注释必须含 `@author`、`@since`。
4. 【强制】枚举每个枚举项必须注释业务含义。
5. 【强制】改代码同步改注释；**无用代码直接删除，不要注释保留**；`TODO`/`FIXME` 需写标记人与时间。
6. 【推荐】注释语言全项目统一；对外接口的 API 文档描述与代码注释保持一致，避免两套说法。

### 1.10 接口与前后端

1. 【强制】生产环境 API 必须 HTTPS；URL 路径用名词复数、小写 + 中划线或下划线分隔，禁止 `.json` 等后缀。
2. 【强制】查询列表为空时返回 `[]` 而非 `null`，减少前端判空。
3. 【强制】错误响应含四要素：HTTP 状态码、`errorCode`、`errorMessage`、用户友好提示。
4. 【强制】JSON 返回 key 全部小驼峰 `lowerCamelCase`。
5. 【强制】超大 `Long`（订单号、流水号，超过 2^53）返回前端必须转 `String`，避免 JS `Number` 精度丢失（`@JsonSerialize(using = ToStringSerializer.class)`）。
6. 【强制】URL Query 参数总长度不超过 2048 字节，大参数放 body。
7. 【推荐】分页参数：`pageNo < 1` 取第一页；`pageNo` 超过总页数返回最后一页。
8. 【推荐】程序内部跳转用 `forward`；外部重定向 URL 统一由代理模块生成并做白名单校验。

### 1.11 其他

1. 【强制】正则 `Pattern` 预编译为 `static` 常量，不要每次在方法体内 `compile`（防 ReDoS 与性能问题）。
2. 【强制】禁止用 `Apache Commons BeanUtils` 做对象拷贝；用 Spring `BeanUtils`、Cglib `BeanCopier` 或 MapStruct。
3. 【推荐·JDK17】字符串能力优先原生 API，少引工具类：`isBlank()`、`strip()`、`repeat(n)`、`lines()`、`formatted(...)`、`String.join`。
4. 【强制】禁止 `System.setSecurityManager`（JDK 17 已弃用待移除）；安全能力下沉到框架层。

---

## 二、JDK 17–21 语言特性与最佳实践

> 本章目标：**正确地**使用现代语法——既不「用着 17/21 写着 8 的代码」，也不为了新而新。

### 2.1 语言特性可用性对照

| 特性 | 正式版本 | Java 17 | Java 21 | 建议 |
|---|---|---|---|---|
| 局部变量 `var` | 10 | ✅ | ✅ | 谨慎用，见 2.2 |
| 文本块 `"""` | 15 | ✅ | ✅ | 推荐（SQL/JSON） |
| `switch` 表达式（`->`/`yield`） | 14 | ✅ | ✅ | 推荐 |
| `instanceof` 模式匹配 | 16 | ✅ | ✅ | 推荐 |
| `record` 记录类 | 16 | ✅ | ✅ | 推荐（值对象） |
| `sealed` 密封类/接口 | 17 | ✅ | ✅ | 领域建模时用 |
| `Stream.toList()` | 16 | ✅ | ✅ | 推荐 |
| `HexFormat` | 17 | ✅ | ✅ | 推荐（字节转十六进制） |
| 增强 NPE 信息 | 14/15 | ✅ 默认开启 | ✅ | 保持开启 |
| **`switch` 模式匹配** | 21 | ❌ 仅预览 | ✅ | 17 禁用；21 推荐 |
| **`record` 解构** | 21 | ❌ | ✅ | 17 禁用；21 推荐 |
| **虚拟线程** | 21 | ❌ | ✅ | 17 禁用；21 谨慎启用，见 [10.4](#104-虚拟线程实践jdk-21) |
| **顺序集合** | 21 | ❌ | ✅ | 17 禁用；21 推荐 |
| 字符串模板 `STR."..."` | 预览 | ❌ | ❌ 仅预览 | **禁用** |
| 结构化并发 / 作用域值 | 预览 | ❌ | ❌ 仅预览 | **禁用** |
| 未命名变量 `_` | 预览 | ❌ | ❌ 仅预览 | **禁用** |

> 🔴 **【强制】生产环境禁止使用 `--enable-preview`**。预览特性可能在下一版本变更或删除，会导致升级时无法编译。
> ⚠️ **【强制】标 ❌ 的特性在对应 JDK 上禁止使用**：JDK 17 上不得用虚拟线程 / switch 模式匹配 / record 解构 / 顺序集合；JDK 21 上仍不得用字符串模板、结构化并发、作用域值、未命名变量。

### 2.2 局部变量类型推断 `var`

- 【推荐】仅在**局部变量**且**右侧初始化即可明确类型**时使用：
  ```java
  var userList = userService.listByIds(ids);                          // ✅ 类型显而易见
  var formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"); // ✅
  ```
- 【强制】禁止用于：字段、方法参数、方法返回值、`null` 初始化、链式调用后类型不清晰处：
  ```java
  var result = service.doBiz();   // ❌ 无法一眼看出类型
  var x = null;                   // ❌ 无法编译
  ```
- 【强制】禁止 `var` 与泛型钻石、Lambda 混用导致推断不明确。

### 2.3 `record` 记录类

- 【推荐】用于**不可变的值载体**：只读 VO/Resp、配置项、方法内临时聚合、Map 的 entry 语义对象。
  ```java
  public record UserBrief(Long id, String name) { }
  ```
- 【强制】`record` **不能**作为 ORM 实体（无无参构造、无 setter）。
- 【强制】`record` 不加 Lombok `@Data`（冲突），也不加 setter。
- 【推荐】需要校验用**紧凑构造器**：
  ```java
  public record PageParam(int pageNum, int pageSize) {
      public PageParam {
          if (pageNum < 1 || pageSize < 1) {
              throw new IllegalArgumentException("分页参数不合法");
          }
      }
  }
  ```
- 【强制】对外返回 `record` 需确认序列化框架支持（Jackson ≥ 2.12 原生支持；Spring Boot 3 自带 Jackson 2.15+，无问题）。

### 2.4 文本块 Text Blocks

- 【推荐】用于多行 SQL、JSON、Shell、测试数据，替代 `"\n"` 拼接。
  ```java
  String sql = """
          SELECT id, name, create_time
          FROM tb_order
          WHERE status = ?
          """;
  ```
- 【强制】文本块内不用 `\t` 混排；缩进以「闭合 `"""` 的位置」为基准，避免意外产生大量前导空格。
- 【强制】内容含 `"""` 或需转义 `\` 时，评估改用普通字符串或参数拼装。
- ⚠️ ORM 的 XML 映射文件不适用（那是 XML）；文本块用于 Java 代码内嵌 SQL/JSON。

### 2.5 `switch` 表达式与箭头语法

- 【推荐】用箭头语法与 `yield` 消除穿透与 `break`：
  ```java
  String label = switch (status) {
      case 0, 1 -> "待处理";
      case 2 -> "处理中";
      case 3 -> {
          log.info("已完结 status={}", status);
          yield "已完成";          // 代码块分支用 yield 返回值
      }
      default -> throw new ServiceException("未知状态：" + status);
  };
  ```
- 【强制】`switch` 表达式必须穷尽分支：枚举全覆盖 + `default` 兜底（防新增枚举值静默走空）。
- 【强制】箭头语法分支内**不允许** `break/continue/return`。
- 【推荐】把「枚举 → 文案/码值」的映射收敛到枚举内部静态方法，而非散落各处写 `switch`。

### 2.6 `instanceof` 模式匹配

- 【推荐】用模式匹配替代「判断 + 强转」：
  ```java
  // ✅ JDK 16+
  if (obj instanceof SysUser user) {
      return user.getNickName();
  }
  // ❌ 旧写法
  if (obj instanceof SysUser) {
      SysUser user = (SysUser) obj;
      ...
  }
  ```
- 【强制】模式变量作用域：`if (a instanceof T t && t.check())` 中 `t` 仅在条件为真后可见，不要在 `else if` 之外引用。

### 2.7 `sealed` 密封类/接口

- 【参考】领域模型「类型集合固定、需穷尽判断」时，用 `sealed` 明确可继承者：
  ```java
  public sealed interface PayChannel permits WechatPay, AlipayPay, UnionPay { }
  public final class WechatPay implements PayChannel { }
  ```
- 【强制】sealed 的许可子类必须显式 `final` / `sealed` / `non-sealed`。
- 【参考】表达固定枚举集合**优先用枚举**；`sealed` 用于「需携带不同数据结构的类型族」，不要为了新特性替换枚举。

### 2.8 不可变集合工厂

- 【推荐】固定内容的小集合用 `List.of/Set.of/Map.of`，比 `new ArrayList<>` + `add` 更简洁安全。
- 【强制】⚠️ 工厂集合**不可变且不允许 null**：`List.of(a, null)` 直接 NPE；`Set.of/Map.of` 的 key 不允许重复。
- 【强制】不要把 `List.of(...)` 结果当可变集合传给下游做增删（会 `UnsupportedOperationException`）。
- 【强制】对外返回集合推荐 `List.copyOf` / `Collections.unmodifiableList` 做防御性拷贝。

### 2.9 Stream 与 Optional 现代用法

- 【推荐】`stream().toList()` 替代 `collect(Collectors.toList())`。
- 【强制】`Stream` 嵌套不超过 2 层，复杂逻辑抽为方法；流操作内禁止写带副作用的复杂逻辑。
- 【推荐】`Collectors.groupingBy` / `partitioningBy` / `teeing` 处理分组统计，替代手工 `Map` 累加。
- 【强制】`parallelStream()` 谨慎使用：仅在**纯计算、无阻塞、无共享可变状态**且数据量足够大时使用；涉及数据库/远程调用、`ThreadLocal`、事务上下文时**禁止**。
- 【推荐】`Optional` 用于表达「可能没有结果」的**返回值**：
  ```java
  return Optional.ofNullable(userMapper.selectById(id))
          .map(User::getDeptId)
          .orElseThrow(() -> new ServiceException("用户不存在"));
  ```
- 【强制】`Optional` **禁止**用作字段类型、方法参数、集合元素、`Map` 的 value；**禁止** `get()` 不做 `isPresent` 判断（用 `orElseThrow`）。
- 【强制】`Optional` 不要滥用，能一处判空解决的就别包一层。

### 2.10 增强的 NPE 信息

- 【推荐】保持 helpful NPE 开启（JDK 15+ 默认）。异常信息会指出「哪个变量/方法调用为 null」，排查效率大幅提升。
- 【参考】日志中出现 `Cannot invoke "..." because "..." is null` 即 helpful NPE，**不要**关闭它。

### 2.11 编译与 JVM 参数

- 【强制】`maven-compiler-plugin` 用 `<release>` 替代 `source/target`，避免误用高于目标版本的 API：
  ```xml
  <configuration>
      <release>21</release>
      <encoding>UTF-8</encoding>
      <compilerArgs>
          <arg>-parameters</arg>   <!-- Spring Boot 3 必需 -->
      </compilerArgs>
  </configuration>
  ```
- 【强制】生产禁用 `--enable-preview`。
- 【强制】生产 `-Xms` 与 `-Xmx` 设置相同，避免 GC 时堆扩容。
- 【强制】JVM 必须加 `-XX:+HeapDumpOnOutOfMemoryError`，OOM 自动输出 dump。
- 【推荐】默认 G1 GC；低延迟敏感服务可评估 ZGC（JDK 21 推荐 **Generational ZGC**：`-XX:+UseZGC -XX:+ZGenerational`）。
- 【强制】升级 JDK 前用 `jdeps --multi-release <N>` 扫描内部 API 依赖；清理启动脚本中已移除的参数（如 `-XX:+UseBiasedLocking`，15 已移除）。

---

## 三、Spring Boot 3 后端工程规范

### 3.1 分层与包结构

```
<root>（pom 聚合，Maven 多模块）
├── <app>-admin     —— 启动/Web 层：controller、job、config
├── <app>-service   —— 业务/持久层：domain、mapper、service、framework
└── <app>-common    —— 公共层：core、enums、exception、utils、constant
```

- 【强制】严格分层：`Controller → Service → Mapper/Repository → DB`。
- 【强制】`Controller` 只做：接收参数、校验、调 Service、封装返回；**禁止**写业务逻辑、禁止直接调 Mapper。
- 【强制】模块依赖单向：`admin → service → common`；**禁止反向依赖**，禁止公共模块依赖业务模块。
- 【推荐】包命名 `com.<company>.<app>.<域>.<分层>`，全小写单数。

### 3.2 Controller 规范

1. 【强制】类上 `@RestController` + `@RequestMapping("/xxx")`（路径小写、名词复数）。
2. 【强制】返回值统一走**统一响应体**（如 `R<T>` / `Result<T>`）或**分页响应体**（如 `TableDataInfo<T>` / `PageResult<T>`）；**禁止返回裸泛型缺失类型**，**禁止**在 Controller 里手拼 `Map` 当响应体。
3. 【强制】鉴权注解必须显式声明，缺省不放开：Sa-Token 用 `@SaCheckPermission("模块:业务:动作")`，Spring Security 用 `@PreAuthorize("hasAuthority('...')")`。
4. 【推荐】读操作上分页查询，写操作加防重复提交（如 `@RepeatSubmit`）与限流（如 `@RateLimiter`）。
5. 【强制】Controller 里**不写 `try-catch`**，异常交给全局异常处理器统一转换。
6. 【推荐】接口路径与权限串命名保持一致：`/order/batchAdd` ↔ `order:order:batchAdd`。
7. 【强制·SB3】API 文档注解用 `io.swagger.v3.oas.annotations`（`@Tag`/`@Operation`/`@Schema`），**不再使用** `io.swagger.annotations`（1.x 的 `@Api`/`@ApiOperation`）。

### 3.3 Service 规范

1. 【强制】接口命名 `IXxxService`，实现 `XxxServiceImpl`。
2. 【强制】业务断言统一走**项目统一的断言工具**，不要散落 `if (...) throw new RuntimeException(...)`。
   ```java
   Assert.isNotNull(req.getSupplierId(), "供应商ID不能为空");
   Assert.isTrue(ids.size() == depts.size(), "部分供应商不存在，请检查后重新添加");
   ```
3. 【强制】对象转换统一用 MapStruct / `BeanUtils` / 项目统一工具，禁止手写逐字段 `set`（除需特殊加工）。
4. 【强制】跨服务编排放在 Service 层，不出现在 Controller 或 Mapper。
5. 【推荐】每个方法单一职责；复杂方法拆为私有方法，主流程用注释分节。

### 3.4 数据访问层规范

1. 【强制】Mapper 继承 MyBatis-Plus `BaseMapper<T>`（或项目封装的 `BaseMapperPlus<M,T,V>`），复用通用能力。
2. 【强制】查询条件用 `LambdaQueryWrapper` / `Wrappers.query()`，**禁止**硬编码字符串列名拼接。
3. 【强制】XML 中定义 `resultMap` + `<sql id="Base_Column_List">`；查询**显式列出字段**，**禁止 `SELECT *`**。
4. 【强制】动态参数用 `#{}`，**禁止 `${}`**（SQL 注入）。
5. 【强制】软删除条件（如 `del_flag = '0'`）**必须显式带上**；若未全量启用 `@TableLogic`，每处查询都要自查，漏带会查出已删数据。
6. 【强制】更新操作必须更新 `update_time`；只更新变更字段，不要全字段覆盖。
7. 【强制】分页统一走项目分页对象（如 `PageQuery`）构建，内含排序字段校验与防注入；返回统一分页响应体。
8. 【推荐】复杂多表查询评估是否该下沉为视图或引入搜索引擎，避免超长 SQL。

### 3.5 统一返回与异常

1. 【强制】成功返回统一结构（如 `R.ok(data)`）；失败抛业务异常，由全局处理器转成统一结构。
2. 【强制】业务异常用**自定义业务异常**（如 `ServiceException`），**禁止**直接抛 `RuntimeException` / `Exception`。
3. 【强制】分页列表返回分页响应体，不要手工拼 `total/rows`。
4. 【推荐】错误码语义见 [附录 A](#附录-a错误码设计)；错误码用于程序识别，**不可直接展示给终端用户**。

### 3.6 参数校验

1. 【强制】入参对象用 JSR-303（`jakarta.validation`）注解：`@NotNull`/`@NotBlank`/`@Size`/`@Valid`，并用**校验分组**区分新增/编辑/查询场景。
2. 【推荐】简单前置条件用断言工具；复杂表单用 `@Valid` + 分组。二选一，全项目保持一致。
3. 【强制】所有用户传入参数做有效性校验，防 SSRF、ReDoS、反序列化漏洞（见第六章）。
4. 【强制·SB3】校验注解包名为 `jakarta.validation.*`（原 `javax.validation.*`）。

### 3.7 事务

1. 【强制】`@Transactional(rollbackFor = Exception.class)`，**必须**指定 `rollbackFor`（默认只回滚 `RuntimeException`）。
2. 【强制】事务方法只包裹必要的 DB 操作；**禁止**在事务内做 RPC / 远程调用 / 大文件 IO（长事务锁表、拖垮连接池）。
3. 【强制】`@Transactional` 只在 `public` 方法生效；**同类内部调用（`this.xxx()`）不生效**，需自注入或拆到另一个 Bean。
4. 【参考】只读操作显式 `@Transactional(readOnly = true)` 可优化。
5. 【推荐】事务中 `catch` 异常后若仍需回滚，手动执行 `TransactionAspectSupport.currentTransactionStatus().setRollbackOnly()`。

### 3.8 缓存与分布式锁

1. 【强制】跨节点并发用分布式锁（Lock4j `@Lock4j` / Redisson），**禁止**用 `synchronized` / `ReentrantLock` 处理多实例并发。
2. 【强制】缓存 key 统一收敛到常量类，格式 `模块:业务:标识`，禁止裸字符串散落各处。
3. 【推荐】缓存更新用「先更新 DB，再删除缓存」；避免大 key / 热点 key；必须设置过期时间。
4. 【强制】缓存穿透/击穿/雪崩要显式防护（空值缓存、互斥重建、过期时间加随机抖动）。

### 3.9 鉴权与当前用户

1. 【强制】获取当前用户走统一入口（RuoYi 风格的 `LoginHelper.getLoginUser()`，或 Spring Security 的 `SecurityContextHolder`），并**判空**处理登录失效。
2. 【强制】权限点必须与鉴权注解串一致，禁止跳过鉴权直接写业务。
3. 【强制】敏感操作（导出、删除、资金）必须二次校验**数据权限**（水平越权防护）。

### 3.10 公共字段与软删除

1. 【强制】新增/更新自动填充 `createBy/createTime/updateBy/updateTime`（MyBatis-Plus `MetaObjectHandler` 或审计机制）。
2. 【强制】业务数据用软删除标记（`del_flag` 字段 + 对应枚举）而非物理删除，除明确要求。
3. 【参考】`del_flag` 字段类型与删除值全项目必须统一（`tinyint(0/1)` 或 `varchar('0'/'2')`），新表沿用既有风格。

### 3.11 依赖注入

1. 【推荐】优先**构造器注入**（Spring 官方推荐：便于测试、可 `final`、能暴露循环依赖）。
2. 【强制】**禁止**在同一类里混用构造器注入与字段注入两种风格；全项目保持一致。
3. 【强制】禁止 `new` 一个 Service 来调用业务方法，必须由容器注入。
4. 【强制·SB3】注入与生命周期注解包名变更：`javax.annotation.Resource` → `jakarta.annotation.Resource`；`@PostConstruct`/`@PreDestroy` 同理。
5. 【强制·SB3】默认**禁止循环依赖**（`spring.main.allow-circular-references=false`），同类自注入需改造成独立 Bean。

### 3.12 配置与可观测性

1. 【强制】配置外置：不同环境用 `application-{env}.yml` 或配置中心；**禁止硬编码**密钥、数据库密码到代码。
2. 【强制】敏感配置用环境变量或配置中心加密存储；**禁止**提交真实凭据到仓库。
3. 【推荐】用 `@ConfigurationProperties` 绑定结构化配置，优于散落 `@Value`；配合 `@Validated` 做启动期校验。
4. 【强制·SB3】自动配置注册从 `META-INF/spring.factories` 改为 `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`（自研 starter 必须改写）。
5. 【推荐】开启 Actuator 健康检查与指标；生产环境只暴露必要端点（`management.endpoints.web.exposure.include` 白名单）。
6. 【推荐】关键链路加 traceId（MDC 或链路追踪），便于日志串联排查。

---

## 四、异常日志

### 4.1 错误码

1. 【强制】错误码结构统一（如 5 位：`来源标识 + 四位数字编号`）——`A`：用户侧错误；`B`：系统内部错误；`C`：调用第三方错误。
2. 【强制】业务成功统一返回 `00000`。
3. 【强制】错误码用于程序识别，**不能直接展示给终端用户**。

### 4.2 异常处理

1. 【强制】可预检查的 `RuntimeException`（NPE、数组越界）不要 `catch`，提前 `if` 判断规避。
2. 【强制】异常不能作为业务流程控制手段。
3. 【强制】禁止超大范围 `try-catch`；细分捕获异常类型。
4. 【强制】捕获异常必须处理（记日志或转换重抛），最外层入口必须完成异常转换（全局异常处理器）。
5. 【强制】资源流关闭放 `finally`；JDK 7+ 优先 **try-with-resources**；**`finally` 块禁止写 `return`**。
6. 【强制】RPC 调用、二方包反射调用捕获异常用 `Throwable`。
7. 【强制】业务异常优先用自定义业务异常，**禁止**直接抛 `new RuntimeException()`。
8. 【推荐·JDK17】`switch` 中表达「不可能发生」的分支，抛 `IllegalStateException` 或自定义异常，让问题暴露，而非静默返回 null。
9. 【推荐】NPE 风险点（包装类拆箱、级联 get、远程调用返回 null）用 `Optional` 或提前判空防护，见 [2.9](#29-stream-与-optional-现代用法)。

### 4.3 日志规约

1. 【强制】用 SLF4J（Lombok `@Slf4j`），不要直接依赖 logback/log4j 实现类。
2. 【强制】日志用**占位符**：`log.info("orderId={}", orderId)`；禁止字符串拼接。
3. 【强制】`debug/trace` 输出前先判断 `log.isDebugEnabled()`。
4. 【强制】**禁止** `System.out.println`、`e.printStackTrace()`。
5. 【强制】异常日志同时打印**入参 + 异常堆栈**；不要直接 JSON 序列化对象，调用其 `toString`。
6. 【强制】生产关闭 debug；业务参数错误用 `warn`；`error` 只记录系统故障异常。
7. 【强制】打印敏感信息（手机号/身份证/金额）必须脱敏；日志中禁止出现明文密码、token。
8. 【强制】日志保存周期：普通日志 ≥ 15 天；安全、敏感操作日志 ≥ 6 个月，多机备份。

---

## 五、单元测试

> 测试框架统一 **JUnit 5 (Jupiter)** + Mockito；集成测试可用 Testcontainers。

1. 【强制】**AIR 三原则**：Automatic 自动化执行 / Independent 用例互相独立 / Repeatable 可重复执行。
2. 【强制】禁止用 `System.out` 做结果校验，必须用断言（`Assertions.*`）。
3. 【强制】外部依赖（DB、Redis、RPC、三方）用 Mock；单元测试不依赖真实外部环境。
4. 【强制】测试代码固定 `src/test/java`，不放业务源码目录。
5. 【推荐】**BCDE 原则**：Border 边界值 / Correct 正确输入 / Design 结合设计文档 / Error 异常错误输入。
6. 【推荐】覆盖率：普通模块语句覆盖率 ≥ 70%；核心业务模块语句与分支覆盖率 100%。
7. 【推荐·JUnit5】
   - `@DisplayName` 写中文用例描述，`@Nested` 组织场景，`@ParameterizedTest` + `@ValueSource/@CsvSource` 覆盖边界。
   - 断言用 `assertAll(...)` 聚合；异常断言用 `assertThrows(ServiceException.class, () -> ...)`。
   - 生命周期用 `@BeforeEach/@AfterEach`；测试类与用例可不加 `public`。
   - `@Disabled("原因")` 必须写原因，禁止遗留无说明的跳过用例。
   - 用 `@Tag` 区分「单元测试」与「集成测试」，与 Maven `groups/excludedGroups` 对齐。

---

## 六、安全规约

1. 【强制】用户私有数据访问必须做**水平权限校验**，防越权。
2. 【强制】返回前端的敏感数据（手机号、身份证、银行卡）必须脱敏。
3. 【强制】SQL 禁止字符串拼接，全部参数绑定，防 SQL 注入。
4. 【强制】所有用户传入参数做有效性校验，防 SSRF、ReDoS、反序列化漏洞。
5. 【强制】用户输入输出到 HTML 页面必须转义过滤；表单与 AJAX 接口开启 CSRF 校验。
6. 【强制】外部跳转目标地址执行**白名单**；短信、验证码接口做频率防刷。
7. 【强制·JDK17】禁止依赖 JDK 内部 API 与不安全反射（JEP 403 强封装）；避免 `ObjectInputStream` 直接反序列化不可信数据（反序列化漏洞高发）。
8. 【强制】加解密/哈希必须用标准库或国密合规实现，**禁止自造算法**、**禁止硬编码密钥**到代码。
9. 【强制】接口鉴权与数据权限双校验；文件上传校验类型、大小、内容，并做存储隔离。

---

## 七、MySQL 数据库

### 7.1 建表规约

1. 【强制】布尔逻辑字段命名 `is_xxx`，类型 `unsigned tinyint`，1 是 0 否。
2. 【强制】表名、字段名全小写，禁止数字开头，规避 MySQL 保留关键字。
3. 【强制】表名用单数；索引命名 `pk_` 主键、`uk_` 唯一索引、`idx_` 普通索引。
4. 【强制】金额强制 `decimal`，禁止 `float`/`double`。
5. 【强制】`varchar` 最大 5000，超阈值用 `text` 并拆独立子表。
6. 【强制】每张业务表必备三字段：`id bigint unsigned` 主键自增、`create_time datetime`、`update_time datetime`。
7. 【推荐】预估单表 > 500 万行或 > 2GB 时，再评估分库分表。

### 7.2 索引规约

1. 【强制】业务唯一约束字段必须建唯一索引，不要只靠应用层校验。
2. 【强制】`join` 表数不超过 3 张；关联字段类型严格一致且必须建索引。
3. 【强制】`varchar` 建索引需指定前缀长度。
4. 【强制】`like` 禁止左模糊 `%xxx`；全文检索用搜索引擎而非 `like`。
5. 【推荐】`order by` 排序字段放联合索引末尾；范围条件之后的索引列失效。
6. 【推荐】尽量覆盖索引避免回表（`explain` 的 Extra 显示 `Using index`）。
7. 【推荐】超大 `offset` 分页用延迟关联子查询优化。
8. 【推荐】联合索引等值条件字段放最左侧；防隐式类型转换导致索引失效。

### 7.3 SQL 语句

1. 【强制】统计行数用 `count(*)`，不要 `count(列名)`。
2. 【强制】`sum` 聚合可能返回 null，用 `IFNULL(SUM(col), 0)` 包装。
3. 【强制】NULL 判断用 `ISNULL()`；禁止 `= null`、`!= null`。
4. 【强制】禁止数据库外键约束与级联更新删除，全部业务层处理；禁止存储过程。
5. 【强制】多表查询字段必须带表别名限定；禁止 `select *`。
6. 【强制】`in` 集合元素控制在 1000 以内；业务代码禁止 `truncate table`。

---

## 八、工程结构与依赖管理

### 8.1 应用分层

```
开放 API 层 / 终端显示层
  → Web 请求处理层（Controller）
  → Service 业务逻辑层
  → Manager 通用逻辑层（缓存、第三方、多 Mapper 组装）
  → Mapper/DAO 持久层
  → 存储 / 第三方服务
```

- Web 层：请求转发、参数校验、简单处理。
- Service 层：业务逻辑实现。
- Manager 层：封装第三方服务、缓存逻辑、多 Mapper 组装。
- Mapper 层：数据库交互。

【强制】Query 参数大于 2 个禁止用 `Map` 传输，必须封装请求对象。

**异常分层处理**：
1. DAO 捕获异常封装为 DAO 异常，不打印日志、向上抛出；
2. Service 捕获并打印完整日志（或直接抛业务异常）；
3. Web 层返回友好提示；开放 API 返回统一错误码。

### 8.2 Maven 依赖规约

1. 【强制】GAV 规范：`groupId` = `com.公司.业务线[.子业务]`；`artifactId` = 产品线-模块名；`version` = 主.次.修订。
2. 【强制】线上生产**不能依赖 `SNAPSHOT`** 版本。
3. 【强制】版本统一定义在 `<dependencyManagement>`，`<dependencies>` 只写 `groupId` + `artifactId`。
4. 【强制】禁止同一个 GAV 在 pom 内出现多个 `version`。
5. 【推荐】二方库对外返回 POJO，**禁止包含枚举类型**（避免版本不一致反序列化失败）。
6. 【推荐】用 `maven-enforcer-plugin` 锁定 JDK 与依赖版本，`versions-maven-plugin` 定期检查升级。

### 8.3 服务器 & JVM

1. 【强制】生产 `-Xms` 与 `-Xmx` 相同；`-XX:+HeapDumpOnOutOfMemoryError` 必开。
2. 【推荐】Linux 调小 `tcp_fin_timeout` 缓解 `time_wait`；调高文件句柄数。
3. 【推荐】容器化部署时按容器内存上限设置堆（`-XX:MaxRAMPercentage`），避免被 OOMKilled。
4. 【强制】启动参数变更必须记录（ADR 或运维文档），禁止在生产手工改参数后又丢失。

---

## 九、设计规约

1. 【强制】底层存储、表结构、数据结构变更必须评审并留存设计文档。
2. 【推荐】UML 建模建议：
   - 用户角色 > 1、业务用例 > 5：用例图
   - 对象状态 > 3 种：状态图
   - 调用链路对象 > 3 个：时序图
   - 模型数量 > 5、复杂依赖：类图
   - 多对象协同复杂流程：活动图
3. 【强制】设计原则：单一职责；优先组合聚合、谨慎继承；依赖倒置；开闭原则；DRY。
4. 【推荐】可扩展性核心：识别业务变化点，隔离变化（策略 / 工厂 / SPI）。
5. 【强制】代码不能替代设计文档，复杂系统必须留存文档。
6. 【强制】技术选型/架构取舍必须记录 **ADR**（Architecture Decision Record）：背景 / 决策 / 备选方案 / 后果（Consequences）。至少写清「为什么不用另一方案」。
7. 【推荐】对外接口设计遵循幂等性（写操作凭业务唯一键幂等）、可重试、可观测（traceId）三要素。

---

## 十、Spring Boot 2.7 → 3.x 迁移指南

> **前置条件**：Spring Boot 3.x 基于 Spring Framework 6，**最低要求 Java 17**，推荐 Java 21。

### 10.1 `javax.*` → `jakarta.*`（最易踩坑，需全局替换）

| 原（SB 2.7） | 新（SB 3.x） | 典型影响位置 |
|---|---|---|
| `javax.annotation.Resource` | `jakarta.annotation.Resource` | 所有 `@Resource` 注入 |
| `javax.servlet.*` | `jakarta.servlet.*` | Filter、拦截器、Request/Response 包装 |
| `javax.validation.*` | `jakarta.validation.*` | `@NotNull`/`@Valid` 及分组校验 |
| `javax.persistence.*` | `jakarta.persistence.*` | 若使用 JPA |
| `javax.annotation.PreDestroy/PostConstruct` | `jakarta.annotation.*` | 生命周期回调 |

### 10.2 依赖坐标替换

| 能力 | SB 2.7 坐标 | SB 3.x 坐标 |
|---|---|---|
| 鉴权 | `sa-token-spring-boot-starter` | `sa-token-spring-boot3-starter` |
| ORM | `mybatis-plus-boot-starter` | `mybatis-plus-spring-boot3-starter`（3.5.4+） |
| API 文档 | springdoc 1.x + `io.swagger.annotations` | springdoc 2.x + `io.swagger.v3.oas.annotations` |
| 多数据源 | `dynamic-datasource-spring-boot-starter` 3.x | 4.x（支持 SB3） |
| 分布式锁 | `lock4j-redisson-spring-boot-starter` 2.2.3 | 2.2.4+ |
| Redisson | `redisson-spring-data-27` | 按 SB 版本选 `redisson-spring-data-3x` |
| 工作流 | Flowable 6.8.x | Flowable 7.x |
| 运维监控 | `spring-boot-admin` 2.7.x | 3.x |

> ⚠️ 版本号请以官方兼容矩阵为准，升级前核对一次。

### 10.3 配置与行为变更（必查）

1. 【强制】自动配置发现：`META-INF/spring.factories` → **`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`**。
2. 【强制】Redis 配置前缀：`spring.redis.*` → **`spring.data.redis.*`**。
3. 【强制】路径匹配默认 `PathPatternParser`，且**末尾斜杠匹配默认关闭**（`/api/user/` ≠ `/api/user`），需核对前端调用。
4. 【强制】循环依赖默认禁止，同类自注入需改造成独立 Bean。
5. 【强制】编译需加 `-parameters`，否则 `@RequestParam`/参数绑定可能失败。
6. 【强制】`@ConfigurationProperties` 绑定规则调整（单构造器无需显式 `@ConstructorBinding`）。
7. 【推荐】`spring.mvc.throw-exception-if-no-handler-found`、静态资源匹配等行为有调整，需回归 404 与静态资源。

### 10.4 虚拟线程实践（JDK 21）【JDK21】

Spring Boot 3.2+ 一行开启：`spring.threads.virtual.enabled=true`。

- 【强制】**禁止池化虚拟线程**。虚拟线程「一任务一线程、用完即弃」，不要塞进 `ThreadPoolExecutor`；需要创建用 `Executors.newVirtualThreadPerTaskExecutor()`，需要限制并发用 `Semaphore`。
- 【强制】虚拟线程**只解决阻塞式 IO 吞吐**，**不解决 CPU 密集**；CPU 密集仍用固定大小平台线程池。
- 【强制】警惕 `ThreadLocal`：虚拟线程可达百万级，大对象缓存在 `ThreadLocal` 会直接 OOM；`ScopedValue` 在 21 仍是**预览**，禁用。
- 【强制】JDK 21 上 `synchronized` 会**钉住（pin）载体线程**，阻塞临界区改用 `ReentrantLock`。
- 【推荐】并发放大后瓶颈转移到**下游资源**：同步评估连接池 `maximumPoolSize`、Redis 连接数、第三方限流。
- 【强制】开启前后必须**压测对比**（TPS / RT / 内存 / 连接池等待）再上线。

### 10.5 迁移检查清单

1. 升级 JDK，编译改 `<release>` + `-parameters`。
2. 全局替换 `javax.*` → `jakarta.*`（重点 `Resource`/`servlet`/`validation`）。
3. 按 [10.2](#102-依赖坐标替换) 替换依赖坐标，核对官方兼容矩阵。
4. API 文档层：springdoc 1.x → 2.x，注解迁至 `io.swagger.v3.oas.annotations`。
5. 中间件换 SB3 版本（鉴权 / ORM / 多数据源 / Redis / 锁 / 工作流）。
6. 配置核查：`spring.data.redis`、末尾斜杠匹配、循环依赖、`AutoConfiguration.imports`。
7. 回归测试：鉴权、分页、事务、文件上传下载、定时任务、报表导出。
8. 评估并灰度虚拟线程（见 [10.4](#104-虚拟线程实践jdk-21)），压测达标再全量。
9. 记录 ADR：升级取舍、风险与回滚方案。

---

## 附录 A：错误码设计

| 错误码 | 类别说明 |
|---|---|
| 00000 | 处理成功 |
| A0001 | 用户端错误（参数、登录、权限、上传、操作） |
| B0001 | 系统内部错误（超时、限流、资源耗尽） |
| C0001 | 调用第三方服务错误（RPC、缓存、消息、中间件） |

---

## 附录 B：迁移对照表

### B.1 JDK 8 → 17 API 迁移

| 场景 | 旧写法（避免） | 新写法（推荐） |
|---|---|---|
| 集合转列表 | `collect(Collectors.toList())` | `stream().toList()`（16+，不可变） |
| 不可变集合 | `Collections.unmodifiableList(...)` | `List.of(...)` / `List.copyOf(...)` |
| 判空字符串 | `str == null \|\| str.trim().isEmpty()` | `str == null \|\| str.isBlank()` |
| 去空白 | `str.trim()` | `str.strip()` |
| 字符串格式化 | `String.format("%s-%s", a, b)` | `"%s-%s".formatted(a, b)`（15+） |
| 多行字符串 | `"a\n" + "b\n"` | 文本块 `"""..."""`（15+） |
| 类型判断 | `if (o instanceof T) { T t = (T) o; }` | `if (o instanceof T t) {}`（16+） |
| 多分支赋值 | `if/else if` 链 | `switch` 表达式（14+） |
| 时间获取 | `new Date()` / `Calendar` | `LocalDateTime.now()` / `Instant.now()` |
| 时间格式化 | `new SimpleDateFormat("yyyy-MM-dd")` | `DateTimeFormatter.ofPattern(...)`（线程安全） |
| 天数差 | `(a.getTime()-b.getTime())/86400000` | `ChronoUnit.DAYS.between(b, a)` |
| 值对象 | 手写 `getter/setter/equals/hashCode` | `record`（16+） |
| 文件读写 | 手工 `InputStream` 循环 | `Files.readString(path)` / `Files.writeString(...)`（11+） |
| 字节转十六进制 | `String.format` 循环 | `HexFormat.of().formatHex(bytes)`（17+） |
| 随机数 | `new Random()` | `ThreadLocalRandom.current()` / `RandomGenerator`（17+） |
| 时间类型（新代码） | `private Date createTime;` | `private LocalDateTime createTime;` |
| 内部 API | `sun.misc.Unsafe` 等 | 公开 API；确需则显式 `--add-opens` 并注释 |

### B.2 JDK 17 → 21 与 Spring Boot 2.7 → 3.x 迁移

| 场景 | JDK 17 / SB 2.7 | JDK 21 / SB 3.x |
|---|---|---|
| 注入注解 | `javax.annotation.Resource` | `jakarta.annotation.Resource` |
| Web/Filter | `javax.servlet.*` | `jakarta.servlet.*` |
| 参数校验 | `javax.validation.*` | `jakarta.validation.*` |
| 鉴权 starter | `sa-token-spring-boot-starter` | `sa-token-spring-boot3-starter` |
| ORM starter | `mybatis-plus-boot-starter` | `mybatis-plus-spring-boot3-starter` |
| API 文档 | springdoc 1.x + `io.swagger.annotations` | springdoc 2.x + `io.swagger.v3.oas.annotations` |
| Redis 配置 | `spring.redis.*` | `spring.data.redis.*` |
| 自动配置发现 | `spring.factories` | `AutoConfiguration.imports` |
| 类型分派 | `if/else` + 强转 | `switch` 模式匹配（JEP 441） |
| 解构 record | 逐个 getter | `instanceof Point(int x, int y)`（JEP 440） |
| 取首尾元素 | `list.get(0)` / `list.get(size()-1)` | `list.getFirst()` / `list.getLast()`（JEP 431） |
| 阻塞 IO 并发 | 平台线程池（`ThreadPoolExecutor`） | 虚拟线程（`spring.threads.virtual.enabled=true`） |
| 大临界区锁 | `synchronized` 可用 | 注意虚拟线程 pinning，改用 `ReentrantLock` |

---

## 附录 C：速查表（Cheat Sheet）

**新增一个业务模块的标准骨架**

```
<service 模块>
  domain/Xxx.java                    # 实体：@Data @TableName("tb_xxx")
                                     # 时间字段一律 LocalDateTime（禁止新增 Date）
  domain/dto/XxxDto.java             # 服务间传输
  domain/req/XxxReq.java             # 请求（分页继承分页基类）
  domain/resp/XxxResp.java           # 响应
  mapper/XxxMapper.java              # 继承 BaseMapper<Xxx>
  service/IXxxService.java           # extends IService<Xxx>
  service/impl/XxxServiceImpl.java   # @Slf4j @Service
  resources/mapper/XxxMapper.xml     # BaseResultMap + Base_Column_List
<admin 模块>
  controller/XxxController.java      # @RestController + @Tag
```

**Controller 模板**

```java
@Operation(summary = "分页查询")            // SB3：io.swagger.v3.oas.annotations
@PostMapping("/pageList")
@SaCheckPermission("order:order:pageList")  // Spring Security 用 @PreAuthorize
public PageResult<OrderResp> pageList(@RequestBody @Valid OrderQuery query) {
    return PageResult.build(orderService.pageList(query));
}
```

**Service 校验与转换**

```java
Assert.isNotNull(id, "ID不能为空");                  // 断言 → 抛业务异常
Order entity = orderMapper.selectById(id);
Assert.isNotNull(entity, "数据不存在");
OrderResp resp = orderConverter.toResp(entity);      // MapStruct 统一转换
```

**十句口诀**

1. 参数校验用断言，异常统一 `ServiceException`。
2. 返回统一响应体，不裸泛型、不拼 `Map`。
3. 事务 `rollbackFor = Exception.class`，事务内不调 RPC。
4. 查询显式列 + 软删除条件，`#{}` 不用 `${}`。
5. 时间**一律 `LocalDateTime`**（禁止新增 `Date`），pattern 小写 `yyyy`。
6. `record` 做值对象，`var` 只在局部，`switch` 用箭头。
7. 集合判空用 `isEmpty()`，`List.of` 记得不可变。
8. 日志用占位符，`@Slf4j` 不 `println`。
9. 鉴权注解必写，当前用户走统一入口。
10. 生产禁 preview；JDK 21 用 `release=21` + `-parameters`，Spring Boot 3 用 `jakarta.*`。

---

## 附录 D：变更说明

### D.1 相比《阿里巴巴 Java 开发手册（嵩山版）》的增强

| 章节 | 增强内容 |
|---|---|
| 二 | **JDK 17–21 语言特性**：可用性双列对照、`var`、`record`、文本块、`switch` 表达式、`instanceof` 模式匹配、`sealed`、不可变集合、Stream/Optional、编译参数 |
| 三 | **Spring Boot 3 后端工程规范**：分层、Controller/Service/数据访问、统一返回与异常、校验、事务、缓存锁、鉴权、软删除、依赖注入、配置与可观测性 |
| 五 | 单元测试升级到 **JUnit 5** + Mockito + Testcontainers |
| 十 | **Spring Boot 2.7 → 3.x 迁移指南**：`javax`→`jakarta`、依赖坐标、配置行为变更、虚拟线程、迁移 Checklist |
| 附录 B | 迁移对照表（B.1 JDK 8→17、B.2 JDK 17→21 与 SB 2.7→3） |

### D.2 关键红线（一句话清单）

- 生产**永远禁用 `--enable-preview`**。
- JDK 17 上禁用虚拟线程 / `switch` 模式匹配 / `record` 解构 / 顺序集合。
- 编译用 `<release>` 而非 `source/target`；SB3 必须加 `-parameters`。
- `record` 只做值对象，不能做 ORM 实体。
- `var` 仅限局部变量且类型可一眼看出。
- `List.of/Map.of` 不可变且不允许 null。
- 禁止依赖 `sun.*` 内部 API（JEP 403 强封装）。
- 时间类型新代码一律 `LocalDateTime`，禁止新增 `Date`。
- 保持 helpful NPE 开启，提升排查效率。

---

*本规范版本：v1.0（通用版）*
*技术基线：Java 17 / Java 21 ｜ Spring Boot 3.x（向下兼容 2.7）*
