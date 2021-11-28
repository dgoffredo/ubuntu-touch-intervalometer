/*
 * Copyright (C) 2021  David Goffredo
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * intervalometer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtMultimedia 5.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import Example 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'intervalometer.dgoffredo'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Intervalometer')
        }

        ColumnLayout {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Label {
                id: label
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr('Press the button below and check the logs!')
            }

            Button {
                Layout.preferredHeight: 400
                // height: 400
                // Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr('Press here!')
                onClicked: {
                    Example.speak()
                    if (timer.running) {
                        label.text = "Autocapture Disabled"
                        photoPreview.source = "";
                    } else {
                        label.text = "Autocapture Enabled"
                    }
                    timer.running = !timer.running
                }
            }

            Timer {
                id: timer
                interval: 15 * 60 * 1000  // milliseconds
                running: false
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    label.text = Date().toString()
                    camera.imageCapture.capture()
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                // width: 400
                // height: 400
                Camera {
                    id: camera
                    // imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
                    exposure {
                        // exposureCompensation: -1.0
                        exposureMode: Camera.ExposurePortrait
                    }
                    focus.focusMode: Camera.FocusAuto
                    flash.mode: Camera.FlashOff
                    imageCapture {
                        // resolution: "3120x4160"
                        onCaptureFailed: { // (requestId, message)
                            console.log("in onCaptureFailed")
                        }
                        onImageCaptured: { // (requestId, preview)
                            console.log("in onImageCaptured")
                            photoPreview.source = preview  // Show the preview in an Image
                            console.log("captureResolution: ", this.captureResolution)
                        }
                        onImageMetadataAvailable: { // (requestId, key, value)
                            console.log("in onImageMetadataAvailable")
                        }
                        onImageSaved: { // (requestId, path)
                            console.log("in onImageSaved")
                        }
                    }
                }
                VideoOutput {
                    source: camera
                    anchors.fill: parent
                    focus : visible // to receive focus and capture key events when visible
                }
                Image {
                    id: photoPreview
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
