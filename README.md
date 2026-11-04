# 星启 STARSPARK — Windows / Android 双端游戏模板

Godot 4.7 双端起步工程：开始页（游戏名 + 开始/设置按钮）→ 内容页；设置页可调音量与光标；手机端默认横屏。双端导出链路已实测打通。

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

## 游戏流程

```
start.tscn（开始页：星启 / STARSPARK + 开始游戏 / 设置）
  ├─→ game.tscn（内容页：大字"内容"，玩法从这里写起）
  └─→ settings.tscn（设置页：音量滑条 + 光标模式，改动即存档）
```

- **音量**：0–100 滑条，实时作用于 Master 总线
- **光标**：系统默认 / 隐藏光标 / 准星光标（触屏设备自动禁用该项）
- 两项设置持久化在 `user://settings.cfg`（Windows 在 `%APPDATA%\Godot\app_userdata\StarSpark\`，安卓在应用私有目录），启动时自动恢复
- 手机端横屏：`project.godot` 的 `display/window/handheld/orientation=4`（SCREEN_SENSOR_LANDSCAPE；Godot 枚举 0=横屏、1=竖屏，写 1 会锁成竖屏）

## 导出

- **Windows**：双击 `导出Windows.cmd` → `build/windows/StarSpark.exe`（约 104 MB，实测 5–15 秒）
- **Android**：双击 `导出Android.cmd` → `build/android/StarSpark.apk`（约 76 MB，增量 1–2 分钟，首次 3–6 分钟）

两个脚本都以**显式控制台窗口**执行：先打印工程路径、引擎版本、JDK / SDK / 签名库位置，再原样输出 Godot 与 Gradle 的全部日志，结束后停在 `Press any key`，窗口不闪退。界面上要能看见导出过程，不要用后台静默方式跑，否则长时间无输出时无法判断是卡住还是在编译。

失败时窗口同样保留，往上翻第一条 `ERROR` / `FAILURE` 即可；Gradle 明细在 `android/build/build/`。每次导出的结果另记一行在 `build/last-export.txt`（`ok` / `fail` + 退出码 + 产物路径），供脚本或人工快速判定。

可选参数：

```
导出Android.cmd /nopause      :: 跑完即退，不等人按键（自动化、CI 用）
set EXPORT_VERBOSE=1           :: 追加 Godot --verbose，日志更详细
```

Gradle 已配置走 `127.0.0.1:7897` 代理。手机连上后 `adb devices` 能看到设备即可直装：
```
adb install -r build/android/StarSpark.apk
```

构建中间产物会堆在 `android/build/build/`，空间紧张时执行：
```
cd android/build && .\gradlew clean
```

> 新克隆本仓库后，Android 导出前需先还原构建模板里的两个大文件（因超 GitHub 100 MB 限制未入库）：
> 在编辑器中执行 **项目 → 安装 Android 构建模板**，或从
> `export_templates/4.7.2.stable/android_source.zip` 解压覆盖 `android/build/`。

## 工程结构

```
HelloGodot/
├─ project.godot          # 工程配置（主场景、自动加载 Settings、横屏）
├─ scenes/
│  ├─ start.tscn          # 开始页
│  ├─ settings.tscn       # 设置页
│  └─ game.tscn           # 内容页
├─ scripts/
│  ├─ settings.gd         # 全局设置单例（音量/光标 + 存档）
│  ├─ start.gd
│  ├─ settings_ui.gd
│  └─ game.gd
├─ assets/
│  └─ cursor_crosshair.svg  # 准星光标图
├─ icon.svg
├─ export_presets.cfg     # 双端导出预设（Windows x86_64 / Android arm64-v8a）
├─ 启动Godot.cmd
├─ 导出Windows.cmd
└─ 导出Android.cmd
```

## 已实测结果

| 产物 | 大小 | 校验 |
|---|---|---|
| `build/windows/StarSpark.exe` | 105 MB | 无头启动正常，三场景加载无误 |
| `build/android/StarSpark.apk` | 77 MB | `com.example.starspark`，targetSdk 36，arm64-v8a，横屏 |

## 下一步可以做什么

1. 把 `game.tscn` 的"内容"换成真正的玩法：加一个 `CharacterBody2D` + 精灵，`_physics_process` 里写移动——这是 2D 手感的第一课。
2. 给开始页配 BGM：`AudioStreamPlayer` + `Settings` 单例已经接管了主音量，直接生效。
3. 准星图想换风格，改 `assets/cursor_crosshair.svg` 即可；想要更多光标选项，在 `scripts/settings.gd` 的 `_apply_cursor()` 里加分支。
4. 想要手柄/触屏兼容，项目设置 → Input Map 里加动作，代码里用 `Input.get_vector()`。
