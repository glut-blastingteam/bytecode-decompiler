package main.java.controller;

import b2j.B2Json;
import b2j.OptionConst;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

@Controller
public class DecompilerController {
    @RequestMapping(value = {"/","/step1","/index"})
    public String index(){
        return "step1";
    }
    @RequestMapping("/step2")
    public String step2(){
        return "step2";
    }

    @RequestMapping("/decompiler")
    public String decompiler(@RequestParam("classfile") MultipartFile file, ModelMap m){
        byte[] bytes = null;
        try {
            bytes = file.getBytes();
        } catch (IOException e) {
            e.printStackTrace();
        }

        B2Json b2Json = B2Json.fromInputStream(new ByteArrayInputStream(bytes));
        b2Json.withOption(OptionConst.MORE_READABLE);
        m.addAttribute("classfile_json_high",b2Json.toJsonString());
        return "forward:/step2";
    }
}
