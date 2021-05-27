## SIP仅请求报头字段

### Authorization

授权报头字段用于将请求中的UA的凭证携带到服务器。

可以发送回复包含质询信息的 **401未授权**响应。

### Event

此标头字段用于 **SUBSCRIBE** 或 **NOTIFY** 方法中，以指示方法正在使用哪个事件包。

- 在SUBSCRIBE中，它列出客户端想要订阅的事件包。
- 在NOTIFY中，它列出通知包含有关的状态信息的事件包。

### Join

Join头字段在INVITE中用于请求将对话(会话)与现有对话(会话)连接。

- Join头字段的参数以与Replaces头字段类似的方式通过Call-ID，To标签和From标签标识对话框。
- 如果Join头域引用两个用户代理之间的点对点对话，Join头字段实际上是将呼叫转入电话会议的请求。
- 如果对话框已经是会议的一部分，则Join头字段是要添加到会议中的请求。

### Proxy-Authorization

代理授权报头字段用于将请求中的UA的凭证携带到服务器。

- 它可以被发送回答包含挑战信息的407代理认证请求响应。
- 接收包含代理授权报头字段的请求的代理搜索其自己的领域，并且如果找到，则其处理该条目。
- 如果凭据正确，则任何剩余的条目在转发到下一个代理时保留在请求中。

### Proxy-Require

Proxy-Require头字段用于列出UA需要代理来支持以处理请求的功能和扩展。

- 代理列出**不支持的标题**字段中的任何不支持的功能时，会返回420错误的扩展响应。
- 如果希望但不需要支持此选项，则会在**支持**头字段中列出。

### Max-Forwards

Max-Forwards报头字段用于指示SIP请求可能采用的最大跳数。

- 头域的值由转发请求的每个代理减少。
- 接收到具有零值的报头字段的代理丢弃该消息，并向始发者发送483 Too Many Hops响应。
- Max-Forwards是根据RFC 3261的请求中的强制报头字段。
- 建议值为70跳。

### Priority

优先级报头字段由UAC用来设置请求的紧急性。 价值观是非紧急，正常，紧急和紧急。

### Refer-To

Refer-To头字段是REFER请求中的必需头字段，其中包含要引用的URI或URL资源。 它可以包含从sip或sips到telURI的任何类型的URI。

### Referred-By

Referred-By报头字段是REFER请求中的可选报头字段和由REFER触发的请求。

- 它向触发请求的接收者提供作为REFER的结果生成请求的信息以及REFER的发起者。
- 可通过 **429提供Referror** 身份响应代码拒绝未签名的Referred-By头字段。

### Replaces

**Replaces** 用于将新呼叫替换为现有呼叫。

- 在已建立的对话中接收具有与现有对话匹配的Replaces头字段的另一INVITE的UA必须接受INVITE，用BYE终止现有对话，并且将所有资源和状态从现有对话转移到新建立的对话。
- 如果Replaces头字段没有匹配任何对话框，则必须拒绝INVITE，并返回481 Dialog Does Not Exist响应。

### Request-Disposition

请求处理头字段可以用于请求服务器进行代理，重定向。

```
Example:
Request-Disposition:redirect
```

### Require

**Require** 头字段用于列出UAC要求UAS支持以处理请求的功能和扩展。

A 420返回一个420扩展响应，列出不支持的头字段中的任何不支持的功能。

```
Example:
Require:rel100
```

### Route

**Route** 头字段用于为请求提供路由信息。

- RFC 3261引入两种类型的路由:**严格路由**和**松散路由**，它们具有与相同名称的IP路由模式相似的含义。
- 在严格路由中，代理必须使用Route头字段中的第一个URI来重写Request-URI，然后将其转发。
- 在松散路由中，代理不会重写Request-URI，而是将请求转发到Route头字段中的第一个URI或另一个松散的路由元素。
- 在松散路由中，请求必须路由通过路由列表中的每个服务器，然后它可以基于请求URI路由。
- 在严格路由中，请求必须只路由通过路由头字段中的服务器集，其中在每一跳处重写Request-URI。
- 代理或UAC可以通过lr参数的存在来判断路由集中的下一个元素是否支持松散路由。

```
Example:
Route: sip:proxy@example.com;lr
```

### PAck

在对PRACK请求的响应中使用 **RAck** 头字段，以可靠地确认包含RSeq头字段的临时响应。

- 其值是来自临时响应的CSeq和RSeq的组合。
- 对于每个可靠发送的响应，可靠的序列号递增。

```
Example:
PAck: 3452337 17 INVITE
```

### Session-Expires

**Session-Expires** 头字段用于指定会话的到期时间。

- 为了扩展会话，UA可以发送具有新的Session-Expires头字段的re-INVITE或UPDATE。
- 一旦呼叫建立，它就会出现。

### SIP-If-Match

SIP-If-Match报头字段是SIP发布机制的一部分。 它包含在PUBLISH请求中，用于刷新，修改或删除以前发布的状态。

- 头字段包含在对较早发布的2xx响应中的SIP-ETag头字段中返回的状态信息的实体标签。
- 如果实体标签不再有效，则服务器将返回412条件请求失败响应。

```
Example:
SIP-If-Match: 56jforRr1pd
```

### Subscription-State

Subscription-State头字段是NOTIFY请求中的必需头部字段。 它指示预订的当前状态。 定义的值包括活动，挂起或终止。

```
Example:
Subscription-State: terminated; reason = rejected
```

