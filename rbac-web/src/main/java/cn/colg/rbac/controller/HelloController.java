package cn.colg.rbac.controller;

import cn.hutool.core.lang.Dict;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;

/**
 * 测试是否能通
 *
 * @author colg
 */
@Controller
@RequestMapping("/hello")
public class HelloController {

    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    @RequestMapping("/json")
    @ResponseBody
    public Dict json() {
        return Dict.create()
                   .set("hello", "JSON")
                   .set("requestDate", new Date());
    }
}
