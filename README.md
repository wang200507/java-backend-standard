# Java Backend Development Standard

A general-purpose coding standard and best-practice guide for **Java 17 / 21 + Spring Boot 3.x** backend services. Built on the core rules of Alibaba's *Java Development Manual* (Songshan edition), extended with JDK 17–21 language features and Spring Boot 3 engineering practice. **Not tied to any specific business project** — use it for new projects, code reviews, and AI assistant rules.

> Chinese edition: [README.zh-CN.md](README.zh-CN.md) ｜ 中文版见 [README.zh-CN.md](README.zh-CN.md)

## Contents

The full standard lives in [`docs/java-backend-standard.md`](docs/java-backend-standard.md) (~830 lines).

| Chapter | Content |
|---|---|
| 1 Coding Conventions | naming, constants, formatting, OOP, date/time, collections, concurrency, control flow, comments, API contract, misc |
| 2 JDK 17–21 Language Features | availability matrix, `var`, `record`, text blocks, `switch` expressions, pattern matching, `sealed`, immutable collections, Streams/Optional, compiler flags |
| 3 Spring Boot 3 Engineering | layering, controller/service/data access, unified response and exceptions, validation, transactions, caching and distributed locks, authorization, soft delete, dependency injection, configuration and observability |
| 4 Exceptions and Logging | error codes, exception handling, logging |
| 5 Unit Testing | JUnit 5 + Mockito practice |
| 6 Security | privilege escalation, masking, injection, deserialization, key management |
| 7 MySQL | table design, indexes, SQL statements |
| 8 Project Structure and Dependencies | layering, Maven dependency management, servers and JVM |
| 9 Design Principles | modeling, design principles, ADRs |
| 10 Spring Boot 2.7 → 3.x Migration | `javax`→`jakarta`, dependency coordinates, configuration changes, virtual threads, migration checklist |
| Appendix A/B/C/D | error codes, migration tables, cheat sheet, change log |

## Language editions

| Language | Rule entry | Full manual | Skill |
|---|---|---|---|
| **English (default)** | `AGENTS.md` | `docs/java-backend-standard.md` | `skills/java-backend-standard/SKILL.md` |
| 中文 | `AGENTS.zh-CN.md` | `docs/java-backend-standard.zh-CN.md` | `skills/java-backend-standard/SKILL.zh-CN.md` |

The unsuffixed filename is always English. `AGENTS.md` in particular is the file AI IDEs read automatically, so English is the default there.

## Quick start

### 1. As AI assistant rules (recommended)

The root `AGENTS.md` is the condensed rule entry (hard rules + conventions + cheat sheet). **Cursor / OpenCode / Codex / Copilot read it natively.** To distribute to more IDEs (Trae / Cursor / JetBrains / Claude Code):

```bash
bash script/sync-agent-rules.sh            # write targets inside this repo only
bash script/sync-agent-rules.sh --global   # also write user-level global targets
bash script/sync-agent-rules.sh --lang zh  # distribute the Chinese rules instead
```

### 2. Install as a skill

```bash
# Claude Code
cp -r skills/java-backend-standard ~/.claude/skills/
# WorkBuddy
cp -r skills/java-backend-standard ~/.workbuddy/skills/
```

### 3. Read it directly

Open [`docs/java-backend-standard.md`](docs/java-backend-standard.md), or jump to the [cheat sheet](docs/java-backend-standard.md#appendix-c-cheat-sheet).

## Publishing to multiple platforms

This repository can be hosted on GitHub / Gitee / GitCode simultaneously. First push:

```bash
# After creating an empty repository on each platform:
bash script/push-all.sh \
  https://github.com/<user>/java-backend-standard.git \
  https://gitee.com/<user>/java-backend-standard.git \
  https://gitcode.com/<user>/java-backend-standard.git
```

The script adds the `github` / `gitee` / `gitcode` remotes (detected from the domain) and pushes to each. Afterwards, push individually with `git push github main`, etc.

## The ten hard rules

1. **Never** `--enable-preview` in production.
2. On JDK 17: no virtual threads, `switch` pattern matching, record deconstruction, or sequenced collections.
3. Compile with `<release>`, not `source`/`target`; Spring Boot 3 requires `-parameters`.
4. `record` is for value objects only — never an ORM entity.
5. `var` only for local variables with an obvious type.
6. `List.of/Map.of` are immutable and reject null.
7. Never depend on `sun.*` internal APIs (JEP 403).
8. All new date/time code uses `LocalDateTime`; never add a new `Date`.
9. SQL uses `#{}`, never `${}`; select explicit columns and include the soft-delete condition.
10. Transactions use `rollbackFor = Exception.class`; never call RPC inside a transaction.

## Repository layout

```
.
├── README.md / README.zh-CN.md          this file (EN / ZH)
├── AGENTS.md / AGENTS.zh-CN.md          cross-IDE condensed rule entry (EN / ZH)
├── LICENSE                              MIT
├── CHANGELOG.md                         version history
├── docs/
│   ├── java-backend-standard.md          full standard (EN)
│   └── java-backend-standard.zh-CN.md    full standard (ZH)
├── script/
│   ├── sync-agent-rules.sh              distribute rules to IDE targets
│   └── push-all.sh                      push to multiple platform remotes
└── skills/
    └── java-backend-standard/
        ├── SKILL.md                      installable AI skill (EN)
        ├── SKILL.zh-CN.md                installable AI skill (ZH)
        └── references/                   manual copies, generated by the sync script
```

## Conventions

- The **single source of truth** is `AGENTS.md` (condensed) plus `docs/java-backend-standard.md` (full).
- Files under the IDE target directories are generated by the script — **do not edit them directly** (the next sync overwrites them).
- To change the standard: edit `AGENTS.md` → run the sync script → commit.

## License

[MIT](LICENSE)
