# HelloGodot — Windows / Android 双端游戏模板

一个可以直接开始开发的 Godot 工程：屏幕上只有一行 `Hello, World!`，但双端导出链路已经打通。

## 环境

| 项目 | 版本 / 路径 |
|---|---|
| 引擎 | Godot **4.7.2-stable**（GL Compatibility 渲染器，对老安卓机友好） |
| 编辑器 | `C:\Users\sxh705\godot\Godot_v4.7.2-stable_win64.exe` |
| 导出模板 | `%APPDATA%\Godot\export_templates\4.7.2.stable\` |
| JDK | Temurin **17.0.20.1**，`C:\Users\sxh705\godot\jdk-17.0.20.1+1` |
| Android SDK | `C:\Users\sxh705\godot\android-sdk`（platform-tools / build-tools 36.0.0 / android-36） |
| 调试签名 | `C:\Users\sxh705\.android\debug.keystore`（别名 androiddebugkey，口令 android） |

`JAVA_HOME`、`ANDROID_HOME`、`ANDROID_SDK_ROOT` 已写入用户环境变量，新开的终端直接可用。

## 打开与运行

- 双击 **`启动Godot.cmd`** 打开编辑器。
- 编辑器里按 `F5` 运行；或命令行：
  ```
  "C:\Users\sxh705\godot\Godot_v4.7.2-stable_win64.exe" --path .
  ```

## 导出

- **Windows**：双击 `导出Windows.cmd` → `build/windows/HelloGodot.exe`（105 MB，实测约 10 秒）
- **Android**：双击 `导出Android.cmd` → `build/android/HelloGodot.apk`（77 MB，首次约 8 分钟）

首次导出 APK 会调用 Gradle 拉取依赖（实测写入 `C:\Users\sxh705\.gradle` 约 **1.2 GB**），之后是增量构建。
Gradle 已配置走 `127.0.0.1:7897` 代理。手机连上后 `adb devices` 能看到设备即可直装：
```
adb install -r build/android/HelloGodot.apk
```

构建中间产物会堆在 `android/build/build/`（本次实测 839 MB），空间紧张时执行：
```
cd android/build && .\gradlew clean
```

> 新克隆本仓库后，Android 导出前需先还原构建模板里的两个大文件（因超 GitHub 100 MB 限制未入库）：
> 在编辑器中执行 **项目 → 安装 Android 构建模板**，或从
> `export_templates/4.7.2.stable/android_source.zip` 解压覆盖 `android/build/`。

## 已实测结果

| 产物 | 大小 | 校验 |
|---|---|---|
| `build/windows/HelloGodot.exe` | 105 MB | 无头启动正常，引擎 4.7.2 |
| `build/android/HelloGodot.apk` | 77 MB | `com.example.hellogodot`，targetSdk 36，arm64-v8a |

## 磁盘占用（实测）

| 路径 | 占用 |
|---|---|
| `C:\Users\sxh705\godot`（引擎 + JDK + SDK） | 1.1 GB |
| `%APPDATA%\Godot\export_templates`（全平台模板） | 2.0 GB |
| `C:\Users\sxh705\.gradle`（Gradle 依赖缓存） | 1.2 GB |
| 本工程（含 android 模板与导出产物） | 389 MB |

合计约 **4.7 GB**，安装后 C 盘剩余 **13 GB**。

## 工程结构

```
HelloGodot/
├─ project.godot        # 工程配置（窗口 1152x648，拉伸 canvas_items，竖屏）
├─ main.tscn            # 主场景：一个居中 Label
├─ icon.svg             # 应用图标
├─ export_presets.cfg   # 双端导出预设（Windows x86_64 / Android arm64-v8a）
├─ 启动Godot.cmd
├─ 导出Windows.cmd
└─ 导出Android.cmd
```

## 下一步可以做什么

1. 把 `main.tscn` 的 Label 换成一个 `CharacterBody2D` + 精灵，加 `_physics_process` 里的移动——这是 2D 手感的第一课。
2. 新建 `game.gd` 挂在根节点，用 `signal` 和 `@export` 组织逻辑。
3. 安卓打包体积：GL Compatibility + 只保留 arm64-v8a，APK 大约 20–30 MB；要上架 Google Play 需换 release keystore 并勾选 AAB 格式。
4. 想要手柄/触屏兼容，项目设置 → Input Map 里加动作，代码里用 `Input.get_vector()`。
