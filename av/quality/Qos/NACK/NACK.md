## NACK

实现	

​	SDP 配置支持 NACK 属性

流程

​	A发送数据到网关，网关针对上行请求NACK，转发数据包给B，同时Cache上行数据，B向网关请求NACK，由于网关的数据做了Cache，所以NACK的请求直接在服务器上回包。

触发条件

​	NACK的请求的触发条件也比较复杂，它依赖准确的RTT、NACK的重试次数、超时时间以及上行带宽。
