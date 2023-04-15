
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
        //visible: primaryScreen

        Clock {
            id: clock
            anchors.margins: 90
            anchors.bottom: parent.bottom; anchors.right: parent.right

            color: "#ea535c"
            timeFont.family: "Oxygen"
        }

        Image {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(320, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)

            source: "rectangle.png"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 20

                Column {
                    width: parent.width
                    spacing: 5

                    TextBox {
                        id: name
                        width: parent.width; height: 50
                        text: userModel.lastUser
                        font.pixelSize: 30
			color: "#1d2021"
			textColor: "#dcca9e"

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4

                    PasswordBox {
                        id: password
                        width: parent.width; height: 50
                        font.pixelSize: 30
			color: "#1d2021"
			textColor: "#dcca9e"

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width
                    z: 100

                    Column {
                        z: 100
                        width: parent.width
                        spacing : 10
                        anchors.bottom: parent.bottom

                        ComboBox {
                            id: session
                            width: parent.width; height: 50
                            font.pixelSize: 30
                            color: "#1d2021"
			    textColor: "#dcca9e"
		  	    

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }
                }

                Row {
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
			color: "#1d2021"
			textColor: "#dcca9e"
			font.pixelSize: 30

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
			color: "#1d2021"
			textColor: "#dcca9e"
			font.pixelSize: 30

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }

		    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
			color: "#1d2021"
			textColor: "#dcca9e"
			font.pixelSize: 30


                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
