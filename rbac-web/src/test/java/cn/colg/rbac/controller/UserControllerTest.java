package cn.colg.rbac.controller;

import cn.colg.rbac.BaseTest;
import cn.colg.rbac.entity.User;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author colg
 */
public class UserControllerTest extends BaseTest {

    @Autowired
    private UserController userController;

    @Test
    public void insert() {
        for (int i = 0; i < 50; i++) {
            String loginacct = RandomUtil.randomString(RandomUtil.BASE_CHAR, 5);
            User user = new User().setId(RandomUtil.simpleUUID())
                    .setLoginacct(loginacct)
                    .setUsername(StrUtil.upperFirst(loginacct))
                    .setEmail(loginacct + "@qq.com");
            userController.insert(user);
        }

    }

    @Test
    public void testName() {
        String s1 = RandomUtil.randomString(RandomUtil.BASE_CHAR, 5);
        System.out.println(s1);
        String s = RandomStringUtils.randomAlphabetic(5);
        System.out.println(s);
    }
}