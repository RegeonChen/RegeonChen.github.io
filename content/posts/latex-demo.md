---
title: "LaTeX 数学公式测试"
date: 2026-07-06T15:00:00+08:00
draft: false
tags: ["LaTeX", "数学"]
categories: ["技术"]
math: true
summary: "测试 Hugo 博客中的 LaTeX 数学公式渲染效果。"
---

## 行内公式

爱因斯坦质能方程：$E = mc^2$

勾股定理：$a^2 + b^2 = c^2$

黄金分割比：$\varphi = \frac{1 + \sqrt{5}}{2}$

## 块级公式

### 欧拉公式

$$
e^{i\pi} + 1 = 0
$$

### 傅里叶变换

$$
\hat{f}(\xi) = \int_{-\infty}^{\infty} f(x) \, e^{-2\pi i \xi x} \, dx
$$

### 贝叶斯定理

$$
P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}
$$

### 矩阵

$$
\begin{bmatrix}
a_{11} & a_{12} & \cdots & a_{1n} \\\\
a_{21} & a_{22} & \cdots & a_{2n} \\\\
\vdots & \vdots & \ddots & \vdots \\\\
a_{m1} & a_{m2} & \cdots & a_{mn}
\end{bmatrix}
$$

### 多行对齐

$$
\begin{aligned}
\nabla \cdot \mathbf{E} &= \frac{\rho}{\varepsilon_0} \\\\
\nabla \cdot \mathbf{B} &= 0 \\\\
\nabla \times \mathbf{E} &= -\frac{\partial \mathbf{B}}{\partial t} \\\\
\nabla \times \mathbf{B} &= \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}
\end{aligned}
$$

## 化学方程式

$$
\ce{2H2 + O2 ->[\Delta] 2H2O}
$$

> 提示：新建文章时在 front matter 中添加 `math: true` 即可启用该页面的公式渲染。
