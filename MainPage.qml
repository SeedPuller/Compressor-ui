import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

Page{
    width: mainwindow.width
    height: mainwindow.height
    Rectangle {
        x: parent.x - 20
        width: 140
        height: 50
        color: "#1C70E4"
        radius: 20
        Label {
            anchors.centerIn: parent
            text: "Compressor"
            color: "#FFFFFF"
            font.bold: Font.Bold
        }
    }

    RowLayout {
        anchors.centerIn: parent
        width: parent.width * 0.75
        height: parent.height * 0.75
        spacing: 20
        ColumnLayout {
            height: parent.height
            Layout.minimumWidth: parent.width * 0.1
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Canvas {
                    id: canvas
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    onPaint: {
                        var ctx = getContext("2d")
                        /*  rectangle with corner radius  */
                        var rectWidth = canvas.width - 20;
                        var rectHeight = canvas.height - 20;
                        var x = 20;
                        var y = 20;
                        var cornerRadius = 50;
                        ctx.setLineDash([4]);
                        ctx.lineWidth = 5;
                        ctx.strokeStyle = "#1C70E4"

                        ctx.beginPath();
                        ctx.moveTo(x + cornerRadius, y)
                        ctx.lineTo(rectWidth - cornerRadius, y)
                        ctx.arcTo(rectWidth, y, rectWidth, y + cornerRadius, cornerRadius)
                        ctx.lineTo(rectWidth, rectHeight - cornerRadius)
                        ctx.arcTo(rectWidth, rectHeight, rectWidth - cornerRadius, rectHeight, cornerRadius)
                        ctx.lineTo(x + cornerRadius, rectHeight)
                        ctx.arcTo(x, rectHeight, x, rectHeight - cornerRadius, cornerRadius)
                        ctx.lineTo(x , y + cornerRadius)
                        ctx.arcTo(x, y, x + cornerRadius, y, cornerRadius)
                        ctx.stroke();
                        ctx.closePath()
                    }
                }
                Image {
                    id: uploadimage
                    width: canvas.width / 2.2
                    height: canvas.height / 2.2
                    y: canvas.height / 4
                    source: "pic/upload.svg"
                    anchors.horizontalCenter: canvas.horizontalCenter
                    asynchronous: true
                    Behavior on y {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }
                Text {
                    id: droptext
                    anchors.horizontalCenter: canvas.horizontalCenter
                    anchors.top: uploadimage.bottom
                    anchors.topMargin: 10
                    text: "Drop Your Files Here"
                    font.bold: Font.Bold
                }
                Text {
                    id: choosetext
                    anchors.horizontalCenter: canvas.horizontalCenter
                    anchors.top: droptext.bottom
                    anchors.topMargin: 10
                    text: "or Press to Choose"
                    font.bold: Font.Bold
                }

                DropArea {
                    id: droparea
                    anchors.fill: canvas
                    onDropped: {
                        var url = String(drop.urls[0]).split("/")
                        listmodel.insert(0, {name: url[url.length - 1]})
                        mainmodel.prepareAndInsert(drop.urls[0])
                    }
                    onEntered: {
                        uploadimage.y -= 20
                    }
                    onExited: {
                        uploadimage.y += 20
                    }
                }
                MouseArea {
                    id: filemousearea
                    x: canvas.x
                    y: canvas.y
                    width: canvas.width
                    height: canvas.height
                    onClicked: {
                        filedialog.open()
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.preferredHeight: parent.parent.height * 0.80
                color: "#BDBDBD"
                radius: 10
                ListView {
                    id: filelist
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollIndicator.vertical: ScrollIndicator { }
                    add: Transition {
                        NumberAnimation {
                            property: "x"
                            from: -200
                            duration: 300
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            properties: "y"
                            duration: 200
                        }
                    }
                    clip: true
                    model: listmodel
                    delegate: Item {
                        id: del
                        width: filelist.width
                        height: 50
                        Rectangle {
                            color: "#039BE5"
                            width: parent.width
                            height: 48
                            radius: 10
                            RowLayout {
                                anchors.fill: parent
                                spacing: 20
                                Text {
//                                    Layout.preferredWidth: 9
                                    Layout.leftMargin: 10
                                    color: "#FFFFFF"
                                    text: "\uf15b"
                                    font.family: "fontello"
                                    font.pixelSize: 20
                                }
                                Text {
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.fillWidth: true
                                    color: "#FFFFFF"
                                    text: model.name
                                }
                            }
                        }
                    }
                }
                ListModel {
                    id: listmodel
//                    ListElement { name: "file1.pdf" }
                }
            }
            MyButton {
                text: "Next"
                Layout.fillWidth: true
                Layout.fillHeight: true
                bgitem.color: "#1C70E4"
                bgitem.radius: 10
                contentText.color: "#FFFFFF"
                font.bold: Font.Bold
                font.pixelSize: 15
                onClicked: {
                    stackView.push(secondpage)
                }
            }
        }
    }

    FileDialog {
        id: filedialog
        onAccepted: {
            var url = String(filedialog.fileUrl).split("/")
            listmodel.insert(0, {name: url[url.length - 1]})
            mainmodel.prepareAndInsert(filedialog.fileUrl)
//            mainwindow.filePaths.push(filedialog.fileUrl)
        }
    }
}
