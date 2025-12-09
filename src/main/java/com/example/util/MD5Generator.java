package com.example.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Generator {
	
    private String result;

    public MD5Generator(String input) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        MessageDigest mdMD5 = MessageDigest.getInstance("MD5");
        mdMD5.update(input.getBytes("UTF-8"));
        byte[] md5Hash = mdMD5.digest();
        StringBuilder hexMD5hash = new StringBuilder();
        for(byte b : md5Hash) {
            String hexString = String.format("%02x", b);
            hexMD5hash.append(hexString);
        }
        result = hexMD5hash.toString();
    }

    public String toString() {
        return result;
    }
}

/*

MD5 체크섬은 수학적 알고리즘이며, 일반적으로 도구를 사용하여 파일에 대해 계산되는 32자의 16진법 문자와 숫자 세트입니다. 
이 숫자는 "128비트(16바이트) 해시 값을 생성하는 암호화 해시 기능"을 지닌 특수 도구를 사용하여 생성됩니다. 
이를 통해 ZIP 아카이브나 EXE 설치 프로그램뿐만 아니라 모든 유형의 파일을 암호화할 수 있습니다. 
텍스트 또는 문서 파일에도 MD5 체크섬을 할당할 수 있습니다. 

MD5 체크섬의 값과 정확히 일치하면 파일의 디지털 무결성 및 보안이 누군가에 의해 손상되지 않았으며 원래 파일의 정확한 복사본임을 보장하는 것입니다.

따라서, 다운로드한 파일의 MD5 해시 값이 원래 체크섬과 일치하지 않는 경우 이에 대한 원인은 크게 두 가지입니다.

- 파일이 누군가에 의해 무단으로 수정되었을 수 있습니다.
- 파일이 올바르게 다운로드되지 않아 일부 요소가 손상되었을 수 있습니다.

*/