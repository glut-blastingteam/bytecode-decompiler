<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Java bytecode decompiler</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css"/>
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <link href="http://cdn.bootcss.com/highlight.js/8.0/styles/monokai_sublime.min.css" rel="stylesheet">
    <script src="http://cdn.bootcss.com/highlight.js/8.0/highlight.min.js"></script>
</head>
<body>

<div id="app">
    <el-container>
        <el-header>
            <el-card class="box-card">
                <el-steps :active="active" finish-status="success">
                    <el-step title="步骤 1"></el-step>
                    <el-step title="步骤 2"></el-step>
                </el-steps>
            </el-card>
        </el-header>
        <el-main>
            <div class="step1" v-if="active==0">
                <el-card class="box-card">
                    <el-upload
                            name="classfile"
                            class="upload-demo"
                            drag
                            action="/decompiler"
                            :on-success="handleSuccess"
                            multiple>
                        <i class="el-icon-upload"></i>
                        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    </el-upload>
                </el-card>

            </div>
            <div class="step2" v-if="active==1">
                <el-tabs type="border-card" @tab-click="handleClick">
                    <el-tab-pane label="高级反编译" name="high_level">
                        <pre>
<code class="java" ref="jc">
// Decompiling infrastructure provided by github.com/racaljk/bc2json
{{ decompiled_java_code }}
</code>
                        </pre>
                    </el-tab-pane>
                    <el-tab-pane label="低级反编译" name="low_level">
                        low level
                    </el-tab-pane>
                </el-tabs>
            </div>
        </el-main>
    </el-container>

</div>
</body>
<script>
    // vue startup
    new Vue({
        el: '#app',
        data: {
            active: 0,
            high_representation:{},
            decompiled_java_code:""
        },

        methods: {
            handleSuccess(res, file) {
                this.active++
                this.high_representation = eval('('+res.classfile_json_high+')')
                console.log(this.high_representation)
                this.decompiled_java_code
                    = this.high_representation.access_flag + this.high_representation.this_class +"{\n"+"}"
                console.log("before")
            },
        },

        watch:{
            decompiled_java_code(newval,oldval){
                console.log("after")
                hljs.highlightBlock(this.$refs.jc);
            }
        }
    })
</script>
</html>