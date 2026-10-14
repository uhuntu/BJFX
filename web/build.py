"""Regenerate index.html from template.html, analysis.js and ../bjfx_data.json."""
import json, pathlib
here = pathlib.Path(__file__).parent
t = (here / "template.html").read_text(encoding="utf-8")
js = (here / "analysis.js").read_text(encoding="utf-8")
t = t.replace('<script src="analysis.js"></script>', "<script>\n" + js + "</script>")
d = json.loads((here.parent / "bjfx_data.json").read_text(encoding="utf-8"))
(here / "index.html").write_text(t.replace("/*DATA*/", json.dumps(d, ensure_ascii=False)), encoding="utf-8")
