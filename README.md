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

## 数据

- `bjfx_data.json` — 工作数据源，由 1998 年 `BJFX.DBF` 导出；已删除答题状态字段 XZBJ 并去除 DBF 定宽导出的空白伪影（清洗结果与 2001 年 Access 库逐条吻合）。
- `bjfx_data_2001.json` — 2001 年 ASP 版 Access 库（[asp_2001/bjfx.mdb](asp_2001/bjfx.mdb)）内容字段的逐条导出存档，2026-10 经 ACE OLEDB 提取。两份数据 63 条内容一致。

## 2026 网页版（web/）

零依赖静态页，忠实移植 1998 算法并修正平局判定：

```
python web/build.py        # template.html + analysis.js + ../bjfx_data.json -> 单文件 index.html
node web/test_analysis.js  # 单元测试（算法 + 数据 schema 守卫）
```

`web/index.html` 为构建产物：单文件、可离线打开、无需服务器。

## 历史注记

- 原作版本 1.0，完成于 1998-08-23；ASP 在线版文件时间 2001-06-29，部署于当时的个人站点 `/lozic/`。
- 各层于 2026-07 先后归档进 git，2026 年复刻的动机是数字保存，非实用目的。
- 2026-10-14：原独立仓库 uhuntu/BJFX_web 以保留历史的方式（双亲合并）并入本仓库 `asp_2001/`。
