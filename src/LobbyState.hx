import flixel.util.FlxColor;
import flixel.addons.text.FlxTextInput;
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
		mainMenu.chatLog.allowInteraction = false;
		mainMenu.chatLog.allowFocus = false;
		mainMenu.chatLog.active = false;
		mainMenu.button1.onClick = function(e) {
			sendMessage();
		}

		ws = new WebSocket("ws://127.0.0.1:8080/join");
		ws.onmessage = function(message:MessageType) {
			var contents:String;
			switch (message) {
				case BytesMessage(content):
					var bytes = content.readAllAvailableBytes();
					contents = Std.string(bytes);
				case StrMessage(content):
					contents = content;
			}
			trace(contents);
			var msg = Json.parse(contents);
			trace(msg.payload);
			if (mainMenu.chatLog.text.length > 0) {
				mainMenu.chatLog.text += "\n";
			}

			var talker = msg.owner;
			if (talker == "flixel") {
				talker = "You";
			}
			var ts = Date.fromTime(msg.timestamp);
			var logLine = '${talker} (${DateTools.format(ts, "%H:%M:%S")}): ${msg.payload}';
			mainMenu.chatLog.text += logLine;
		}
		
		ws.onerror = function(error:Dynamic) {
			trace("an error occurred: ", error);
		}

		ws.onopen = function() {
			trace("opened");
			ws.send("a63ij");
		}
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			sendMessage();
		}
	}

	function sendMessage() {
		if (mainMenu.chatInput.text.length > 0) {
			var msgOut:Message = {
				lobbyID: "a63ij",
				owner: "flixel",
				msgType: 1,
				payload: mainMenu.chatInput.text,
			};
			ws.send(Json.stringify(msgOut));
			mainMenu.chatInput.text = "";
			mainMenu.chatInput.focus = true;
		}
	}
}