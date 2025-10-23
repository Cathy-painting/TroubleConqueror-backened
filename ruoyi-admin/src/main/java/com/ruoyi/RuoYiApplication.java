package com.ruoyi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 启动程序
 * 
 * @author ruoyi
 */
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class RuoYiApplication
{
    public static void main(String[] args)
    {
        // System.setProperty("spring.devtools.restart.enabled", "false");
SpringApplication.run(RuoYiApplication.class, args);
System.out.println("错题征服者启动成功\n" +
" ______   ______     ______     __         ______      \n" +
"/\\__  _\\ /\\  == \\   /\\  == \\   /\\ \\       /\\  ___\\     \n" +
"\\/_/\\ \\/ \\ \\  __<   \\ \\  __<   \\ \\ \\____  \\ \\  __\\     \n" +
"   \\ \\_\\  \\ \\_\\ \\_\\  \\ \\_____\\  \\ \\_____\\  \\ \\_____\\   \n" +
"    \\/_/   \\/_/ /_/   \\/_____/   \\/_____/   \\/_____/   \n" +
"                                                       \n" +
" ______     ______     __   __     __  __     ______   \n" +
"/\\  ___\\   /\\  __ \\   /\\ \"-.\\ \\   /\\ \\/ /    /\\  == \\  \n" +
"\\ \\ \\____  \\ \\ \\/\\ \\  \\ \\ \\-.  \\  \\ \\  _\"-.  \\ \\  __<  \n" +
" \\ \\_____\\  \\ \\_____\\  \\ \\_\\\\\"\\_\\  \\ \\_\\ \\_\\  \\ \\_\\ \\_\\\n" +
"  \\/_____/   \\/_____/   \\/_/ \\/_/   \\/_/\\/_/   \\/_/ /_/ \n");
    }
}
