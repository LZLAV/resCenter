### SDP

#### SDP的格式

```
v=<version>

o=<username> <session id> <version> <network type> <address type> <address>

s=<session name>

i=<session description>

u=<URI>

e=<email address>

p=<phone number>

c=<network type> <address type> <connection address>

b=<modifier>:<bandwidth-value>

t=<start time> <stop time>

r=<repeat interval> <active duration> <list of offsets from start-time>

z=<adjustment time> <offset> <adjustment time> <offset> ....

k=<method>

k=<method>:<encryption key>

a=<attribute>

a=<attribute>:<value>

m=<media> <port> <transport> <fmt list>
```



#### SDP字段解释

v = （协议版本）

o = （所有者/创建者和会话标识符）

s = （会话名称）

i = * （会话信息）

u = * （URI 描述）

e = * （Email 地址）

p = * （电话号码）

c = * （连接信息）

b = * （带宽信息）

z = * （时间区域调整）

k = * （加密密钥）

a = * （0 个或多个会话属性行）

时间描述：

t = （会话活动时间）

r = * （0或多次重复次数）

媒体描述：

m = （媒体名称和传输地址）

i = * （媒体标题）

c = * （连接信息 — 如果包含在会话层则该字段可选）

b = * （带宽信息）

k = * （加密密钥）

a = * （0 个或多个媒体属性行）



#### 示例

```
	v=0
    o=- 3797763403 3797763403 IN IP4 192.168.1.101
    s=pjmedia
    t=0 0
    m=audio 4000 RTP/AVP 8 96
    c=IN IP4 192.168.1.101
    a=sendrecv
    a=rtpmap:96 telephone-event/8000
    a=fmtp:96 0-16
    a=ssrc:1907373119 cname:27e2ef9d2e8ef499
    m=video 4002 RTP/AVP 97
    c=IN IP4 192.168.1.101
    a=sendrecv
    a=rtpmap:97 H264/90000
    a=fmtp:97 profile-level-id=42e01f; packetization-mode=1
    a=ssrc:263362611 cname:27e2ef9d2e8ef499
```

