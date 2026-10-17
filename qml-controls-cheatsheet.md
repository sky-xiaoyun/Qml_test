# QML 控件速查表（Qt 5.14.2 / Qt Quick 2.14）

面向 Qt Widgets 背景的对照速查。QML 里没有"控件"这个统称，实际分两层：

- **基础元素层**：`import QtQuick 2.14` —— Rectangle、Text、Image 等可视积木，共同祖先是 Item
- **标准控件层**：`import QtQuick.Controls 2.14` —— Button、TextField 等成品控件

---

## 窗口与容器

| Qt Widgets | QML | 说明 |
|---|---|---|
| QMainWindow | ApplicationWindow | 带 menuBar / header / footer 的主窗口 |
| QDialog | Dialog | 弹出对话框 |
| QWidget（容器） | Item / Pane / Frame | 空容器 |
| QGroupBox | GroupBox | |
| QTabWidget | TabBar + StackLayout | 页签 + 页面切换 |
| QStackedWidget | StackLayout / StackView | |
| QScrollArea | ScrollView / Flickable | |
| QSplitter | SplitView | |
| QToolBar | ToolBar | |
| QMenuBar | MenuBar | |
| QStatusBar | ApplicationWindow.footer | |

## 文本

| Qt Widgets | QML | 说明 |
|---|---|---|
| QLabel | Label（Controls 2） / Text（基础） | |
| QLineEdit | TextField | |
| QTextEdit | TextArea | |
| QPlainTextEdit | TextArea | |
| 富文本显示 | Text | 支持 HTML 子集 |

## 按钮与选择

| Qt Widgets | QML | 说明 |
|---|---|---|
| QPushButton | Button | |
| QToolButton | ToolButton | |
| QCheckBox | CheckBox | |
| QRadioButton | RadioButton | |
| （无对应） | Switch | 滑动开关，移动风格 |
| （无对应） | DelayButton / RoundButton | 长按按钮 / 圆形按钮 |

## 数值输入与进度

| Qt Widgets | QML | 说明 |
|---|---|---|
| QComboBox | ComboBox | |
| QSlider | Slider / RangeSlider | RangeSlider 为双滑块 |
| QSpinBox | SpinBox | |
| QDial | Dial | |
| QProgressBar | ProgressBar | |
| （无对应） | BusyIndicator | 等待转圈 |
| （无对应） | Tumbler | 滚轮选择 |

## 列表与视图

| Qt Widgets | QML | 说明 |
|---|---|---|
| QListWidget | ListView + ListModel | |
| QListView | ListView | 也可直接接 C++ QAbstractItemModel |
| QTableWidget / QTableView | TableView | Qt 5.12+ |
| QTreeWidget / QTreeView | TreeView | Qt 5.14+（Controls 2） |
| 图标网格视图 | GridView | |
| QScrollBar | ScrollBar | 通常以 ScrollBar.vertical 附加使用 |
| （无对应） | Repeater | 按 model 重复生成元素 |
| （无对应） | Loader | 动态加载组件 |
| （无对应） | StackView / SwipeView | 页面栈 / 滑动翻页 |

## 菜单、弹窗与提示

| Qt Widgets | QML | 说明 |
|---|---|---|
| QMenu | Menu + MenuItem | |
| QMessageBox | MessageDialog | |
| QFileDialog | FileDialog | Qt.labs.platform 版本为系统原生外观 |
| QColorDialog | ColorDialog | |
| QFontDialog | FontDialog | |
| QToolTip | ToolTip | |
| QInputDialog | Dialog + TextField | 需自行组装 |
| QSystemTrayIcon | SystemTrayIcon | Qt.labs.platform |

## 布局

| Qt Widgets | QML | 说明 |
|---|---|---|
| QHBoxLayout | RowLayout / Row | RowLayout 来自 QtQuick.Layouts |
| QVBoxLayout | ColumnLayout / Column | |
| QGridLayout | GridLayout / Grid | |
| QFormLayout | （无直接对应） | 用 GridLayout 模拟 |
| setGeometry 手算 | anchors / x / y | 锚定系统优先 |

## 基础元素补给（Widgets 没有直接对应）

- **动画与状态**：PropertyAnimation、NumberAnimation、Behavior、Transition、State
- **绘图**：Canvas（2D 绘制）、Shape（矢量路径）、ShaderEffect
- **交互**：MouseArea、TapHandler、DragHandler、PinchArea
- **动态性**：Repeater、Loader、Flickable、OpacityMask

## import 速查（Qt 5.14 对应版本）

| 模块 | 版本 | 提供 |
|---|---|---|
| QtQuick | 2.14 | Rectangle、Text、Image、MouseArea、ListView、Repeater、Loader 等 |
| QtQuick.Window | 2.14 | Window |
| QtQuick.Controls | 2.14 | Button、TextField、CheckBox、Slider、Dialog、Menu 等 |
| QtQuick.Layouts | 1.14 | RowLayout、ColumnLayout、GridLayout、StackLayout、SplitView |
| QtQuick.Dialogs | 1.3 | FileDialog、MessageDialog（Qt 自绘） |
| Qt.labs.platform | 1.1 | 原生系统对话框、SystemTrayIcon |
| QtQuick.Shapes | 1.14 | Shape（矢量路径绘制） |

## 命名规律（记名字的快车道）

1. 控件名多数是"去 Q 前缀"直译：QPushButton → Button、QComboBox → ComboBox、QSpinBox → SpinBox
2. 属性平铺、不是 setter：直接写 `text`、`checked`、`value`、`from` / `to`、`enabled`、`visible`
3. 信号处理器 = `on` + 信号名首字母大写：`onClicked`、`onPressed`、`onTextChanged`、`onCurrentIndexChanged`
4. **QSS 样式表在 QML 里不存在**：外观靠属性 + 自定义 `background` / `contentItem` 组件
5. 控件尺寸交给 anchors 或 Layout，不要手算坐标

---
*生成于 QML 教学第 2 轮（2026-10-15），后续课程会逐个展开：布局 → 交互 → 动画 → 模型视图 → C++ 互操作。*
