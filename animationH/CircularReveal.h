#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QPropertyAnimation>
#define Q_PROPERTY_AUTO_P(TYPE, M)                                                                 \
Q_PROPERTY(TYPE M MEMBER _##M NOTIFY M##Changed)                                               \
    public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(TYPE in_##M) {                                                                          \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
}                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
}                                                                                              \
                                                                                                   \
    private:                                                                                           \
    TYPE _##M;

#define Q_PROPERTY_AUTO(TYPE, M)                                                                   \
Q_PROPERTY(TYPE M MEMBER _##M NOTIFY M##Changed)                                               \
    public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(const TYPE &in_##M) {                                                                   \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
}                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
}                                                                                              \
                                                                                                   \
    private:                                                                                           \
    TYPE _##M;


#define Q_PROPERTY_READONLY_AUTO(TYPE, M)                                                          \
Q_PROPERTY(TYPE M READ M NOTIFY M##Changed FINAL)                                              \
    public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(const TYPE &in_##M) {                                                                   \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
}                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
}                                                                                              \
                                                                                                   \
    private:                                                                                           \
    TYPE _##M;

class CircularReveal : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY_AUTO_P(QQuickItem *, target)
    Q_PROPERTY_AUTO(int, radius)
    Q_PROPERTY_AUTO(bool, darkToLight)
public:
    explicit CircularReveal(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;
    [[maybe_unused]] Q_INVOKABLE void start(int w, int h, const QPoint &center, int radius);
    Q_SIGNAL void imageChanged();
    Q_SIGNAL void animationFinished();
    Q_SLOT void handleGrabResult();

private:
    QPropertyAnimation *_anim = nullptr;
    QImage _source;
    QPoint _center;
    QSharedPointer<QQuickItemGrabResult> _grabResult;
};
