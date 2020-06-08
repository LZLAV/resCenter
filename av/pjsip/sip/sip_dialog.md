### SIP_Dialog（对话）

处于信令层。

会话是两个UAs(user agent) 之间持续一段时间的端到端(peer-to-peer)的SIP 关系. **一个会话由一个Call-ID, 一个local tag 和 一个remote tag来标识**。会话过去也叫做 "call leg"。一个对话由SIP消息建立，就像用2xx响应INVITE请求。

**dialog的建立是客户端收到UAS的响应（To tag）时开始建立的。**收到180响应时建立dialog叫做早期对话（early dialog）,收到2XX的应答开始才是真正的dialog建立。

Dialog：维护peer to peer状态，目前只有invite和subscribe请求会触发dialog。其生命周期贯穿一个端到端会话的始终。

如下三个值相同代表同一个 dialog （会话）

- Call-id
- From tag
- To tag