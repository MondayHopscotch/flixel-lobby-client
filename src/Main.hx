package ;

import haxe.Json;
import hx.ws.Types.MessageType;
import haxe.ui.HaxeUIApp;
import hx.ws.WebSocket;
import haxe.io.Bytes;

class Main {
    public static function main() {
        var app = new HaxeUIApp();
        app.ready(function() {
            var mainMenu = new MainView();
            app.addComponent(mainMenu);
            app.start();

            var ws = new WebSocket("ws://127.0.0.1:8080/join");

            ws.onmessage = function(message:MessageType) {
                switch (message) {
                    case BytesMessage(content):
                        var allBytes = content.readAllAvailableBytes();
                        trace(allBytes);
                        var obj = Json.parse(Std.string(allBytes));
                        trace(obj.payload);
                        mainMenu.chatLog.text += "\n" + obj.payload;
                    case StrMessage(content):
                        var str = "echo: " + content;
                        trace(str);
                }
            }
            
            ws.onopen = function() {
                trace("opened");
                ws.send("a63ij");
            }

            // ws.open();
        });
    }
}
