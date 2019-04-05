空格: `&nbsp` 或 `shift+space` (切换到全角模式)输入空格

居中: `<center> aaa </center>`, 和 html 是一样的

图片的大小: `<img src="url" style="zoom:50%"/>` 或 `<img src="url" width="50%" height="50%">`

## 数学公式
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

| 符号         | 代码         |
|--------------|--------------|
| $\pm$        | `\pm`        |
| $\times$     | `\times`     |
| $\div$       | `\div`       |
| $\mid$       | `\mid`       |
| $\nmid$      | `\nmid`      |
| $\cdot$      | `\cdot`      | (`\cdots` 是省略号 $\cdots$)
| $\circ$      | `\circ`      |
| $\ast$       | `\ast`       |
| $\bigodot$   | `\bigodot`   |
| $\bigotimes$ | `\bigotimes` |
| $\bigoplus$  | `\bigoplus`  |
| $\leq$       | `\leq`       |
| $\geq$       | `\geq`       |
| $\neq$       | `\neq`       |
| $\approx$    | `\approx`    |
| $\equiv$     | `\equiv`     |
| $\sum$       | `\sum`       |
| $\prod$      | `\prod`      |
| $\coprod$    | `\coprod`    |
