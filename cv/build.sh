#!/usr/bin/env bash
# 编译 CV 的 LaTeX 源并部署到网站
#
#   用法：./cv/build.sh
#
# 源文件：cv/cv.tex
# 产物  ：files/Zhiqun_Xiao_CV.pdf（网站通过 /files/Zhiqun_Xiao_CV.pdf 提供下载）
#
# 依赖：xelatex（TeX Live，本机已装）。改动 cv.tex 后重新运行本脚本即可。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/cv/cv.tex"
OUT="$REPO_ROOT/files/Zhiqun_Xiao_CV.pdf"

cd "$(dirname "$SRC")"

# xelatex 需要跑两遍才能稳定写入交叉引用；这里跑两遍并只保留最后一遍的输出
for pass in 1 2; do
  echo "==> xelatex (pass $pass/2)"
  xelatex -interaction=nonstopmode -halt-on-error cv.tex > /tmp/cv_build_$pass.log 2>&1 || {
    echo "编译失败，错误摘要：" >&2
    grep -E "^!|^l\.[0-9]+" /tmp/cv_build_$pass.log | head -20 >&2
    exit 1
  }
done

# 校验：必须是单页，且内容不能贴到纸张底边
PAGES=$(pdfinfo cv.pdf | awk '/^Pages/{print $2}')
REMAIN=$(pdftotext -f 1 -l 1 -bbox cv.pdf - | python3 -c '
import sys, re
out = sys.stdin.read()
ys = [float(m) for m in re.findall(r"yMax=\"([\d.]+)\"", out)]
h  = float(re.search(r"height=\"([\d.]+)\"", out).group(1))
print(f"{h - max(ys):.1f}")')

echo "==> 页数: $PAGES，第 1 页底部余量: ${REMAIN}pt"

if [ "$PAGES" != "1" ]; then
  echo "警告：简历变成了 $PAGES 页。可以调小 cv/cv.tex 里的 \\enlargethispage 或收紧间距。" >&2
fi
python3 -c "import sys; sys.exit(0 if float('$REMAIN') > 8 else 1)" || \
  echo "警告：底部余量不足 8pt，打印可能贴边。" >&2

cp cv.pdf "$OUT"
rm -f cv.aux cv.log cv.out
echo "==> 已部署到 files/Zhiqun_Xiao_CV.pdf"
echo "    预览：http://127.0.0.1:4000/files/Zhiqun_Xiao_CV.pdf"
