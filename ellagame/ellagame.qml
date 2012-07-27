import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: main
    width: 800
    height: 600
    color: "black"
    focus: true

    ParticleSystem {
        anchors.fill: parent
        ImageParticle {
            groups: ["stars"]
            anchors.fill: parent
            source: "star.png"
        }
        Emitter {
            group: "stars"
            emitRate: 10
            lifeSpan: 1600
            size: 24
            sizeVariation: 8
            anchors.fill: parent
        }
        Turbulence {
            anchors.fill: parent
            strength: 2
        }
    }

    Component {
        id: letter

        Item {
            id: letterItem
            x: offsetX - width/2
            y: offsetY - height/2

            property int offsetX
            property int offsetY
            property int duration: 1000
            property alias color: label.color
            property alias text: label.text

            Text {
                id: label
                anchors.centerIn: parent
                font { pixelSize: letterItem.height; family: "Courier"; bold: true }
            }

            SequentialAnimation {
                running: true
                ParallelAnimation {
                    NumberAnimation { target: letterItem; properties: "width,height"; to: 0; duration: letterItem.duration }
                    NumberAnimation { target: letterItem; property: "opacity"; to: 0; duration: letterItem.duration }
                }
                ScriptAction { script: letterItem.destroy(); }
            }
        }
    }

    ParticleSystem {
        ImageParticle {
            source: "star.png"
            alpha: 0
            alphaVariation: 0.4
            colorVariation: 1.0
        }

        Emitter {
            id: particles
            emitRate: 300
            lifeSpan: 800
            size: 16
            sizeVariation: 8
            speedFromMovement: 16
            speed: PointDirection {xVariation: 60; yVariation: 60;}
            acceleration: PointDirection {xVariation: 40; yVariation: 40;}

            Behavior on x { NumberAnimation { duration: 800; easing.type: Easing.OutQuad } }
            Behavior on y { NumberAnimation { duration: 800; easing.type: Easing.OutQuad } }
        }
    }

    Keys.onPressed: {
        var x = Math.random() * main.width;
        var y = Math.random() * main.height;
        var startingSize = 300 + Math.random() * 150;
        particles.x = x;
        particles.y = y;

        var obj = letter.createObject(main, { offsetX: x, offsetY: y,
                                      width: startingSize, height: startingSize,
                                      color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1),
                                      text: String.fromCharCode(event.key).toUpperCase() });
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
            particles.x = mouse.x;
            particles.y = mouse.y;
        }
    }
}
