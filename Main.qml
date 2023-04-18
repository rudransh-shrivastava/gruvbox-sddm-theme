
import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 500
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "white"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        //primaryScreen

        Clock {
            id: clock
            anchors.margins: 90
            anchors.bottom: parent.bottom; anchors.right: parent.right

            color: "#ea535c"
            timeFont.family: "Oxygen"
        }

        Rectangle {
            width: 300
            height: 180
            color: "#1d2021"
            anchors.centerIn: parent
            radius: 30

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 20

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Row {

                        TextBox {
                            id: user_entry
                            width: 250
                            radius: 30
                            color: Qt.rgba(0, 0, 0, 0.2)
                            borderColor: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            text: userModel.lastUser
                            font.pixelSize: 16
                            focusColor: Qt.rgba(0, 0, 0, 0.25)
                            hoverColor: Qt.rgba(0, 0, 0, 0.2)
                            textColor: "#dcca9e"

                            KeyNavigation.backtab: session; KeyNavigation.tab: pw_entry
                        }

                    }

                    Row {
                        PasswordBox {
                            id: pw_entry
                            radius: 30
                            width: 250
                            color: Qt.rgba(0, 0, 0, 0.2)
                            borderColor: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            focusColor: Qt.rgba(0, 0, 0, 0.25)
                            hoverColor: Qt.rgba(0, 0, 0, 0.2)
                            textColor: "#dcca9e"
                            focus: true

                            KeyNavigation.backtab: user_entry; KeyNavigation.tab: loginButton

                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(user_entry.text, pw_entry.text, session.index)
                                    event.accepted = true
                                }
                            }
                        }
                    }



                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            id: loginButton
                            radius: 30
                            text: textConstants.login
                            width: 150
                            color: Qt.rgba(0, 0, 0, 0.2)
                            textColor: "#dcca9e"
                            pressedColor: Qt.rgba(0.863, 0.792, 0.620, 0.25)
                            activeColor: Qt.rgba(0, 0, 0, 0.2)
                            font.pixelSize: 15
                            font.bold: false
                            onClicked: sddm.login(user_entry.text, pw_entry.text, session.index)
                            KeyNavigation.backtab: pw_entry; KeyNavigation.tab: restart
                        }
                    }

                }

            }
        }
    }


    Rectangle {
        id: comboBox
        width: parent.width - 10
        height: 40
        color: "transparent"
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {
            id: session
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 130
            color: "#1d2021"

            //focusColor: Qt.rgba(0, 0, 0, 0.25)
            hoverColor: Qt.rgba(0, 0, 0, 0.2)

            borderColor: "#1d2021"
            textColor: "#ea535c"
            arrowColor: "#1d2021"
            model: sessionModel
            index: sessionModel.lastIndex

            font.pixelSize: 16
            KeyNavigation.backtab: shutdown; KeyNavigation.tab: user_entry
        }
    }


        Rectangle {
            width: restart.width + shutdown.width + 20
            height: 40
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: restart
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: shutdown.left
            anchors.rightMargin: 10
            text: textConstants.reboot
            color: "#1d2021"
            textColor: "#dcca9e"
            pressedColor: Qt.rgba(0.863, 0.792, 0.620, 0.25)
            activeColor: Qt.rgba(0, 0, 0, 0.2)

            font.pixelSize: 15
            font.bold: false
            radius: 30
            onClicked: sddm.reboot()
            KeyNavigation.backtab: loginButton; KeyNavigation.tab: shutdown
        }

        Button {


            id: shutdown
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: textConstants.shutdown
            color: "#1d2021"
            textColor: "#dcca9e"
            pressedColor: Qt.rgba(0.863, 0.792, 0.620, 0.25)
            activeColor: Qt.rgba(0, 0, 0, 0.2)

            font.pixelSize: 15
            font.bold: false
            radius: 30

            onClicked: sddm.powerOff()
            KeyNavigation.backtab: restart; KeyNavigation.tab: session


            }

        }



    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
