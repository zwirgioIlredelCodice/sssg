---
title: SSSG stupid static site generator
---

# How it works

[pandoc](https://pandoc.org) + [gnu make](https://www.gnu.org/software/make/manual/make.html)

## Demo

- [post1](posts/post1)
- [markdown demo](markdowndemo)

## Images 

![mosca](resources/mosca.jpg)


## code

```c
#include <stdio.h>

int main() {
    int acc = 1;
    for (int i = 0; i < 1000; i++) {
        acc *=i;
    }
    printf("a number: %d", acc);

    return 0:
}
```

## math with mathml

- inline math $\cos(x)^2$ formulas

- block

    $$
    \frac{n!}{k!(n-k)!} = \binom{n}{k}
    $$