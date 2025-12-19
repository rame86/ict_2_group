package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String uploadPath = "file:///" + System.getProperty("user.dir")
                + "/src/main/resources/static/upload/";
        
        // approve설정
        String myExternalPath = "file:///C:/upload/";

		/* 프로젝트 루트 기준 업로드 경로 : 프로젝트 내부(static/upload)로 고정해서 사용
        	▶ 경로 통일
        *   ▶ 팀원 혼란 방지
        *   ▶ 빠른 안정화*/
        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath, myExternalPath);
        
		/*  CSS / JS 정적 리소스 */

        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");

        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
    }
    
}
