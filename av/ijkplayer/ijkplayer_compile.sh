
cd ijkplayer-android/

export ANDROID_SDK=/Users/lzlbuilder/Library/Android/sdk
export ANDROID_NDK=/Volumes/work_dev/ijkplayer_compile/ndk/android-ndk-r13b


cd config/

rm module_sh
# 软链接
ln -s module-defaule.sh module.sh
cd ../android/contrib/

sh compile-ffmpeg.sh clean

# 回到根目录
cd ../../

#配置 ssl,支持 https协议
./init-android-openssl.sh
./init-android.sh

cd android/contrib
./compile-openssl.sh clean
./compile-ffmpeg.sh clean
./compile-openssl.sh all
./compile-ffmpeg.sh all

cd ..
./compile-ijk.sh all