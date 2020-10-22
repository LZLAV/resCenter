package com.lzlbuilder.demo.natives;

/**
 * 字符串类的 native 方法
 */
public class NativeString {

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public static native String stringFromJNI();

    public static native void stringMain();
}
