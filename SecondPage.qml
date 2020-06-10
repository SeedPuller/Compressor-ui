import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import API.FileProcessor 1.0

Page {
    width: mainwindow.width
    height: mainwindow.height

    MyToolBar {
        button.text: "\ue801" // icon-left-open
        button.onClicked: stackView.pop()
        text.color: "#FFFFFF"
        text.text: "Compressor"
    }

    Rectangle {
        id: filelistbackground
        width: mainwindow.width * 0.75
        height: mainwindow.height * 0.6
        anchors.centerIn: parent
        color: "#BDBDBD"
        radius: 10
        RowLayout {
            anchors.bottom: filelist.top
            anchors.left: filelist.left
            width: filelist.width
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            Text {
                text: "2/100"
                font.bold: Font.Bold
                Layout.preferredWidth: 10
            }
            Text {
                text: "Name"
                font.bold: Font.Bold
                Layout.preferredWidth: 20
            }
            Text {
                text: "Size"
                font.bold: Font.Bold
                Layout.preferredWidth: 15
            }
            Text {
                text: "Type"
                font.bold: Font.Bold
                Layout.preferredWidth: 10
            }
        }

        ListView {
            id: filelist
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            ScrollIndicator.vertical: ScrollIndicator { }
            clip: true
            model: mainmodel
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
                        anchors.leftMargin: 15
                        spacing: 15
                        Text {
                            Layout.preferredWidth: 9
                            color: "#FFFFFF"
                            text: "\uf15b"
                            font.family: "fontello"
                            font.pixelSize: 20
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 20
                            color: "#FFFFFF"
                            text: model.filename
                            font.pixelSize: 15
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 15
                            color: "#FFFFFF"
                            text: model.size
                            font.pixelSize: 15
                        }
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 10
                            color: "#FFFFFF"
                            text: model.type
                            font.pixelSize: 15
                        }
                    }
                }
            }
        }
        ListModel {
            id: listmodel
            ListElement { name: "file1.pdf" }
            ListElement { name: "file2.pdf" }
        }
    }
    Label {
        id: compressionratetext
        anchors.left: filelistbackground.left
        anchors.top: filelistbackground.bottom
        anchors.topMargin: 10
        property var cstates: ["Low", "Medium", "Extreme"]
        text: "Compression Rate: " + cstates[compressionrate.value]
        font.bold: Font.Bold
    }

    Slider {
        id: compressionrate
        anchors.left: filelistbackground.left
        anchors.leftMargin: -7
        anchors.top: compressionratetext.bottom
        anchors.topMargin: -5
        from: 0
        to: 2
        stepSize: 1
        snapMode: Slider.SnapOnRelease
    }

    MyButton {
        id: startbutton
        anchors.right: filelistbackground.right
        anchors.top: filelistbackground.bottom
        anchors.topMargin: 10
        text: "Compress!"
        width: 200
        bgitem.color: "#1C70E4"
        bgitem.radius: 10
        contentText.color: "#FFFFFF"
        font.bold: Font.Bold
        font.pixelSize: 15
        onClicked:  {
            footerrect.height = 100
            estimatedtime.y = -footerrect.height + 60
            filep.startprocess()
        }
    }

    Canvas {
        id: staticcanvas
        width: parent.width
        height: 110
        anchors.bottom: footerrect.top
//                anchors.bottomMargin: 10
        onPaint: {
            var ctx = getContext("2d")
            function drawBezierSplit(ctx, x0, y0, x1, y1, x2, y2, t0, t1) {

                if( 0.0 == t0 && t1 == 1.0 ) {
                    ctx.moveTo( x0, y0 );
                    ctx.quadraticCurveTo( x1, y1, x2, y2 );
                    return
                } else if( t0 != t1 ) {
                    var t00 = t0 * t0,
                        t01 = 1.0 - t0,
                        t02 = t01 * t01,
                        t03 = 2.0 * t0 * t01;

                    var nx0 = t02 * x0 + t03 * x1 + t00 * x2,
                        ny0 = t02 * y0 + t03 * y1 + t00 * y2;

                    t00 = t1 * t1;
                    t01 = 1.0 - t1;
                    t02 = t01 * t01;
                    t03 = 2.0 * t1 * t01;

                    var nx2 = t02 * x0 + t03 * x1 + t00 * x2,
                        ny2 = t02 * y0 + t03 * y1 + t00 * y2;

                    var nx1 = lerp ( lerp ( x0 , x1 , t0 ) , lerp ( x1 , x2 , t0 ) , t1 ),
                        ny1 = lerp ( lerp ( y0 , y1 , t0 ) , lerp ( y1 , y2 , t0 ) , t1 );

                    ctx.moveTo( nx0, ny0 );
                    ctx.quadraticCurveTo( nx1, ny1, nx2, ny2 );
                }
            }

            /**
             * Linearly interpolate between two numbers v0, v1 by t
             */
            function lerp(v0, v1, t) {
                return ( 1.0 - t ) * v0 + t * v1;
            }
            ctx.lineJoin = 'round'
            ctx.lineWidth = 3
            ctx.strokeStyle = "#1C70E4"
            ctx.fillStyle= "#FFFFFF"
//                    ctx.save();
            ctx.beginPath();
            ctx.moveTo(0, 100);
            ctx.lineTo(40 * (staticcanvas.width / 100), 100);
            drawBezierSplit(ctx, (40 * (staticcanvas.width / 100)) - 1, 100, (50 * (staticcanvas.width / 100)), 50, (60 * (staticcanvas.width / 100)), 100, 0, 1);
            ctx.lineTo(staticcanvas.width, 100);
//                    ctx.restore();
            ctx.fill()
            ctx.globalAlpha=0.5
            ctx.stroke()
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: !footerrect.isenabled ? "Ready!" : progresscanvas.value + "%"
            font.bold: Font.Bold
            font.pixelSize: 15
        }
    }

    Canvas {
        id: progresscanvas
        width: parent.width
        height: 110
        x: staticcanvas.x
        y: staticcanvas.y
        property var value: 0
        property bool running: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, progresscanvas.width, progresscanvas.height)
            if (progresscanvas.value == 0) {
                ctx.clearRect(0, 0, progresscanvas.width, progresscanvas.height)
                return
            }

            function drawBezierSplit(ctx, x0, y0, x1, y1, x2, y2, t0, t1) {

                if( 0.0 == t0 && t1 == 1.0 ) {
                    ctx.moveTo( x0, y0 );
                    ctx.quadraticCurveTo( x1, y1, x2, y2 );
                } else if( t0 != t1 ) {
                    var t00 = t0 * t0,
                        t01 = 1.0 - t0,
                        t02 = t01 * t01,
                        t03 = 2.0 * t0 * t01;

                    var nx0 = t02 * x0 + t03 * x1 + t00 * x2,
                        ny0 = t02 * y0 + t03 * y1 + t00 * y2;

                    t00 = t1 * t1;
                    t01 = 1.0 - t1;
                    t02 = t01 * t01;
                    t03 = 2.0 * t1 * t01;

                    var nx2 = t02 * x0 + t03 * x1 + t00 * x2,
                        ny2 = t02 * y0 + t03 * y1 + t00 * y2;

                    var nx1 = lerp ( lerp ( x0 , x1 , t0 ) , lerp ( x1 , x2 , t0 ) , t1 ),
                        ny1 = lerp ( lerp ( y0 , y1 , t0 ) , lerp ( y1 , y2 , t0 ) , t1 );

                    ctx.moveTo( nx0, ny0 );
                    ctx.quadraticCurveTo( nx1, ny1, nx2, ny2 );
                }
            }

            /**
             * Linearly interpolate between two numbers v0, v1 by t
             */
            function lerp(v0, v1, t) {
                return ( 1.0 - t ) * v0 + t * v1;
            }
//                    ctx.clearRect(0, 0, progresscanvas.width, progresscanvas.height)
            var x = progresscanvas.value * (progresscanvas.width / 100)
            var firstlineX = progresscanvas.value <= 40 ? x : 40 * (progresscanvas.width / 100)
            ctx.lineJoin = 'round'
            ctx.lineWidth = 4
            ctx.strokeStyle = "#008D21"
            ctx.beginPath();
            ctx.moveTo(0, 100);
            ctx.lineTo(firstlineX, 100);
            if (progresscanvas.value <= 40) {
                ctx.stroke()
                return
            }
            if (progresscanvas.value <= 60) {
                drawBezierSplit(ctx, (40 * (progresscanvas.width / 100)) - 1, 100, (50 * (progresscanvas.width / 100)), 50, (60 * (progresscanvas.width / 100)), 100, 0, (progresscanvas.value % 40) * 0.05);
                ctx.stroke()
                return
            }
            drawBezierSplit(ctx, (40 * (progresscanvas.width / 100)) - 1, 100, (50 * (progresscanvas.width / 100)), 50, (60 * (progresscanvas.width / 100)), 100, 0, 1);
            ctx.lineTo(x, 100);
            ctx.stroke()
        }
    }

    Rectangle {
        id: footerrect
        width: parent.width
        height: 0
        property bool isenabled: height != 0 ? true : false
        anchors.bottom: parent.bottom
        Behavior on height {
            NumberAnimation {
                duration: 300
            }
        }
        MouseArea {
            // this is just for neutralize the background button pressing
            anchors.fill: parent
        }

        MyButton {
            id: puasebutton
            anchors.left: parent.left
            anchors.leftMargin: width - width / 4
            width: 200
            height: 50
            text: "Pause"
            bgitem.color: "#01579B"
            bgitem.radius: 10
            contentText.color: "#FFFFFF"
            font.bold: Font.Bold
            font.pixelSize: 15
            texticon.visible: true
            texticon.text: "\ue803"
            onClicked:  {
                if (progresscanvas.value == 100) {
                    return
                }

                progresscanvas.value += 5
                progresscanvas.requestPaint()
            }
        }
        MyButton {
            id: cancelbutton
            anchors.left: puasebutton.right
            anchors.leftMargin: width - width / 6
            width: 200
            height: 50

            text: "Cancel"
            bgitem.color: "#D32F2F"
            bgitem.radius: 10
            contentText.color: "#FFFFFF"
            font.bold: Font.Bold
            font.pixelSize: 15
            texticon.visible: true
            texticon.text: "\ue800"
            texticon.font.pixelSize: 18
            onClicked:  {
                progresscanvas.value = 0
                progresscanvas.requestPaint()
                footerrect.height = 0
                estimatedtime.y = parent.height
            }
        }
        Rectangle {
            id: estimatedtime
            width: 200
            height: 60
            y: parent.height + 30
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: "#1C70E4"
            border.width: 3
            radius: 10
            Text {
                id: estimatedtimetext
                y: 12
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Estimated Size: 5MB"
                font.bold: Font.Bold
                font.pixelSize: 15
            }
            Behavior on y {
                NumberAnimation {
                    duration: 300
                }
            }
        }
    }

    FileProcessor {
        id: filep
        property bool started: false
        function startprocess() {
            var count = filelist.count
            filep.started = true
//            var percent = 100 / count
            progresscanvas.value += 5
            progresscanvas.requestPaint()
            for (var i=0; i < count; ++i) {
                if (filep.copy(mainmodel.getFileInfo(i))){
//                    progresscanvas.value += percent
//                    progresscanvas.requestPaint()
                }

            }
        }
    }
    Timer {
        id: timer
        interval: 200
        onTriggered: {
            if (!filep.started) {
                return
            }

            if (progresscanvas.value >= 100) {
                filep.started = false
                popup.open()
                return
            }
            var value = progresscanvas.value
            value += 4
            value = value > 100 ? 100 : value
            progresscanvas.value = value
            progresscanvas.requestPaint()
        }
        repeat: true
        running: true
    }
    Popup {
        id: popup
        width: mainwindow.width * 0.8 ; height: mainwindow.height * 0.7
        anchors.centerIn: parent
        focus: true
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            anchors.fill: parent
            border.width: 5
            border.color: "#1C70E4"
            radius: 10
            Image {
                id: completeimg
                asynchronous: true
                source: "pic/Group 10.svg"
                anchors.centerIn: parent
                width: parent.width / 3
                height: parent.height / 3
            }
            Label {
                anchors.bottom: completeimg.top
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Hooray! Job Done!"
                font.bold: Font.Bold
                font.pixelSize: 30
            }
            MyButton {
                anchors.top: completeimg.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 70
                text: "OK"
                bgitem.color: "#1C70E4"
                bgitem.radius: 10
                contentText.color: "#FFFFFF"
                font.bold: Font.Bold
                font.pixelSize: 20
//                texticon.visible: true
//                texticon.text: "\ue803"
                onClicked:  {
                    popup.close()
//                    stackView.pop()
                }
            }
        }
    }

}
