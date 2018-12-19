package com.astrolab.zuulserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

@SpringBootApplication
@EnableZuulProxy
@EnableDiscoveryClient
public class AstrolabZuulServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(AstrolabZuulServerApplication.class, args);
	}

}

