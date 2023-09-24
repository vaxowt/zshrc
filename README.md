# ZSH 配置文件

## 依赖

* [fzf](https://github.com/junegunn/fzf)
* [zoxide](https://github.com/ajeetdsouza/zoxide)

## 安装

克隆至 `${XDG_CONFIG_HOME}/zsh`，然后安装：

```sh
cd "${XDG_CONFIG_HOME}/zsh"
make install
```

安装插件管理器：

```bash
miniplug-self-update
```

安装插件：

```bash
miniplug install
```

## 插件管理

使用 [miniplug](https://github.com/YerinAlexey/miniplug) 作为插件管理器

```sh
# 更新所有插件
miniplug update
# 更新 miniplug 自身
miniplug-self-update
```
