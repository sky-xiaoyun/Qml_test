/****************************************************************************
** Meta object code from reading C++ file 'LogModel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.14.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../LogModel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'LogModel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.14.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_LogModel_t {
    QByteArrayData data[19];
    char stringdata0[176];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_LogModel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_LogModel_t qt_meta_stringdata_LogModel = {
    {
QT_MOC_LITERAL(0, 0, 8), // "LogModel"
QT_MOC_LITERAL(1, 9, 12), // "countChanged"
QT_MOC_LITERAL(2, 22, 0), // ""
QT_MOC_LITERAL(3, 23, 17), // "matchCountChanged"
QT_MOC_LITERAL(4, 41, 16), // "selectionChanged"
QT_MOC_LITERAL(5, 58, 10), // "matchRowAt"
QT_MOC_LITERAL(6, 69, 5), // "index"
QT_MOC_LITERAL(7, 75, 9), // "selectRow"
QT_MOC_LITERAL(8, 85, 3), // "row"
QT_MOC_LITERAL(9, 89, 8), // "loadFile"
QT_MOC_LITERAL(10, 98, 4), // "path"
QT_MOC_LITERAL(11, 103, 13), // "filterByLevel"
QT_MOC_LITERAL(12, 117, 5), // "level"
QT_MOC_LITERAL(13, 123, 6), // "search"
QT_MOC_LITERAL(14, 130, 7), // "keyword"
QT_MOC_LITERAL(15, 138, 5), // "clear"
QT_MOC_LITERAL(16, 144, 5), // "count"
QT_MOC_LITERAL(17, 150, 10), // "matchCount"
QT_MOC_LITERAL(18, 161, 14) // "selectionCount"

    },
    "LogModel\0countChanged\0\0matchCountChanged\0"
    "selectionChanged\0matchRowAt\0index\0"
    "selectRow\0row\0loadFile\0path\0filterByLevel\0"
    "level\0search\0keyword\0clear\0count\0"
    "matchCount\0selectionCount"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LogModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       3,   78, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   59,    2, 0x06 /* Public */,
       3,    0,   60,    2, 0x06 /* Public */,
       4,    0,   61,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       5,    1,   62,    2, 0x02 /* Public */,
       7,    1,   65,    2, 0x02 /* Public */,
       9,    1,   68,    2, 0x02 /* Public */,
      11,    1,   71,    2, 0x02 /* Public */,
      13,    1,   74,    2, 0x02 /* Public */,
      15,    0,   77,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Int, QMetaType::Int,    6,
    QMetaType::Void, QMetaType::Int,    8,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void, QMetaType::QString,   12,
    QMetaType::Void, QMetaType::QString,   14,
    QMetaType::Void,

 // properties: name, type, flags
      16, QMetaType::Int, 0x00495001,
      17, QMetaType::Int, 0x00495001,
      18, QMetaType::Int, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

void LogModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<LogModel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->countChanged(); break;
        case 1: _t->matchCountChanged(); break;
        case 2: _t->selectionChanged(); break;
        case 3: { int _r = _t->matchRowAt((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 4: _t->selectRow((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 5: _t->loadFile((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: _t->filterByLevel((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 7: _t->search((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 8: _t->clear(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (LogModel::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&LogModel::countChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (LogModel::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&LogModel::matchCountChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (LogModel::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&LogModel::selectionChanged)) {
                *result = 2;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<LogModel *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->count(); break;
        case 1: *reinterpret_cast< int*>(_v) = _t->matchCount(); break;
        case 2: *reinterpret_cast< int*>(_v) = _t->selectionCount(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject LogModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QAbstractListModel::staticMetaObject>(),
    qt_meta_stringdata_LogModel.data,
    qt_meta_data_LogModel,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *LogModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LogModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_LogModel.stringdata0))
        return static_cast<void*>(this);
    return QAbstractListModel::qt_metacast(_clname);
}

int LogModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void LogModel::countChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void LogModel::matchCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void LogModel::selectionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
