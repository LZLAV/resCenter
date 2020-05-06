# PNG



### png最基本的文件内容

最基本的 PNG 文件内容是：

- 8 字节 magic number：用于识别 PNG 格式
- [IHDR]（Image Header） chunk：描述影像的维度、色彩深度、色彩格式、压缩类型等
- [IDAT]（Image Data）chunk：存储影像的像素数据
- [IEND]（Image End）chunk：PNG数据流结束

每个 chunk 的结构是：

- chunk 内容长度（4 字节）
- chunk 类型（4 字节）
- chunk 内容
- chunk 的 CRC（包括类型和内容