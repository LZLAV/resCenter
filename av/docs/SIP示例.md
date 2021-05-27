# SIP示例

### 注册

UAC(模拟IPC)：

IP：192.168.10.117

Port：5061



UAS(模拟SIP服务器)：

IP：192.168.10.177

Port：5060

#### UAC向UAS注册

```
REGISTER sip:192.168.10.177:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.10.117:5061;rport=5061;branch=z9hG4bK2509000523;received=192.168.10.117
From: <sip:34020000001320000001@192.168.10.177>;tag=2577708869
To: <sip:34020000001320000001@192.168.10.177>
Call-ID: 939764460
CSeq: 1 REGISTER
Contact: <sip:34020000001320000001@192.168.10.117:5061;line=6513f93347c330b>
Max-Forwards: 70
User-Agent: eXosip/3.6.0
Expires: 3600
Authorization: Capability, algorithm="H:MD5"
Content-Length: 0
```

##### 字段说明

请求起始行：表示UAC向IP地址为192.168.10.177的服务器发起注册，SIP版本号为2.0

From字段：指明该REGISTER请求消息由UAS（IP地址：192.168.10.177）控制的UAC发起的

To字段：指明REGISTER请求接收方的地址。此时REGISTER请求的接收方为IP地址为192.168.10.177的UAS。（这个值和To头域的值相同，除非这个请求是第三方发起的注册请求。）

Call-ID字段：UAC发出的给某个注册服务器（registrar）的所有注册请求都应该有相同的Call-ID头域值。如果相同的客户端用了不同的Call-ID值，注册服务器(registrar)就不能检测是否一个REGISTER请求由于延时的关系导致了故障。

Cseq字段：Cseq值保证了REGISTER请求的正确顺序。一个UA为每一个具备相同的Call-ID的REGISTER请求顺序递增这个Cseq字段。

Contact字段：在REGISTER请求中的Contact字段指明用户可达位置。

Expires字段：表示该登记生存期为3600s。

Content-Length字段：表明此请求消息消息体的长度为空，即此消息不带会话描述。

#### UAS-->UAC

UAS返回401 Unauthorized（无权限）响应,表明要求对UAC进行用户认证，并且通过WWW-Authenticate字段携带UAS支持的认证方式，产生本次认证的nonce

```
SIP/2.0 401 Unauthorized
To: <sip:34020000001320000001@192.168.10.177>;tag=66081813_53173353_54026835-98f6-4d1e-b562-0d969636b944
Via: SIP/2.0/UDP 192.168.10.117:5061;rport=5061;branch=z9hG4bK2509000523;received=192.168.10.117
CSeq: 1 REGISTER
Call-ID: 939764460
From: <sip:34020000001320000001@192.168.10.177>;tag=2577708869
WWW-Authenticate: Digest realm="3402000000",nonce="324cab6e557268e0"
Content-Length: 0
```

#### UAC-->UAS

UAC重新向UAS发起注册请求，携带WWW-Authorization字段

```
REGISTER sip:192.168.10.177:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.10.117:5061;rport=5061;branch=z9hG4bK3163110852;received=192.168.10.117
From: <sip:34020000001320000001@192.168.10.177>;tag=2577708869
To: <sip:34020000001320000001@192.168.10.177>
Call-ID: 939764460
CSeq: 2 REGISTER
Contact: <sip:34020000001320000001@192.168.10.117:5061;line=6513f93347c330b>
Authorization: Digest username="34020000001320000001",realm="3402000000",nonce="324cab6e557268e0",uri="sip:192.168.10.177:5060",response="7f536c8ce38593239f9130e37a72276e",algorithm=MD5
Max-Forwards: 70
User-Agent: eXosip/3.6.0
Expires: 3600
Content-Length: 0
```

#### UAS-->UAC

UAS收到UAC的注册请求，首先检查NONCE的正确性，如果和在401 Unauthorized响应中产生的NONCE相同，则通过。否则，直接返回失败。然后，UAS会根据**NONCE**、用户名、密码（服务器端可以根据本地用户信息获取用户的密码）、URI等采用和终端相同的算法生成 RESPONSE，并且对此**RESPONSE**和请求消息中的RESPONSE进行比较，如果二者一致则用户认证成功，否则认证失败。此时，UAS返回200 OK响应消息，表明终端认证成功。

```
SIP/2.0 200 OK
To: <sip:34020000001320000001@192.168.10.177>;tag=31428812_53173353_376bd3d9-cb9d-4b4f-a950-da26d575cff5
Via: SIP/2.0/UDP 192.168.10.117:5061;rport=5061;branch=z9hG4bK3163110852;received=192.168.10.117
CSeq: 2 REGISTER
Call-ID: 939764460
From: <sip:34020000001320000001@192.168.10.177>;tag=2577708869
Contact: <sip:34020000001320000001@192.168.10.117:5061;line=6513f93347c330b>
Expires: 3600
Date: 2013-06-26T16:08:37.164
Content-Length: 0
```

