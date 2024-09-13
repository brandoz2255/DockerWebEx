# example of a Docker Web Server 

command to start it 



Code that it uses 

``` html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Docker Web Server</title>
</head>
<body>
    <h1>Welcome to my Docker Web Server!</h1>
</body>
</html>
```



``` bash
docker build -t my-web-server .
```

command to run it 

``` bash
docker run -p 8080:80 my-web-server
```


