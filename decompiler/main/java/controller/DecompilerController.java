package main.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/decompiler")
public class DecompilerController {
    @RequestMapping("/high_level")
    public String highLevel(){
        return "index";
    }

    @RequestMapping("/low_level")
    public String lowLevel(){
        return "index";
    }
}
