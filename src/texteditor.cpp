#include "texteditor.h"

FileHelper::FileHelper(QObject *parent)
    : QObject(parent)
{

}

void FileHelper::addPath(const QString &path)
{
    emit newPath(path);
}
