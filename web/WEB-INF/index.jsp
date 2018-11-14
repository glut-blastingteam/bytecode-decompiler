<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Java bytecode decompiler</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css"/>
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <link href="https://cdn.bootcss.com/highlight.js/9.13.1/styles/atom-one-light.min.css" rel="stylesheet">
    <script src="http://cdn.bootcss.com/highlight.js/8.0/highlight.min.js"></script>
    <style type="text/css">
        body {
            font-family: monospace;
            font-size: larger;
        }
    </style>
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
            <div class="step1" v-if="active==0" ref="pp">
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
                        <pre v-highlightjs="decompiled_java_code"><code class="java"></code></pre>
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
    var vueHighlightJS = {};
    vueHighlightJS.install = function install(Vue) {
        Vue.directive('highlightjs', {
            deep: true,
            bind: function bind(el, binding) {
                var targets = el.querySelectorAll('code');
                var target;
                var i;

                for (i = 0; i < targets.length; i += 1) {
                    target = targets[i];

                    if (typeof binding.value === 'string') {
                        target.textContent = binding.value;
                    }

                    hljs.highlightBlock(target);
                }
            },
            componentUpdated: function componentUpdated(el, binding) {
                var targets = el.querySelectorAll('code');
                var target;
                var i;

                for (i = 0; i < targets.length; i += 1) {
                    target = targets[i];
                    if (typeof binding.value === 'string') {
                        target.textContent = binding.value;
                    }
                    hljs.highlightBlock(target);
                }
            }
        });
    };

    Vue.use(vueHighlightJS);

    new Vue({
        el: '#app',
        data: {
            active: 0,
            high_representation:{},
            decompiled_java_code:""
        },

        methods: {
            handleSuccess(res, file) {
                this.active++;
                this.high_representation = eval('('+res.classfile_json_high+')');
                console.log(this.high_representation);

                this.decompiled_java_code = function(text){
                    // Prelude comments
                    let result =
                        '// This decompiling infrastructure was provided by https://github.com/racaljk/bc2json\n' +
                        '// And note that below codes are not exactly valid, you should not attempt to compile it\n' +
                        '// Compiled with jdk_'+text.version+'\n';

                    // Package declaration
                    var class_name = text.this_class.split('.');
                    if(class_name.length===2){
                        result +='package '+class_name[0]+'\n\n';
                    }

                    // Class declaration
                    result += text.access_flag+' class ' + (class_name.length===2?class_name[1]:class_name[0]) + ' extends '+ text.super_class;

                    // Implemented interfaces
                    if(text.interfaces.length >0){
                        result +='\t\t implements ';
                        for(let i=0;i<text.interfaces.length;i++){
                            result+=text.interfaces[i];
                            if(i!==text.interfaces.length-1){
                                result+=',';
                            }
                        }
                    }

                    // Left brace
                    result += '{\n';

                    // Field
                    for(let i=0;i<text.fields.length;i++){
                        result +='\t';
                        result += text.fields[i].field;
                        result += ';\n';
                    }

                    // Method
                    result +='\n';
                    for(let i=0;i<text.methods.length;i++){
                        result +='\t';
                        result += text.methods[i].method_signature;
                        result +='{\n';
                        var op = text.methods[i].method_opcode.split(',');
                        for(let k=0;k<op.length;k++){
                            result += '\t\t'+op[k]+'\n';
                        }
                        if(text.methods[i].method_exceptions.length>0){
                            result +='\t\t// Try-Catch-Finally exception tables\n';
                            for(let p = 0;p<text.methods[i].method_exceptions.length;p++){
                                result += '\t\t'+text.methods[i].method_exceptions[p]+'\n';
                            }
                        }

                        result +='\t}\n'
                    }

                    // Right Brace
                    result += '}\n';
                    return result
                }(this.high_representation)
            },
        }
    })
</script>
</html>