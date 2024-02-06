// Message is the base payload for all lobbies
// type Message struct {
// 	Timestamp int64  `json:"timestamp"`
// 	LobbyID   string `json:"lobbyId"`
// 	Owner     string `json:"owner"`
// 	MsgType   int    `json:"msgType"`
// 	Payload   string `json:"payload"`
// }

typedef Message = {
	?timestamp:Int,
	lobbyID:String,
	owner:String,
	msgType:Int,
	payload:String,
};