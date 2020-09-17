## ijkplayer编译过程



按照 https://github.com/bilibili/ijkplayer 中的文档进行编译。

**备注：**

先打开module-default.sh，在尾部添加下面代码，要不然会编译失败，这里是一个大坑

```shell
 export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-linux-perf"
 export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-bzlib"
```

