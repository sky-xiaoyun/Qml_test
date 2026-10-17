pragma Singleton
import QtQuick 2.14

// ============================================================
// 全局色板（QML 单例）
// 全软件颜色只在这里定义，组件里统一用 Theme.xxx 引用；
// 换配色只改这个文件。qmldir 里用 "singleton Theme Theme.qml" 登记。
// ============================================================
QtObject {
    // ---------- 背景层 ----------
    readonly property color bg:           "#F1F5F9"   // 页面底（slate-100）
    readonly property color surface:      "#FFFFFF"   // 卡片 / 面板
    readonly property color bar:          "#501E293B" // 深色栏（80% 不透明）
    readonly property color barSolid:     "#FF1E293B" // 实心底栏
    readonly property color barDown:      "#0F172A"   // 深色栏按钮按下
    readonly property color dim:          "#990F172A" // 拖放遮罩

    // ---------- 文字 ----------
    readonly property color text:         "#0F172A"   // 主文字（正文）
    readonly property color textSub:      "#334155"   // 次要文字（时间戳）
    readonly property color textMuted:    "#64748B"   // 弱化文字
    readonly property color barText:      "#E2E8F0"   // 深色栏上的文字

    // ---------- 主色（交互强调） ----------
    readonly property color accent:       "#2563EB"
    readonly property color accentHover:  "#3B82F6"
    readonly property color accentDown:   "#1D4ED8"

    // ---------- 悬停（全软件统一） ----------
    readonly property color hoverRow:     "#E8EEF7"   // 列表行：比 DEBUG 底色深一档，悬停可辨
    readonly property color hoverBar:     "#334155"   // 深色栏按钮
    readonly property color hoverMenu:    "#1E293B2E" // 下拉项 / 菜单项（18% 深色）
    readonly property color glassLight:   "#99FFFFFF" // 栏上半透明控件（常态）
    readonly property color glassHover:   "#CCFFFFFF" // 栏上半透明控件（悬停）
    readonly property color glassPanel:   "#D9FFFFFF" // 弹出面板白罩

    // ---------- 选中 / 高亮 ----------
    readonly property color selected:     "#FDE047"   // 选中行（蓝-200）
    readonly property color current:      "#FDE047"   // 当前匹配行（黄-400）
    readonly property color match:        "#FEF08A"   // 搜索命中（黄-300）

    // ---------- 边框 / 分隔 ----------
    readonly property color border:       "#E2E8F0"
    readonly property color dividerDark:  "#475569"   // 深色栏分隔线

    // ---------- 级别色 ----------
    readonly property color errorBg:      "#FEF2F2"
    readonly property color warnBg:       "#FFFBEB"
    readonly property color debugBg:      "#F8FAFC"
    readonly property color errorBadgeBg: "#FEE2E2"
    readonly property color warnBadgeBg:  "#FEF3C7"
    readonly property color infoBadgeBg:  "#DBEAFE"
    readonly property color debugBadgeBg: "#F1F5F9"
    readonly property color errorText:    "#DC2626"
    readonly property color warnText:     "#D97706"
    readonly property color infoText:     "#2563EB"
    readonly property color debugText:    "#64748B"

    // ---------- 滚动条 ----------
    readonly property color scroll:       "#CBD5E1"
    readonly property color scrollHover:  "#94A3B8"

    // ---------- 状态栏辅助 ----------
    readonly property color amber:        "#FBBF24"   // 匹配计数
    readonly property color selectionText:"#93C5FD"   // 已选计数
}
