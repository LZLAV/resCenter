package pku.shengbin.utils;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;

public class BitmapUtils {

	
	/**
     * ¥¥Ω® ”∆µÀı¬‘Õº
     * @param filePath
     * @return
     */
    public static Bitmap createVideoThumbnail(String filePath) {
        Bitmap bitmap = null;
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            retriever.setDataSource(filePath);
            bitmap = retriever.getFrameAtTime();
        } catch(IllegalArgumentException ex) {
            // Assume this is a corrupt video file
        } catch (RuntimeException ex) {
            // Assume this is a corrupt video file.
        } finally {
            try {
                retriever.release();
            } catch (RuntimeException ex) {
                // Ignore failures while cleaning up.
            }
        }
        return bitmap;
    }
}
