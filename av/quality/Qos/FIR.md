## FIR

有一个新用户加入，网关会发送FIR。





严重丢包时可以通过发送关键帧请求进行画面恢复。
关键帧请求方式包括三种：
RTCP FIR：使用 RTCP Feedback 消息请求关键帧（完整帧）
RTCP PLI：关键帧丢包重传
SIP Info：


a=rtcp-fb:100 ccm fir
a=rtcp-fb:96 nack pli  