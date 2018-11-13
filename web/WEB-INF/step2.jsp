<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Java bytecode decompiler</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css"/>
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
</head>
<body>

<div id="app">

</div>
</body>

<script>
    new Vue({
        el: '#app',
        data: "<%=request.getAttribute("classfile_json_high")%>"
    })
</script>

</html>