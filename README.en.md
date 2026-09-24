<div align="center">

# Java Backend Development Standard

**A coding standard and best-practice guide for Java 17 / 21 + Spring Boot 3.x**

[![JDK](https://img.shields.io/badge/JDK-17%20%7C%2021-orange)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F)](https://spring.io/projects/spring-boot)
[![License](https://img.shields.io/badge/LICENSE-MIT-blue)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-830%20lines-informational)](docs/java-backend-standard.md)
[![PRs](https://img.shields.io/badge/PRs-welcome-ff69b4)](#-contributing-prs-welcome)
[![Project-agnostic](https://img.shields.io/badge/scope-project--agnostic-9cf)](#-what-is-this)

[![GitHub](https://img.shields.io/badge/GitHub-wang200507-181717?logo=github)](https://github.com/wang200507/java-backend-standard)
[![Gitee](https://img.shields.io/badge/Gitee-wangzy01-c71d23?logo=gitee)](https://gitee.com/wangzy01/java-backend-standard)
[![GitCode](https://img.shields.io/badge/GitCode-gcw__hGwaIPtW-2f6fed)](https://gitcode.com/gcw_hGwaIPtW/java-backend-standard)

[中文](README.md) · [Full manual](docs/java-backend-standard.md) · [Cheat sheet](docs/java-backend-standard.md#appendix-c-cheat-sheet)

</div>

🧾 Coding conventions · ⚡ JDK 17–21 language features · 🧱 Spring Boot 3 engineering · 🩺 Exceptions & logging · 🧪 Unit testing · 🔐 Security · 🗄 MySQL · 📦 Structure & dependencies · 🧠 Design · 🚚 SB 2.7 → 3.x migration

---

## 🧩 What is this

A Java backend development standard that is **tied to no specific business project**. It builds on the core rules of Alibaba's *Java Development Manual* (Songshan edition), extends them with JDK 17–21 language and API practice plus Spring Boot 3 engineering conventions, and can be used directly for new projects, code reviews, and AI assistant rules.

- 🎯 **One sentence**: keep `AGENTS.md` as the hard-rule gate, browse `docs/` as the manual, run one script and Trae / Cursor / JetBrains / Claude Code all follow the same rules.

- 🧱 **Project-agnostic**: project names, package names, and in-house utility classes are all stripped out — only transferable clauses remain, with zero domain vocabulary.

- ⚡ **JDK 17 vs 21 side by side**: every feature states "can 17 use it, how does 21 use it", which avoids shipping code that fails to compile on 17. Preview features are listed as a separate no-go zone.

- 🚚 **Upgrade path in pairs**: `javax.*` → `jakarta.*` mapping, dependency coordinate swaps, configuration changes, virtual-thread conditions, plus a 9-step migration checklist.

- 🤖 **Built for AI IDEs**: `AGENTS.md` is the filename Cursor / OpenCode / Codex / Copilot read natively; English wording follows instructions more reliably across models. One command materialises it into each IDE's rule directory.

- 🧾 **Reviewable and actionable**: clauses are graded [MUST] / [SHOULD] / [MAY] and backed by an error-code table, migration tables, and a ten-line cheat sheet, so a review can cite clauses directly.

## 📚 Contents at a glance

The full standard lives in [`docs/java-backend-standard.md`](docs/java-backend-standard.md) (English, ~830 lines) / [`docs/java-backend-standard.zh-CN.md`](docs/java-backend-standard.zh-CN.md) (Chinese).

| Chapter | Content |
|---|---|
| 1 Coding Conventions | naming, constants, formatting, OOP, date/time, collections, concurrency, control flow, comments, API contract, misc |
| 2 JDK 17–21 Language Features | availability matrix, `var`, `record`, text blocks, `switch` expressions, pattern matching, `sealed`, immutable collections, Streams / Optional, compiler flags |
| 3 Spring Boot 3 Engineering | layering, controller / service / data access, unified response and exceptions, validation, transactions, caching and distributed locks, authorization, soft delete, dependency injection, configuration and observability |
| 4 Exceptions and Logging | error codes, exception handling, logging |
| 5 Unit Testing | JUnit 5 + Mockito practice, Testcontainers |
| 6 Security | privilege escalation, masking, injection, deserialization, key management |
| 7 MySQL | table design, indexes, SQL statements |
| 8 Project Structure and Dependencies | layering, Maven dependency management, servers and JVM |
| 9 Design Principles | modeling, design principles, ADRs |
| 10 Spring Boot 2.7 → 3.x Migration | `javax`→`jakarta`, dependency coordinates, configuration changes, virtual threads, checklist |
| Appendix A / B / C / D | error codes, migration tables, cheat sheet, change log |

## 🚀 Quick start

**1. As AI assistant rules (recommended)**

The root `AGENTS.md` is the condensed rule entry (hard rules + conventions + cheat sheet). **Cursor / OpenCode / Codex / Copilot read it natively.** To distribute to more IDEs (Trae / Cursor / JetBrains / Claude Code):

```bash
bash script/sync-agent-rules.sh            # write targets inside this repo only
bash script/sync-agent-rules.sh --global   # also write user-level global targets
bash script/sync-agent-rules.sh --lang zh  # distribute the Chinese rules instead
```

**2. Install as a skill**

```bash
# Claude Code
cp -r skills/java-backend-standard ~/.claude/skills/
# WorkBuddy
cp -r skills/java-backend-standard ~/.workbuddy/skills/
```

**3. Read it directly**

```bash
# Appendix C cheat sheet — the whole standard in ten lines
docs/java-backend-standard.md  →  Appendix C
```

## 🌏 Platforms and language editions

| Platform | URL | Default README |
|---|---|---|
| GitHub | [wang200507/java-backend-standard](https://github.com/wang200507/java-backend-standard) | Chinese (English entry linked) |
| Gitee | [wangzy01/java-backend-standard](https://gitee.com/wangzy01/java-backend-standard) | Chinese (auto-switches to English for English browsers) |
| GitCode | [gcw_hGwaIPtW/java-backend-standard](https://gitcode.com/gcw_hGwaIPtW/java-backend-standard) | Chinese |

| Purpose | Chinese | English |
|---|---|---|
| Repository description | `README.md` | `README.en.md` (this file) |
| Rule entry (read by AI IDEs) | `AGENTS.zh-CN.md` | **`AGENTS.md` (default)** |
| Full manual | `docs/java-backend-standard.zh-CN.md` | `docs/java-backend-standard.md` |
| Skill | `SKILL.zh-CN.md` | `SKILL.md` (default) |
| Contributing guide | `CONTRIBUTING.md` | `CONTRIBUTING.en.md` |

> Naming rule, in two halves: **human-facing documents** (README / CONTRIBUTING) have no suffix for **Chinese**, because the hosting platforms serve a mostly Chinese audience; **AI-IDE-facing files** (`AGENTS.md` / `docs/*.md` / `SKILL.md`) have no suffix for **English**, because English wording follows instructions more reliably across models.

## 🧷 The ten hard rules

1. **Never** `--enable-preview` in production.
2. On JDK 17: no virtual threads, `switch` pattern matching, record deconstruction, or sequenced collections.
3. Compile with `<release>`, not `source`/`target`; Spring Boot 3 requires `-parameters`.
4. `record` is for value objects only — never an ORM entity.
5. `var` only for local variables with an obvious type.
6. `List.of` / `Map.of` are immutable and reject null.
7. Never depend on `sun.*` internal APIs (JEP 403).
8. All new date/time code uses `LocalDateTime`; never add a new `Date`.
9. SQL uses `#{}`, never `${}`; select explicit columns and include the soft-delete condition.
10. Transactions use `rollbackFor = Exception.class`; never call RPC inside a transaction.

## 🤝 Contributing (PRs welcome)

**Issues, pull requests, and discussions are all welcome** — even small feedback like "this clause is unclear" or "this example does not run on JDK 21" is valuable.

Good places to help:

- 🐛 **Fix** — a clause contradicts JDK / Spring Boot behaviour, or an example is wrong
- ✨ **Extend** — practice clauses for new features (JDK 21+) and components (GraalVM / Spring Modulith / jOOQ …)
- 🌏 **Translate** — polish the English wording, or add another language edition
- 🧪 **Examples** — turn abstract clauses into minimal runnable samples
- 🧩 **Tooling** — improve the scripts under `script/`

How to open a PR:

```bash
# 1. Fork the repo and clone it locally
git clone https://github.com/<your-user>/java-backend-standard.git
cd java-backend-standard

# 2. Create a semantic branch
git checkout -b feat/jdk21-sequenced-collection

# 3. After editing, always re-run the sync (target files are generated, never hand-edit)
bash script/sync-agent-rules.sh

# 4. Commit, push, and open a pull request on the platform
git commit -m "docs: add JDK 21 sequenced collection clause"
git push origin feat/jdk21-sequenced-collection
```

Self-check before submitting:

- [ ] Only `AGENTS.md` and `docs/` were edited — **no IDE target file was hand-edited** (the sync script overwrites them)
- [ ] The Chinese and English editions stay **one-to-one**; a Chinese change is mirrored in English
- [ ] New clauses state a rule level ([MUST] / [SHOULD] / [MAY]) and the applicable JDK version
- [ ] Clauses include a runnable example or an explicit counter-example

See [CONTRIBUTING.en.md](CONTRIBUTING.en.md) ([中文](CONTRIBUTING.md)). Please use the bundled PR template.

## 📁 Repository layout

```
.
├── README.md / README.en.md                   repository description (ZH / EN)
├── CONTRIBUTING.md / CONTRIBUTING.en.md       contributing guide (ZH / EN)
├── AGENTS.md / AGENTS.zh-CN.md                cross-IDE condensed rule entry (EN default / ZH)
├── PULL_REQUEST_TEMPLATE.md                   PR template
├── LICENSE                                    MIT
├── CHANGELOG.md                               version history
├── docs/
│   ├── java-backend-standard.md               full standard (EN)
│   └── java-backend-standard.zh-CN.md         full standard (ZH)
├── script/
│   ├── sync-agent-rules.sh                    distribute rules to IDE targets (--lang aware)
│   └── push-all.sh                            push to multiple platform remotes
├── .github/                                   issue / PR templates, Copilot instructions
└── skills/
    └── java-backend-standard/
        ├── SKILL.md                           installable AI skill (EN)
        ├── SKILL.zh-CN.md                     installable AI skill (ZH)
        └── references/                        manual copies, generated by the sync script
```

## 🧭 Conventions

- The **single source of truth** is `AGENTS.md` (condensed) plus `docs/java-backend-standard.md` (full); the Chinese edition is a synchronised translation.
- Files under the IDE target directories are generated by the script — **do not edit them directly** (the next sync overwrites them).
- To change the standard: edit `AGENTS.md` (and `AGENTS.zh-CN.md` when needed) → run the sync script → commit.
- To publish: `bash script/push-all.sh --all`, or `git push github main` / `git push gitee main` / `git push gitcode main` individually.

## 📄 License

[MIT](LICENSE) — free for personal and commercial use.
