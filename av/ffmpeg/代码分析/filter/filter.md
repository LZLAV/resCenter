## Filter

FFmpeg中filter包含三个层次，filter->filterchain->filtergraph。

filter是ffmpeg的libavfilter提供的基础单元。在同一个线性链中的filter使用逗号分隔，在不同线性链中的filter使用分号隔开。

> ffmpeg -i INPUT -vf "split \[main][tmp]; [tmp] crop=iw:ih/2:0:0,vflip [flip];\[main][flip] overlay=0:H/2" OUTPUT

在上例中split filter有两个输出，依次命名为[main]和[tmp]；[tmp]作为crop filter输入，之后通过vflip filter输出[flip]；overlay的输入是[main]和[flilp]。如果filter需要输入参数，多个参数使用冒号分割。
对于没有音频、视频输入的filter称为source filter，没有音频、视频输出的filter称为sink filter。

