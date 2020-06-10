#include "fileprocessor.h"

FileProcessor::FileProcessor(QObject *parent) : QObject(parent)
{

}

bool FileProcessor::copy(const QString &filepath, const QString& filename)
{
    QDateTime date = QDateTime::currentDateTime();
    return QFile::copy(filepath, "/home/moorko/Desktop/test/" + date.toString("dd-MM-yy-hh-mm-ss-") + filename);
}

bool FileProcessor::copy(const QStringList fileinfos)
{
    return copy(fileinfos[0], fileinfos[1]);
}
