package main.java.controller;

import b2j.B2Json;
import b2j.OptionConst;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

@RestController
public class DecompilerController {
    @ResponseBody
    @RequestMapping(value = "/decompiler",produces="application/json")
    public Map<String,String> decompiler(@RequestParam("classfile") MultipartFile file){
        byte[] bytes = null;
        try {
            bytes = file.getBytes();
        } catch (IOException e) {
            e.printStackTrace();
        }
        B2Json b2Json = B2Json.fromInputStream(new ByteArrayInputStream(bytes));
        b2Json.withOption(OptionConst.MORE_READABLE);

        Map<String,String> m = new HashMap<>();
        m.put("classfile_json_high",b2Json.toJsonString());
        m.put("classfile_json_low",b2Json.toJsonString());
        return m;
    }
}
