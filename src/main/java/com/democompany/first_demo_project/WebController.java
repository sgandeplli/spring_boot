package com.democompany.first_demo_project;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/web")
    public String home() {
        return "index"; // This refers to the "index.html" file
    }
}

