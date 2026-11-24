#!/usr/bin/env bash
# 编译 CV 的 LaTeX 源并部署到网站
#
#   用法：./cv/build.sh          # 中英文都编译
#         ./cv/build.sh en       # 只编译英文
#         ./cv/build.sh zh       # 只编译中文
#
# 源文件：cv/cv.tex      （英文）
#         cv/cv-zh.tex   （中文，作者：肖志群）
# 产物  ：files/Zhiqun_Xiao_CV.pdf     英文版
#         files/Zhiqun_Xiao_CV_zh.pdf  中文版
#
# 依赖：xelatex（TeX Live）+ 中文环境需思源黑体（fonts-noto-cjk，本机已装）
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT/cv"

# 校验单页 + 底部余量；$1=pdf 路径，$2=源文件名（用于告警提示）
check_and_deploy() {
  local pdf="$1" src="$2" out="$3"
  local pages remain

  pages=$(pdfinfo "$pdf" | awk '/^Pages/{print $2}')
  remain=$(pdftotext -f 1 -l 1 -bbox "$pdf" - | python3 -c '
import sys, re
out = sys.stdin.read()
ys = [float(m) for m in re.findall(r"yMax=\"([\d.]+)\"", out)]
h  = float(re.search(r"height=\"([\d.]+)\"", out).group(1))
print(f"{h - max(ys):.1f}")')

  echo "==> $src -> 页数: $pages，底部余量: ${remain}pt"

  [ "$pages" = "1" ] || \
    echo "警告：$src 变成了 $pages 页。可调小 $src 里的 \\enlargethispage 或精简内容。" >&2
  python3 -c "import sys; sys.exit(0 if float('$remain') > 8 else 1)" || \
    echo "警告：$src 底部余量不足 8pt，打印可能贴边。" >&2

  cp "$pdf" "$REPO_ROOT/$out"
  echo "==> 已部署 $out"
}

build_one() {
  local src="$1" out="$2"
  for pass in 1 2; do
    echo "==> xelatex $src (pass $pass/2)"
    if ! xelatex -interaction=nonstopmode -halt-on-error "$src" > "/tmp/cv_build_${src}_$pass.log" 2>&1; then
      echo "编译失败：$src，错误摘要：" >&2
      grep -E "^!|^l\.[0-9]+" "/tmp/cv_build_${src}_$pass.log" | head -20 >&2
      exit 1
    fi
  done
  check_and_deploy "${src%.tex}.pdf" "$src" "$out"
}

case "${1:-all}" in
  en)  build_one cv.tex    files/Zhiqun_Xiao_CV.pdf ;;
  zh)  build_one cv-zh.tex files/Zhiqun_Xiao_CV_zh.pdf ;;
  all) build_one cv.tex    files/Zhiqun_Xiao_CV.pdf
       build_one cv-zh.tex files/Zhiqun_Xiao_CV_zh.pdf ;;
  *)   echo "用法：$0 [en|zh|all]" >&2; exit 2 ;;
esac

rm -f ./*.aux ./*.log ./*.out
echo
echo "==> 完成。预览："
echo "    英文 http://127.0.0.1:4000/files/Zhiqun_Xiao_CV.pdf"
echo "    中文 http://127.0.0.1:4000/files/Zhiqun_Xiao_CV_zh.pdf"
