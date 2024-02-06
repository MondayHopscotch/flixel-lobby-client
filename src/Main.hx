package ;

import flixel.FlxG;
import haxe.Json;
import hx.ws.Types.MessageType;
import haxe.ui.HaxeUIApp;
import hx.ws.WebSocket;
import haxe.io.Bytes;

class Main {
    public static function main() {
        var app = new HaxeUIApp();
        app.ready(function() {
            FlxG.switchState(()->new LobbyState(app));
        });
    }
}
