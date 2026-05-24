package com.smartdata.kg;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
@MapperScan("com.smartdata.kg.repository")
public class KnowledgeGraphApplication {
    public static void main(String[] args) {
        SpringApplication.run(KnowledgeGraphApplication.class, args);
    }
}
