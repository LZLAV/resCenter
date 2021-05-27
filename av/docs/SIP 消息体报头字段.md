## SIP 消息体报头字段

### Content-Encoding

**Content-Encoding** 头字段用于表示所列出的编码方案已应用于邮件正文。它允许UAS确定解释消息体所必需的解码方案。

- 仅可以使用在允许 - 编码头部字段中列出的那些编码方案。
- 紧凑形式是 **e** 。

```
Example:
Content-Encoding: text/plain
e: gzip
```

### Content-Disposition

**Content-Disposition** 头字段用于描述消息体的功能。 值包括会话，图标，警报和呈现。

值会话指示消息体包含用于描述媒体会话的信息。

### Content-Language

**Content-Language** 头字段用于指示邮件正文的语言。 它包含一个标识语言的语言标记。

```
Example:
Content-Language: en
```

### Content-Length

**Content-Length** 用于指示消息体中的八位字节数。

Content-Length:0表示没有消息体。

### Content-Type

**Content-Type** 头字段用于指定邮件正文中的Internet媒体类型。

- **Content-Type** 头字段用于指定邮件正文中的Internet媒体类型。...
- 如果此头字段不存在，则假定为application / sdp。
- 如果请求中存在Accept头字段，则响应Content-Type必须包含列出的类型，或者必须返回415不支持的媒体类型响应。
- 紧凑形式是 **c** 。

```
Example:
Content-Type: application/sdp
```

### MIME-Version

**MIME-Version** 头字段用于指示用于构造消息体的MIME协议的版本。

SIP，如HTTP，不被认为是MIME兼容，因为解析和语义由SIP标准定义，而不是MIME规范。 版本1.0是默认值。

```
Example:
MIME-Version: 1.0
```

