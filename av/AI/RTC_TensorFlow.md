### RTC_TensorFlow

Python在众多编程语言中的热度一直稳居前五，热门程度可见一斑。 Python 拥有很活跃的社区和丰富的第三方库，Web 框架、爬虫框架、数据分析框架、机器学习框架等，开发者无需重复造轮子，可以用 Python 进行 Web 编程、网络编程，开发多媒体应用，进行数据分析，或实现图像识别等应用。其中图像识别是最热门的应用场景之一，也是与实时音视频契合度最高的应用场景之一。



RTC 与 TensorFlow 结合，来实现在实时视频通话下的图像识别。

Agora Python TensorFlow Demo：[https://github.com/AgoraIO-Community/Agora-Python-Tensorflow-Demo](https://link.zhihu.com/?target=https%3A//github.com/AgoraIO-Community/Agora-Python-Tensorflow-Demo)

Agora Python TensorFlow Demo编译指南：

- 下载Agora Python SDK ：[https://github.com/AgoraIO-Community/Agora-Python-SDK](https://link.zhihu.com/?target=https%3A//github.com/AgoraIO-Community/Agora-Python-SDK)
- 若是 Windows，复制.pyd and .dll文件到本项目文件夹根目录；若是IOS，复制.so文件到本文件夹根目录
- 下载 [Tensorflow模型 https://link.zhihu.com/?target=https%3A//github.com/tensorflow/models,然后把 object_detection 文件复制.到本文件夹根目录
- 安装 Protobuf。然后运行： protoc object_detection/protos/*.proto --python_out=.
- 从这里下载预先训练的模型 https://link.zhihu.com/?target=https%3A//github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
- 推荐使用 ssd_mobilenet_v1_coco 和 ssdlite_mobilenet_v2_coco，因为他们相对运行较快
- 提取 frozen graph,命令行运行：python extractGraph.py --model_file='FILE_NAME_OF_YOUR_MODEL'
- 最后，在 callBack.py 中修改 model name，在 demo.py 中修改Appid，然后运行即可

请注意，这个 Demo 仅作为演示使用，从获取到远端实时视频画面，到TensorFlow 进行识别处理，再到显示出识别效果，期间需要2至4 秒。不同网络情况、设备性能、算法模型，其识别的效率也不同。