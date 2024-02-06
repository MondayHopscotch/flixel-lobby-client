import Types.Message;
import flixel.FlxG;
import flixel.FlxState;
import haxe.Json;
import hx.ws.Types.MessageType;
import haxe.ui.HaxeUIApp;
import hx.ws.WebSocket;
import haxe.io.Bytes;

class LobbyState extends FlxState {
	var app:HaxeUIApp;
	var mainMenu:MainView;
	var ws:WebSocket;

	public function new(app:HaxeUIApp) {
		super();
		this.app = app;
	}

	override function create() {
		super.create();
		mainMenu = new MainView();
		app.addComponent(mainMenu);

		ws = new WebSocket("ws://127.0.0.1:8080/join");
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
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			if (mainMenu.chatInput.text.length > 0) {
				var msgOut:Message = {
					lobbyID: "a63ij",
					owner: "flixel",
					msgType: 1,
					payload: mainMenu.chatInput.text,
				};
				ws.send(Json.stringify(msgOut));
			}
		}
	}
}