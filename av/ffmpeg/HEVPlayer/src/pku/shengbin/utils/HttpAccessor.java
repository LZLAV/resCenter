package pku.shengbin.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Utility class which retrieves the content of a HTTP URL as a string.
 */
public class HttpAccessor {
	
	/**
	 * 根据Url获取内容
	 * @param strUrl
	 * @return
	 */
	public String getContentFromUrl(String strUrl) {
		StringBuffer buffer = new StringBuffer();
		String line = null;
		BufferedReader reader = null;
		try {
			URL url = new URL(strUrl);
			HttpURLConnection urlConn = (HttpURLConnection) url
					.openConnection();
			reader = new BufferedReader(new InputStreamReader(
					urlConn.getInputStream()));
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return buffer.toString();
	}
}
