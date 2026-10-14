# BJFX_web — 在线笔迹分析系统（2001）

「笔迹分析系统」的 2001 年在线版：经典 ASP（VBScript）+ Microsoft Access，文件时间 2001-06-29，当年部署于个人站点 `/lozic/`（连接字符串 `Server.MapPath("/lozic/db/bjfx.mdb")` 中可见）。

> 仅供娱乐：笔迹学缺乏科学依据，结果不应用于任何评估、招聘或决策。

## 文件

- `default.htm` — 启动页，即 1998 年 DOS 启动画面的 HTML 化（署名信息一字未改）
- `bjfx_online.asp` — 从 Access 表 `bjfx` 生成 63 题问答表单；单选钮 value 编码为「气质代码 + 权重位」（如 `DZ4`），服务端以 `Left(x,2)` / `Right(x,1)` 拆解计分
- `bjfx_result.asp` — 计分、判定与结论展示；以 adLockBatchOptimistic 写 XZBJ 后 `CancelBatch`，内存态分析、不落盘（1998 年「拷临时 DBF」技巧的 web 等价物）
- `bjfx.mdb` — 知识库（表 `bjfx`，63 条，内容与 1998 年 BJFX.DBF 一致）

## 算法地位（三代谱系的中层）

- 相对 [1998 年 FoxPro 原作](../BJFX)：**修好**了平局判定——任一气质并列最高即报「分析失败」（原版的括号式比较有盲区）；**丢了**设计说明书中的分组归一化：胆汁质 23 题、多血质 11 题，按原始加权和比较时，多血质全选「显著」（44）赢不过胆汁质全选「一般」（46）。
- [2026 年静态页复刻](../BJFX/web)恢复了归一化，并保留了严格的平局判定。
- mdb 内容字段的 JSON 导出存档：[../BJFX/bjfx_data_2001.json](../BJFX/bjfx_data_2001.json)（2026-10 经 ACE OLEDB 提取）。

## 运行（仅作历史保存，不建议部署）

需要支持经典 ASP 的 IIS 环境与 Microsoft ACE/Jet OLEDB 驱动；按 `../include/adovbs.inc` 的相对位置与 `/lozic/db/bjfx.mdb` 的路径约定部署，或自行调整连接字符串。代码构造上无 SQL 注入面（Filter 仅拼接内部白名单变量）。
