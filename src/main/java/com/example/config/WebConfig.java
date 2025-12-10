package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        // 1) 기본 static 리소스 매핑 (선택 사항: Boot에서는 기본으로 됨)
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");

        // 2) 사원 사진 업로드 경로 매핑
        //   예: /upload/emp/xxx.jpg 로 들어오면
        //   => classpath:/static/upload/emp/xxx.jpg 를 찾아가게 설정
        registry.addResourceHandler("/upload/emp/**")
                .addResourceLocations("classpath:/static/upload/emp/");
        
      
    }
}
