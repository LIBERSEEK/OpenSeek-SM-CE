# OpenSeek-SM

**把选题、创作、内容资产和社交发布，连接在同一个自托管工作台。**

OpenSeek-SM 是面向内容创作者、品牌运营和协作团队的内容运营工作台。你可以从热点与订阅中寻找选题，借助 AI 整理思路与起草文案，在内容库中管理素材和稿件版本，再通过发布日历安排已连接社交账号的内容。

你可以从任意环节开始：只整理一次选题、编辑一篇稿件，或管理一周的发布计划，无需先执行完整流程。

*A self-hosted content workspace for discovery, AI-assisted writing, content assets, and social publishing.*

当前 Docker 安装版本：**v0.0.2**。本仓库提供安装脚本、Docker Compose 配置和使用说明；应用通过容器镜像分发。

- [核心功能](#核心功能)
- [典型使用场景](#典型使用场景)
- [功能与配置说明](#功能与配置说明)
- [快速安装](#快速安装)
- [镜像与日常管理](#镜像与日常管理)
- [升级与备份](#升级与备份)
- [可选服务与运行边界](#可选服务与运行边界)

## 核心功能

| 功能 | 可以用它做什么 |
| --- | --- |
| **选题发现** | 浏览热点与趋势线索，整理感兴趣的话题；配置 RSS/Atom 来源后，将行业资讯、竞品动态或社区讨论纳入选题研究。 |
| **内容策划** | 围绕项目组织研究材料、创作简报、内容矩阵和日历计划，让零散想法形成可继续推进的内容任务。 |
| **AI 辅助创作** | 通过内置对话工作台，结合当前项目上下文和按需加载的 Skills，辅助研究、策划与文本起草，并将稿件保存为内容资产。需配置可用的模型服务。 |
| **内容库与版本管理** | 按内容包归集稿件与素材，浏览文本、图片及媒体资源，查看历史版本；编辑文本时保存为新的草稿版本，保留修改轨迹。 |
| **发布日历与排期** | 在日历中组织发布节奏，为已连接的社交账号安排内容，集中管理草稿和定时发布任务。 |
| **多账号内容运营** | 在同一工作台管理接入的社交渠道和账号，减少在多个后台之间切换。实际可用渠道取决于平台授权与部署配置。 |
| **团队协作** | 通过团队与成员管理，共同组织内容、素材及发布工作，适合多人参与的运营流程。 |
| **运营数据查看** | 查看已接入渠道可提供的内容与账号数据，辅助复盘。指标范围、同步情况和可用性取决于对应平台接口。 |

## 典型使用场景

- **独立创作者**：集中收集灵感、起草文案、整理素材，再用日历安排持续更新。
- **品牌与市场团队**：围绕同一个项目管理选题、内容包与不同渠道的稿件，协调日常发布节奏。
- **内容运营团队**：把资讯研究、内容策划、稿件版本和发布任务放在同一个工作空间中，减少资料分散。
- **希望自托管的团队**：在自己的设备或服务器上部署应用，管理数据库、上传文件和服务配置；启用外部模型或渠道后，相应请求仍会发送至所配置的服务。

一个常见的工作方式是：

```text
发现选题 → 整理研究与简报 → AI 辅助起草 → 内容库编辑与版本保存 → 日历排期 → 查看发布与运营数据
```

也可以直接从已有稿件或素材开始，只使用需要的功能。

## 功能与配置说明

本页以 **v0.0.2** 为说明范围。安装成功代表应用服务可以启动；外部平台、模型和数据源仍需分别配置与验证。

- **内容管理界面**：已提供内容包、素材预览、文本编辑和历史版本等功能。预览成功不代表内容已经审核或发布成功。
- **AI 与订阅来源**：需自行配置模型 API 和 RSS/Atom 来源；RSS 研究连接器默认不启用任何订阅源。Skills 会按需提供任务指引，目录中存在某个 Skill 不代表其外部执行能力已经接通。
- **社交发布与数据**：需完成对应平台的应用凭证、账号授权和接口配置。请先用自己的测试账号验证发布结果与数据读取，再用于正式运营；本版本不承诺所有平台均已完成生产验证。
- **仍在完善的能力**：图片、音频和视频的自动生成链路，以及自动发布审批、发布回执核验和自动归因闭环，仍需按具体服务完成接入与实际验收，不作为开箱即用的承诺。

## 快速安装

先安装并启动 Docker Engine + Docker Compose v2，或 Docker Desktop。

```bash
git clone https://github.com/LIBERSEEK/OpenSeek-SM-CE.git
cd OpenSeek-SM-CE
bash install.sh
```

安装脚本会生成随机的 `JWT_SECRET`，并等待服务通过健康检查。完成后访问 <http://localhost:4007>，注册第一个账号。

默认部署包含 OpenSeek 应用、PostgreSQL、Redis，以及使用独立 PostgreSQL 数据库的 Temporal 服务。

### 部署到远程服务器

运行安装脚本前，先执行 `cp .env.docker.example .env`，将 `JWT_SECRET` 替换为足够长的随机值，并将 `MAIN_URL`、`FRONTEND_URL` 和 `NEXT_PUBLIC_BACKEND_URL` 更新为用户实际访问的地址。配置项可参考 [环境变量示例](./.env.docker.example)。

使用 HTTPS 时，配置反向代理并保持 `NOT_SECURED=` 为空；应用会将任何非空值视为启用。完成所需账号注册后，可设置 `DISABLE_REGISTRATION=true` 关闭公开注册。

## 镜像与日常管理

```text
ghcr.io/liberseek/openseek-sm-ce:v0.0.2
```

镜像支持 **Linux amd64 / arm64**。[环境变量示例](./.env.docker.example) 中的 `OPENSEEK_VERSION` 指定为 `v0.0.2`；升级时请使用明确的版本号。

如果旧部署仍使用 `postiz` Compose 服务名，可重新运行 `bash install.sh`，安装脚本会移除旧容器并保留命名数据卷。

```bash
docker compose ps
docker compose logs --tail=100 openseek
docker compose stop
docker compose start
```

## 升级与备份

升级前，备份 `.env`、应用 PostgreSQL 数据库、Temporal PostgreSQL 数据库和全部命名数据卷，并保持 `JWT_SECRET` 不变。应用启动时会执行数据库结构更新；仅回退镜像不会回退数据库。

以下命令导出两个数据库；上传文件及其他命名卷仍需另外备份。完成备份后，将 `.env` 中的 `OPENSEEK_VERSION` 更新为目标版本，再拉取并启动服务。

```bash
docker exec openseek-postgres sh -c 'pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' > openseek-db.sql
docker compose exec -T temporal-postgresql pg_dumpall -U temporal > temporal-db.sql
docker compose down --remove-orphans
docker compose pull
docker compose up -d --wait --wait-timeout 420
```

需要保留数据时，**不要执行 `docker compose down -v`**：它会删除命名数据卷。

## 可选服务与运行边界

- **平台与 AI 服务**：由部署者在 `.env` 中提供所需平台凭证和 AI API Key，服务可用性与费用以所配置服务为准。
- **RSSHub**：可选的外部服务，通过 `RSSHUB_BASE_URL` 和 `RSSHUB_INTERNAL_TOKEN` 配置；默认 Compose 不包含 RSSHub 实例。
- **交互式登录**：需要浏览器显示窗口的扫码或交互登录，须另外配置带显示环境的运行方式；默认 Docker 部署不提供远程桌面。
- **本地目录交接**：内容库的本地目录打开与内容包导出面向 localhost 前端和本地存储，不代表远程服务器目录会直接在访问者电脑上打开。

应用依据适用的商业授权以可执行容器分发。镜像接收者仍可检查其中的编译后 JavaScript、Python 运行模块及必要资源；容器并不等于源码加密。
