# BJFX — 笔迹分析系统

「笔迹分析系统」（BJFX = **B**i**J**i **F**en**X**i）的个人数字档案：1998 年 DOS 原作、2001 年 ASP 在线版、2026 年网页复刻。作者：林恒（Hunt Lin）；指导人：金一贵；参考书目：《笔迹与性格》。

> 仅供娱乐：笔迹学缺乏科学依据，结果不应用于任何评估、招聘或决策。
> Entertainment only: graphology has no scientific validity.

## 三代谱系

| 年代 | 实现 | 位置 | 算法差异 |
|---|---|---|---|
| 1998 | FoxPro 2.6 for DOS | 本仓库根目录 | 分组归一化 ✓；平局判定有盲区（DZ 与 YY 并列最高时会默默判成 YY） |
| 2001 | 经典 ASP + Access | [asp_2001/](asp_2001/) | 平局判定修好 ✓（任一并列最高即"分析失败"）；丢了分组归一化 |
| 2026 | 原生 JS 静态页 | [web/](web/) | 两者均正确 |

共同算法：对 63 个字迹特点按 没有/模糊/一般/显著 四级作答（权重 0/1/2/4），按气质属性累加（DZ 胆汁质 / YY 抑郁质 / NY 粘液质 / DX 多血质），取最高者为结论，并列最高则分析失败。原理详见 [BJFXSJ.TXT](BJFXSJ.TXT)（1998 设计说明书）。

## 1998 原作（根目录）

- `BJFX.EXE` — 编译后程序，DOS + 汉字系统（如 UCDOS）下运行
- `BJFX.PRG` / `BJFXPROC.PRG` — 源码：主程序，以及 CS（初始化）/ TW（提问）/ FX（分析）/ JL（结论）四模块
- `BJFX.DBF` — 知识库（63 条：气质属性、字迹特点、对应性格）
- `README.TXT` — 1998 年用户手册（其中"SOURCE 子目录"的说法与实际平铺布局不符，以本仓库为准）
- `FOXUSER.DBF` / `FOXUSER.FPT` — FoxPro 资源文件（历史残留）

### 实现注记（BJFX.PRG / BJFXPROC.PRG）

- **计分即时完成**：CS 模块定义权数 `N/F/G/O = 0/1/2/4`；提问模块在按键时用宏替换 `&QZSX1=&QZSX1+&ANSWER` 直接把权重累加进对应气质计数器，同时把答案写回 XZBJ 字段——没有独立的统计阶段。
- **临时库技巧**：编译进 EXE 的 DBF 不可修改，主程序每次运行先 `COPY TO BJFXTMP.DBF` 把答题写入临时库，退出时 `ERASE`。2001 版以 `adLockBatchOptimistic` 写内存记录集再 `CancelBatch`，是同一思路的 web 等价物；2026 版则完全无状态。
- **键位语义**：Enter/Ctrl+C 沿用上一题答案；Ctrl+R（CHR(18)）回上一题；Esc 中止（未答项按 N 计，2026 版保留该语义并有测试覆盖）。
- **平局盲区的准确位置**：FX 模块先按组归一化（配合 `SET DECIMAL TO 5`），再两两淘汰赛比较。仅跨组决胜的 `&MAX1=&MAX2` 能检出平局（MAX="  " → JL 报"分析失败"）；组内并列（DZ=YY 或 NY=DX）会被静默偏向后者。2026 版 `web/test_analysis.js` 已用组内并列用例锁定此修复。
- **结论展示**：JL 模块用 `INDEX ON -ASC(XZBJ)` 做倒序索引、每屏 6 条分页浏览；失败文案"被分析的人性格怪异"为 2001 版沿用，2026 版措辞已软化为"各类性格特征过于接近"。

## 数据

- `bjfx_data.json` — 工作数据源，由 1998 年 `BJFX.DBF` 导出；已删除答题状态字段 XZBJ 并去除 DBF 定宽导出的空白伪影（清洗结果与 2001 年 Access 库逐条吻合）。
- `bjfx_data_2001.json` — 2001 年 ASP 版 Access 库（[asp_2001/bjfx.mdb](asp_2001/bjfx.mdb)）内容字段的逐条导出存档，2026-10 经 ACE OLEDB 提取。两份数据 63 条内容一致。

## 2026 网页版（web/）

零依赖静态页，忠实移植 1998 算法并修正平局判定：

```
python web/build.py        # template.html + analysis.js + ../bjfx_data.json -> 单文件 index.html
node web/test_analysis.js  # 单元测试（算法 + 数据 schema 守卫）
```

`web/index.html` 为构建产物：单文件、可离线打开、无需服务器。结果页附四类气质的归一化得分条形图；表单带作答进度指示；题目以 `fieldset/legend` 组织以保证无障碍。

## 历史注记

- 原作版本 1.0，完成于 1998-08-23；ASP 在线版文件时间 2001-06-29，部署于当时的个人站点 `/lozic/`。
- 各层于 2026-07 先后归档进 git，2026 年复刻的动机是数字保存，非实用目的。
- 2026-10-14：原独立仓库 uhuntu/BJFX_web 以保留历史的方式（双亲合并）并入本仓库 `asp_2001/`。
- 2026-11-02：补充 1998 版实现注记与组内并列测试用例；2026 版结果页新增四组归一化得分条形图、作答进度指示与 `fieldset/legend` 无障碍结构。
