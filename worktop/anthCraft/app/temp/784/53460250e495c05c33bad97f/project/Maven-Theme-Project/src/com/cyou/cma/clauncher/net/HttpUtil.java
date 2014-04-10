package com.cyou.cma.clauncher.net;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;

import android.text.TextUtils;

public class HttpUtil {
	
	static String urlEncode(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }

	/**
     * Convert a Map to a query string.
     * @param values the map with the values
     * @return e.g. "key1=value&key2=&email=max%40example.com"
     */
    static String queryString(Map<String, Object> values) {
        StringBuilder sbuf = new StringBuilder();
        String separator = "";
        
        for (Map.Entry<String, Object> entry : values.entrySet()) {
            String value = entry.getValue() == null ? "" : String.valueOf(entry.getValue());
            sbuf.append(separator);
            sbuf.append(urlEncode(entry.getKey()));
            sbuf.append('=');
            sbuf.append(urlEncode(value));
            separator = "&";
        }

        return sbuf.toString();
    }
    
    /**
     * @param encoding
     * @param inputStream
     * @return wrappedInputStream
     * @throws IOException
     */
    static InputStream wrapStream(String encoding, InputStream inputStream) throws IOException {
    	InputStream wrappedInputStream = null;
        if (encoding == null || "identity".equalsIgnoreCase(encoding)) {
            wrappedInputStream = inputStream;
        } else if ("gzip".equalsIgnoreCase(encoding)) {
            wrappedInputStream = new GZIPInputStream(inputStream);
        } else if ("deflate".equalsIgnoreCase(encoding)) {
        	wrappedInputStream = new InflaterInputStream(inputStream, new Inflater(false), 512);
        } else {
        	throw new UnsupportedEncodingException("Unsupported Content-Encoding: " + encoding);
        }
        return wrappedInputStream;
    }
    
    static void addRequestProperties(HttpURLConnection connection, Map<String, Object> map) {
        if (map == null || map.isEmpty()) {
            return;
        }
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            addRequestProperty(connection, entry.getKey(), entry.getValue());
        }
    }
    
    static void addRequestProperty(HttpURLConnection connection, String name, Object value) {
        assert !TextUtils.isEmpty(name);
        assert value != null;

        String valueAsString;
        if (value instanceof Date) {
            valueAsString = getRfc1123DateFormat().format((Date) value);
        } else if (value instanceof Calendar) {
            valueAsString = getRfc1123DateFormat().format(((Calendar) value).getTime());
        } else {
            valueAsString = value.toString();
        }

        connection.addRequestProperty(name, valueAsString);
    }
    
    /**
     * Creates a new instance of a <code>DateFormat</code> for RFC1123 compliant dates.
     * <br/>
     * Should be stored for later use but be aware that this DateFormat is not Thread-safe!
     * <br/>
     * If you have to deal with dates in this format with JavaScript, it's easy, because the JavaScript
     * Date object has a constructor for strings formatted this way.
     * @return a new instance
     */
    public static DateFormat getRfc1123DateFormat() {
        DateFormat format = new SimpleDateFormat(
                "EEE, dd MMM yyyy HH:mm:ss z", Locale.ENGLISH);
        format.setLenient(false);
        format.setTimeZone(TimeZone.getTimeZone("UTC"));
        return format;
    }
}
