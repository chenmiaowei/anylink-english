#!/bin/sh

# Example modifications
# Replace "old_string1" with "new_string1" in all .go files
find /server -type f -name '*.go' -exec sed -i 's/请输入你的用户名和密码/Please enter your username and password/g' {} +
find /server -type f -name '*.go' -exec sed -i 's/登陆失败: /Login failed:/g' {} +
find /server -type f -name '*.go' -exec sed -i 's/用户名或密码错误/wrong user name or password/g' {} +
find /server -type f -name '*.go' -exec sed -i 's/哦，请求出错/Oops, request error/g' {} +
find /server -type f -name '*.go' -exec sed -i 's/哦，请求出错/Oops, request error/g' {} +