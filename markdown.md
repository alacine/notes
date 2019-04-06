空格: `&nbsp` 或 `shift+space` (切换到全角模式)输入空格

居中: `<center> aaa </center>`, 和 html 是一样的

图片的大小: `<img src="url" style="zoom:50%"/>` 或 `<img src="url" width="50%" height="50%">`

## 数学公式

github 上 markdown 不支持显示数学公式, 解决方法
* codecogs 云服务, [线上生成](http://latex.codecogs.com/), 然后以`![](http://latex.codecogs.com/gif.latex?\\...)`方式使用
* chrome 插件: [MathJax Plugin for Github](https://chrome.google.com/webstore/detail/mathjax-plugin-for-github/ioemnmodlmafdkllaclgeombjnmnbima?utm_source=chrome-ntp-icon) 安装如果报错建议看这条 [issue](https://github.com/orsharir/github-mathjax/issues/24#issuecomment-462956434)

行内公式 `$公式$` , 独占一行 `$$公式$$`

分段函数, 例如
$$
f(x) = \begin{cases}
-1, & x \le -1\\
0, & -1 \le x \le 1\\
1, & x \ge 1
\end{cases}\tag{1}
$$
```
$$
f(x) = \begin{cases}
-1, & x \le -1\\
0, & -1 \le x \le 1\\
1, & x \ge 1
\end{cases}\tag{1}
$$
```

上下标 `\sideset{_1^2}{_3^4}A` 或单独 `_`右下标 `^`右上标
$$
\sideset{_1^2}{_3^4}A
$$

花括号`\{\}` 或 `\lbrace\rbrace`
$$
\lbrace x | x \le 3 \rbrace
$$

分数 `\frac{分母}{分子}` 或 `\cfrac`
$$
\frac{4}{5}, 4\cfrac{y}{x}
$$

开方 `\sqrt[次数]{被开方数}`
$$
\sqrt[a]{x}
$$

希腊字母

| 大写       | 代码       | 小写       | 代码       |
|------------|------------|------------|------------|
| $A$        | `A`        | $\alpha$   | `\alpha`   |
| $B$        | `B`        | $\beta$    | `\beta`    |
| $\Gamma$   | `\Gamma`   | $\gamma$   | `\gamma`   |
| $\Delta$   | `\Delta`   | $\delta$   | `\delta`   |
| $E$        | `E`        | $\epsilon$ | `\epsilon` |
| $Z$        | `Z`        | $\zeta$    | `\zeta`    |
| $H$        | `H`        | $\eta$     | `\eta`     |
| $\Theta$   | `\Theta`   | $\theta$   | `\theta`   |
| $I$        | `I`        | $\iota$    | `\iota`    |
| $K$        | `K`        | $\kappa$   | `\kappa`   |
| $\Lambda$  | `\Lambda`  | $\lambda$  | `\lambda`  |
| $M$        | `M`        | $\mu$      | `\mu`      |
| $N$        | `N`        | $\nu$      | `\nu`      |
| $\Xi$      | `\Xi`      | $\xi$      | `\xi`      |
| $O$        | `O`        | $\omicron$ | `\omicron` |
| $\Pi$      | `\Pi`      | $\pi$      | `\pi`      |
| $P$        | `P`        | $\rho$     | `\rho`     |
| $\Sigma$   | `\Sigma`   | $\sigma$   | `\sigma`   |
| $T$        | `T`        | $\tau$     | `\tau`     |
| $\Upsilon$ | `\Upsilon` | $\upsilon$ | `\upsilon` |
| $\Phi$     | `\Phi`     | $\phi$     | `\phi`     |
| $X$        | `X`        | $\chi$     | `\chi`     |
| $\Psi$     | `\Psi`     | $\psi$     | `\psi`     |
| $\Omega$   | `\Omega`   | $\omega$   | `\omega`   |

关系运算符号

| 符号         | 代码               |
|--------------|--------------------|
| $\pm$        | `\pm`              |
| $\times$     | `\times`           |
| $\div$       | `\div`             |
| $\mid$       | `\mid`             |
| $\not\mid$   | `\nmid` `\not\mid` |
| $\cdot$      | `\cdot`            |
| $\circ$      | `\circ`            |
| $\ast$       | `\ast`             |
| $\bigodot$   | `\bigodot`         |
| $\bigotimes$ | `\bigotimes`       |
| $\bigoplus$  | `\bigoplus`        |
| $\leq$       | `\leq`             |
| $\geq$       | `\geq`             |
| $\neq$       | `\neq`             |
| $\approx$    | `\approx`          |
| $\equiv$     | `\equiv`           |
| $\sum$       | `\sum`             |
| $\prod$      | `\prod`            |
| $\coprod$    | `\coprod`          |

(`\cdots` 是省略号 $\cdots$)

集合运算符

| 符号        | 代码        |
|-------------|-------------|
| $\emptyset$ | `\emptyset` |
| $\in$       | `\in`       |
| $\notin$    | `\notin`    |
| $\subset$   | `\subset`   |
| $\supset$   | `\supset`   |
| $\subseteq$ | `\subseteq` |
| $\supseteq$ | `\supseteq` |
| $\bigcap$   | `\bigcap`   |
| $\bigcup$   | `\bigcup`   |
| $\bigvee$   | `\bigvee`   |
| $\bigwedge$ | `\bigwedge` |
| $\biguplus$ | `\biguplus` |
| $\bigsqcup$ | `\bigsqcup` |

三角运算符

| 符号        | 代码        |
|-------------|-------------|
| $\bot$ | `\bot` |
| $\angle$ | `\angle` |
| $\sin$ | `\sin` |
| $\cos$ | `\cos` |
| $\tan$ | `\tan` |

微积分运算符

| 符号        | 代码        |
|-------------|-------------|
| $\prime$ | `\prime` |
| $\int$ | `\int` |
| $\iint$ | `\iint` |
| $\iiint$ | `\iiint` |
| $\iiiint$ | `\iiiint` |
| $\oint$ | `\oint` |
| $\lim$ | `\lim` |
| $\infty$ | `\infty` |
| $\nabla$ | `\nabla` |
| $\mathrm{d}$ | `\mathrm{d}` |
