#ifndef FILEPROCESSOR_H
#define FILEPROCESSOR_H

#include <QObject>
#include <QFile>
#include <QDateTime>

class FileProcessor : public QObject
{
    Q_OBJECT
public:
    explicit FileProcessor(QObject *parent = nullptr);

public slots:
    bool copy(const QString& filepath, const QString& filename);
    bool copy(const QStringList fileinfos);
};

#endif // FILEPROCESSOR_H
