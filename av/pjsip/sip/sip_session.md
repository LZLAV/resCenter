### SIP_Session（会话）

处于媒体传输层。SIP 使用 SDP 来通知传输层（RTP）来创建、增加、移除和修改会话。

用于进行媒体流传送。当一方发出请求，而另外一方或多方接受请求并通过信令交互成功后才能建立会话。**具体而言就是通过offer/answer方式交换sdp的媒体。**

具体来说，INVITE中的消息体用sdp语言来描述自己可处理的媒体类型，200OK中带回UAS端可处理的媒体类型。这个时候媒体交换就算是完成了。也就是session建立起来了。

一次呼叫只能建立一次会话，但可以建立多个对话（Dialog），因为接受请求的可能不止一个。

一个呼叫是由一个会议中被同一个发起者邀请加入的所有成员组成的。*一个 SIP 呼叫用全局唯一呼叫标识（CALL_ID）来识别。*因此，如果一个用户被不同的人邀请参加同一个多点会议，每个邀请都有一个唯一的呼叫。



Cseq

其生存域是一个会话。用于将一个会话中的请求消息序列化，以便用于重复消息、“迟到”消息的检测，响应消息与相应请求消息的匹配等。包含两部分：一个32位的序列号，一个请求方法。
 通常在会话开始时确定一个初始值，其后再发送消息时将该值加1。主叫方与被叫叫各自维护自己的CSeq序列，互不干扰，这有点像TCP/IP中IP包的序列号。
 一个响应消息有与其对应的请求消息相同的CSeq值。



【注意】SIP中CANCEL消息与ACK消息总是比较特殊。CANCEL消息的CSeq中的序列号总是跟其要cancel的消息的相同，而对于ACK消息：如果它所要确认的是INVITE请求的non-2xx响应，则ACK消息的CSeq中的序列号与对应INVITE请求的相同；如果是2xx响应，则不同，此时ACK被当作一个新的事务。
