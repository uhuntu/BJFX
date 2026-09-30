"""Regenerate index.html from template.html and ../bjfx_data.json."""
import json, pathlib
here = pathlib.Path(__file__).parent
t = (here / "template.html").read_text(encoding="utf-8")
d = json.loads((here.parent / "bjfx_data.json").read_text(encoding="utf-8"))
d = [{k: r[k] for k in ("QZSX", "ZJTD", "DYXG")} for r in d]
(here / "index.html").write_text(t.replace("/*DATA*/", json.dumps(d, ensure_ascii=False)), encoding="utf-8")
