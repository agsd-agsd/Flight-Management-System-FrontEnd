/****************************************************************************
** Meta object code from reading C++ file 'CircularReveal.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../animationH/CircularReveal.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'CircularReveal.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14CircularRevealE_t {};
} // unnamed namespace

template <> constexpr inline auto CircularReveal::qt_create_metaobjectdata<qt_meta_tag_ZN14CircularRevealE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "CircularReveal",
        "targetChanged",
        "",
        "radiusChanged",
        "darkToLightChanged",
        "imageChanged",
        "animationFinished",
        "handleGrabResult",
        "start",
        "w",
        "h",
        "center",
        "radius",
        "target",
        "QQuickItem*",
        "darkToLight"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'targetChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'radiusChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'darkToLightChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'imageChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'animationFinished'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'handleGrabResult'
        QtMocHelpers::SlotData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'start'
        QtMocHelpers::MethodData<void(int, int, const QPoint &, int)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 9 }, { QMetaType::Int, 10 }, { QMetaType::QPoint, 11 }, { QMetaType::Int, 12 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'target'
        QtMocHelpers::PropertyData<QQuickItem*>(13, 0x80000000 | 14, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag, 0),
        // property 'radius'
        QtMocHelpers::PropertyData<int>(12, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable, 1),
        // property 'darkToLight'
        QtMocHelpers::PropertyData<bool>(15, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<CircularReveal, qt_meta_tag_ZN14CircularRevealE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject CircularReveal::staticMetaObject = { {
    QMetaObject::SuperData::link<QQuickPaintedItem::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14CircularRevealE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14CircularRevealE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14CircularRevealE_t>.metaTypes,
    nullptr
} };

void CircularReveal::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<CircularReveal *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->targetChanged(); break;
        case 1: _t->radiusChanged(); break;
        case 2: _t->darkToLightChanged(); break;
        case 3: _t->imageChanged(); break;
        case 4: _t->animationFinished(); break;
        case 5: _t->handleGrabResult(); break;
        case 6: _t->start((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QPoint>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[4]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (CircularReveal::*)()>(_a, &CircularReveal::targetChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (CircularReveal::*)()>(_a, &CircularReveal::radiusChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (CircularReveal::*)()>(_a, &CircularReveal::darkToLightChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (CircularReveal::*)()>(_a, &CircularReveal::imageChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (CircularReveal::*)()>(_a, &CircularReveal::animationFinished, 4))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickItem* >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QQuickItem**>(_v) = _t->_target; break;
        case 1: *reinterpret_cast<int*>(_v) = _t->_radius; break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->_darkToLight; break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0:
            if (QtMocHelpers::setProperty(_t->_target, *reinterpret_cast<QQuickItem**>(_v)))
                Q_EMIT _t->targetChanged();
            break;
        case 1:
            if (QtMocHelpers::setProperty(_t->_radius, *reinterpret_cast<int*>(_v)))
                Q_EMIT _t->radiusChanged();
            break;
        case 2:
            if (QtMocHelpers::setProperty(_t->_darkToLight, *reinterpret_cast<bool*>(_v)))
                Q_EMIT _t->darkToLightChanged();
            break;
        default: break;
        }
    }
}

const QMetaObject *CircularReveal::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CircularReveal::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14CircularRevealE_t>.strings))
        return static_cast<void*>(this);
    return QQuickPaintedItem::qt_metacast(_clname);
}

int CircularReveal::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickPaintedItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 7;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void CircularReveal::targetChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void CircularReveal::radiusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void CircularReveal::darkToLightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void CircularReveal::imageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void CircularReveal::animationFinished()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}
QT_WARNING_POP
