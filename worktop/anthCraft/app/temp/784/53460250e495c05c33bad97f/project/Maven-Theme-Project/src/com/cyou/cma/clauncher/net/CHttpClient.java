package com.cyou.cma.clauncher.net;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;

import android.os.Build;

public class CHttpClient {

	private static Integer connectTimeout = 30000; // 30 seconds
	private static Integer readTimeout = 3 * 60000; // 3 minutes
	private static Map<String, Object> globalHeaders;

	public CHttpClient(Map<String, Object> defaultHeaders) {
		if (Integer.parseInt(Build.VERSION.SDK) < Build.VERSION_CODES.FROYO) {
			System.setProperty("http.keepAlive", "false");
		}
		if (defaultHeaders == null || defaultHeaders.isEmpty()) {
			globalHeaders = new LinkedHashMap<String, Object>();
		} else {
			globalHeaders = defaultHeaders;
		}
	}

	public CHttpClient() {
		this(null);
	}

	/**
	 * Http Get method, other methods to be completed
	 * 
	 * @param request
	 * @return
	 */
	public Response get(Request request) {
		HttpURLConnection connection = null;
		InputStream is = null;
		Response response = null;

		try {
			String uri = request.uri;
			if (request.method == Request.Method.GET && !uri.contains("?")
					&& request.params != null && !request.params.isEmpty()) {
				uri += "?" + HttpUtil.queryString(request.params);
			}
			URL url = new URL(uri);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod(request.method.name());
			setTimeouts(request, connection);
			HttpUtil.addRequestProperties(connection,
					mergeHeaders(request.headers));
			connection.connect();

			int status = connection.getResponseCode();
			String message = connection.getResponseMessage();
			byte[] responseBody = null;
			if ((status / 100) == 2) {
				is = HttpUtil.wrapStream(connection.getContentEncoding(),
						connection.getInputStream());
			} else {
				is = connection.getErrorStream();
			}
			responseBody = readBytes(is);
			response = new Response(status, message, responseBody);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeStream(is);
			closeConnection(connection);
		}
		
		return response;
	}

	// /////////////////////////class method/////////////////////////////////
	public static void setGlobalHeader(String name, Object value) {
		if (value != null) {
			globalHeaders.put(name, value);
		} else {
			globalHeaders.remove(name);
		}
	}

	private void setTimeouts(Request request, HttpURLConnection connection) {
		if (request.connectTimeout != null || connectTimeout != null) {
			connection
					.setConnectTimeout(request.connectTimeout != null ? request.connectTimeout
							: connectTimeout);
		}
		if (request.readTimeout != null || readTimeout != null) {
			connection
					.setReadTimeout(request.readTimeout != null ? request.readTimeout
							: readTimeout);
		}
	}

	Map<String, Object> mergeHeaders(Map<String, Object> requestHeaders) {
		Map<String, Object> headers = null;
		if (!globalHeaders.isEmpty()) {
			headers = new LinkedHashMap<String, Object>();
			headers.putAll(globalHeaders);
		}
		if (requestHeaders != null) {
			if (headers == null) {
				headers = requestHeaders;
			} else {
				headers.putAll(requestHeaders);
			}
		}
		return headers;
	}

	/**
	 * Read an <code>InputStream</code> into <code>byte[]</code> until EOF.
	 * 
	 * @param is
	 *            the stream to read the bytes from
	 * @return all read bytes as an array
	 */
	private byte[] readBytes(InputStream is) {
		if (is == null)
			return null;
		int len = -1;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			while ((len = is.read()) != -1) {
				baos.write(len);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			closeStream(baos);
		}
		return baos.toByteArray();
	}

	/**
	 * close stream
	 * 
	 * @param stream
	 */
	private void closeStream(Closeable stream) {
		if (stream == null)
			return;
		try {
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * disconnect connection
	 * 
	 * @param conn
	 */
	private void closeConnection(HttpURLConnection conn) {
		if (conn == null)
			return;
		try {
			conn.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
