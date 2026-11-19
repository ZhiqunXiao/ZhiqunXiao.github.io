# CV（PDF）构建说明

网站上的简历 PDF 由 LaTeX 源文件编译生成，而不是手工排版后导出。

## 文件位置

| 用途 | 路径 |
| :--- | :--- |
| LaTeX 源文件（**改这里**） | [`cv/cv.tex`](cv.tex) |
| 构建脚本 | [`cv/build.sh`](build.sh) |
| 生成并部署到网站的 PDF | [`files/Zhiqun_Xiao_CV.pdf`](../files/Zhiqun_Xiao_CV.pdf) |

网站通过 `/files/Zhiqun_Xiao_CV.pdf` 提供下载，CV 页面顶部的按钮指向它。

> 注意：`files/` 下的 PDF 是**生成物**，直接改它没有意义；要改内容请改 `cv/cv.tex` 后重新编译。

## 如何编译

在仓库根目录执行：

```bash
./cv/build.sh
```

脚本会做三件事：

1. 用 `xelatex` 编译两遍（确保交叉引用正确）
2. **校验结果是单页、且内容没有贴到纸张底边**
3. 复制到 `files/Zhiqun_Xiao_CV.pdf`，刷新网页即可看到

依赖：`xelatex`（TeX Live）。本机已安装，可用 `xelatex --version` 确认。

## 手动编译（不用脚本）

```bash
cd cv
xelatex cv.tex          # 跑两遍
xelatex cv.tex
cp cv.pdf ../files/Zhiqun_Xiao_CV.pdf
rm -f cv.aux cv.log cv.out
```

## 常见排版问题

简历目前是**单页**，空间很紧。如果新增内容后变成两页：

- 调小 `cv/cv.tex` 中的 `\enlargethispage{2\baselineskip}` 数值会让内容更紧凑；
  调大则会让这一页容纳更多内容（但底部余量会变小，注意别贴边）
- 也可以精简条目文字，或缩小 `geometry` 的 margin
- `build.sh` 会打印底部余量，低于 8pt 时会告警

## 编译后记得同步网页

PDF 是独立的。若修改了学历、论文、技能等信息，**还要同步改**：

- `_pages/cv.md` —— CV 网页版
- `_pages/about.md` —— 首页（若涉及概述性内容）

否则网页版与 PDF 会出现内容不一致。
