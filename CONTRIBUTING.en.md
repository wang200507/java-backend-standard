# Contributing

Thanks for helping improve the **Java Backend Development Standard**. Whether you fix a typo, add a clause, or just question a rule, it is all valuable.

> 中文: [CONTRIBUTING.md](CONTRIBUTING.md)

## Where to start

| What you want | Where to go |
|---|---|
| Report a clause that contradicts JDK / Spring Boot behaviour | [Open an issue](.github/ISSUE_TEMPLATE/bug_report.md) |
| Propose a new clause or chapter | [Open an issue](.github/ISSUE_TEMPLATE/feature_request.md) |
| Just edit the docs | Follow the PR flow below |
| Ask how to use it | A discussion or an issue is fine |

## Ways to contribute

- 🐛 **Fix** — a clause contradicts official behaviour, an example is wrong, a link is broken, a typo
- ✨ **Extend** — practice clauses for new features (JDK 21+ sequenced collections, structured concurrency) and components (GraalVM / Spring Modulith / jOOQ …)
- 🌏 **Translate** — polish the English wording, or add another language edition
- 🧪 **Examples** — turn abstract clauses into minimal runnable samples
- 🧩 **Tooling** — improve `script/sync-agent-rules.sh` and `script/push-all.sh`
- 📦 **Engineering** — CI checks (e.g. verifying the Chinese and English editions stay aligned)

## How to open a PR

```bash
# 1. Fork the repo and clone it
git clone https://github.com/<your-user>/java-backend-standard.git
cd java-backend-standard

# 2. Create a semantic branch: feat/ fix/ docs/ chore/
git checkout -b feat/jdk21-sequenced-collection

# 3. Edit the content (only AGENTS.md / docs/, never the IDE target files)

# 4. Run the sync once to make sure targets generate cleanly
bash script/sync-agent-rules.sh

# 5. Commit
git commit -m "docs: add JDK 21 sequenced collection clause"

# 6. Push and open a pull request on the platform
git push origin feat/jdk21-sequenced-collection
```

## Self-check before submitting

- [ ] Only `AGENTS.md` and `docs/` were edited — **no IDE target file was hand-edited** (`.trae/`, `.cursor/`, `.aiassistant/`, `.github/copilot-instructions.md`) — they are generated and will be overwritten
- [ ] The Chinese and English editions stay **one-to-one** — a change in one is mirrored in the other
- [ ] New clauses state a **rule level** ([MUST] / [SHOULD] / [MAY]) and the **applicable JDK version** (17 / 21 / both)
- [ ] JDK 21-only features are explicitly marked as unavailable on 17
- [ ] Clauses come with a runnable example or an explicit counter-example
- [ ] After adding or moving chapters, update the table of contents and cross-reference anchors
- [ ] If you touched a script, run it once locally and confirm there are no errors

## Writing style

- **One clause states one thing to do**, then the reason and a counter-example. Do not write prose.
- **Never bind the standard to a specific project**: project names, package names, and in-house class names are generalised ("unified response body", not a concrete class name).
- Keep terminology aligned across editions: Chinese uses 【强制】/【推荐】/【参考】, English uses `[MUST]` / `[SHOULD]` / `[MAY]`.
- Tag code blocks with a language and keep samples compilable.

## Issue / PR templates

- GitHub loads the templates under `.github/`.
- Gitee uses `.gitee/ISSUE_TEMPLATE.zh-CN.md` and `.gitee/PULL_REQUEST_TEMPLATE.zh-CN.md`.
- If no template applies, just follow the self-check list above.

## License

This repository is released under the [MIT](LICENSE) license. Your contributions are distributed under the same terms.
