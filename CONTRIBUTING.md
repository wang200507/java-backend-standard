# 贡献指南

感谢你愿意为 **Java 后端开发规范（通用版）** 出一份力 —— 无论是纠错、补充条款，还是优化措辞，都很有价值。

> English: [CONTRIBUTING.en.md](CONTRIBUTING.en.md)

## 可以先看看这里

| 想做的事 | 入口 |
|---|---|
| 报告条款与 JDK / Spring Boot 实际行为不符 | [提交 Issue](.github/ISSUE_TEMPLATE/bug_report.md) |
| 建议新增条款或章节 | [提交 Issue](.github/ISSUE_TEMPLATE/feature_request.md) |
| 直接改文档 | 按下面流程提 PR |
| 只是想聊聊怎么用 | 开一个 Discussion / Issue 都行 |

## 贡献方向

- 🐛 **纠错**：条款与官方行为不一致、示例代码有误、锚点失效、错别字
- ✨ **补充**：新特性（JDK 21+ 的顺序集合、结构化并发等）、新组件（GraalVM / Spring Modulith / jOOQ …）的实践条款
- 🌏 **翻译**：英文版措辞优化，或新增其他语言版本（日文 / 韩文…）
- 🧪 **示例**：把抽象条款换成能跑的最小可运行示例（哪怕是一个 `record` 的正反例）
- 🧩 **工具**：改进 `script/sync-agent-rules.sh`、`script/push-all.sh`
- 📦 **工程**：CI 校验（例如检查中英两版条款数是否对齐）

## 提 PR 的流程

```bash
# 1. Fork 本仓库并克隆
git clone https://github.com/<你的用户名>/java-backend-standard.git
cd java-backend-standard

# 2. 开语义化分支：feat/ 新增、fix/ 纠错、docs/ 纯文档、chore/ 杂项
git checkout -b feat/jdk21-sequenced-collection

# 3. 编辑内容（只改 AGENTS.md / docs/，不要改各 IDE 落点文件）

# 4. 跑一次同步，确认落点文件能正常生成
bash script/sync-agent-rules.sh

# 5. 提交（建议中文，动词开头）
git commit -m "docs: 补充 JDK 21 顺序集合条款"

# 6. 推送并在平台上发起 Pull Request
git push origin feat/jdk21-sequenced-collection
```

## 提交前自查

- [ ] 规范正文只改了 `AGENTS.md` 与 `docs/`，**没有直接编辑各 IDE 落点文件**（`.trae/`、`.cursor/`、`.aiassistant/`、`.github/copilot-instructions.md`）——它们由脚本生成，改了也会被覆盖
- [ ] 中英两版**逐条对应**：改了中文，同步改了英文（或反之）
- [ ] 新增条款标明**规约等级**（【强制】/【推荐】/【参考】）与**适用 JDK 版本**（17 / 21 / 两者）
- [ ] 涉及 JDK 21 才有的特性，明确标注「JDK 17 不可用」
- [ ] 条款附带可运行示例或明确的反例，避免只有结论没有做法
- [ ] 新增/调整章节后，同步更新目录与交叉引用锚点
- [ ] 修改了脚本的话，本地至少跑一次并确认无报错

## 写作风格约定

- **每条条款一句话说清「做什么」**，再补「为什么」和反例；不要写成散文。
- **不要在规范正文里绑定任何具体项目**：项目名、包名、自研类名一律泛化（写「统一响应体」而不是某个具体的类名）。
- 术语保持中英一致：中文版用「规约等级」等既有措辞，英文版用 `[MUST]` / `[SHOULD]` / `[MAY]`。
- 代码块标明语言，示例尽量可直接编译。

## 关于 Issue / PR 模板

- GitHub 会自动加载 `.github/` 下的 Issue 与 PR 模板。
- Gitee 使用 `.gitee/` 下的 `ISSUE_TEMPLATE.zh-CN.md` 与 `PULL_REQUEST_TEMPLATE.zh-CN.md`。
- 没模板时按上面的「提交前自查」写清楚即可，不用纠结格式。

## 许可

本仓库以 [MIT](LICENSE) 许可发布。你提交的贡献将同样以 MIT 许可分发。
