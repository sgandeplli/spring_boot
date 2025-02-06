package com.democompany.first_demo_project;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AnotherController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, World!";
    }
}

