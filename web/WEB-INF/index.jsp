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
            font-family: "Helvetica Neue",Helvetica,"PingFang SC","Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif;;
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
                    <el-step title="Step 1: Upload bytecode file"></el-step>
                    <el-step title="Step 2: Decompiling it"></el-step>
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
                            :on-success="uploadSuccess"
                            multiple>
                        <i class="el-icon-upload"></i>
                        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    </el-upload>
                </el-card>
            </div>
            <div class="step2" v-if="active>0">
                <el-tabs type="border-card" @tab-click="tabClick">
                    <el-tab-pane label="High level decompiling" name="high_level">
                        <el-alert
                                title="This decompiling tool was provided by https://github.com/racaljk/bc2json"
                                type="success"
                                show-icon>
                        </el-alert>
                        <pre v-highlightjs="decompiled_java_code"><code class="java"></code></pre>
                    </el-tab-pane>
                    <el-tab-pane label="Low level decompiling" name="low_level">
                        <el-collapse v-model="activeName" accordion>
                            <el-collapse-item title="Magic number" name="1">
                                <div><el-tag type="success">{{low_representation.magic}}</el-tag></div>
                            </el-collapse-item>
                            <el-collapse-item title="Access flag" name="2">
                                <div><el-tag type="success">{{low_representation.access_flag}}</el-tag></div>
                            </el-collapse-item>
                        </el-collapse>
                    </el-tab-pane>

                    <el-tab-pane label="Constant pool" name="const_pool"
                                 v-if="low_representation.constants.slots.length>0">
                        <el-table :data="ConstantFieldRefInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="field_class" label="Field class"></el-table-column>
                            <<el-table-column prop="field_name" label="Field name"></el-table-column>
                            <<el-table-column prop="field_type" label="Field type"></el-table-column>
                        </el-table>

                        <el-table :data="ConstantMethodRefInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="method_class" label="Method class"></el-table-column>
                            <<el-table-column prop="method_name" label="Method name"></el-table-column>
                            <<el-table-column prop="method_type" label="Method type"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantInterfaceMethodRefInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="interface_class" label="Interface class"></el-table-column>
                            <<el-table-column prop="interface_name" label="Interface name"></el-table-column>
                            <<el-table-column prop="interface_type" label="Interface type"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantStringInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="string" label="String"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantIntegerInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="value" label="Value"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantFloatInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="value" label="Value"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantLongInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="value" label="Value"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantDoubleInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="value" label="Value"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantNameAndTypeInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="name" label="Name"></el-table-column>
                            <<el-table-column prop="descriptor" label="Descriptor"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantUtf8Info" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="utf8" label="UTF8"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantMethodHandleInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="reference_kind" label="Reference kind"></el-table-column>
                            <<el-table-column prop="reference_index" label="Reference index"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantMethodTypeInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="descriptor" label="Descriptor"></el-table-column>
                        </el-table>
                        <el-table :data="ConstantInvokeDynamicInfo" stripe style="width: 100%">
                            <<el-table-column prop="index" label="Index" width="80"></el-table-column>
                            <<el-table-column prop="bootstrap_method_index" label="Bootstrap method index"></el-table-column>
                            <<el-table-column prop="name" label="Name"></el-table-column>
                            <<el-table-column prop="type" label="Type"></el-table-column>
                        </el-table>
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
            low_representation:{},
            decompiled_java_code:"",
            // Kinds of constant pool slot
            ConstantClassInfo:[],
            ConstantFieldRefInfo:[],
            ConstantMethodRefInfo:[],
            ConstantInterfaceMethodRefInfo:[],
            ConstantStringInfo:[],
            ConstantIntegerInfo:[],
            ConstantFloatInfo:[],
            ConstantLongInfo:[],
            ConstantDoubleInfo:[],
            ConstantNameAndTypeInfo:[],
            ConstantUtf8Info:[],
            ConstantMethodHandleInfo:[],
            ConstantMethodTypeInfo:[],
            ConstantInvokeDynamicInfo:[]
        },

        methods: {
            tabClick(tab, event) {
                this.active = 2;
            },

            uploadSuccess(res, file) {
                this.active++;
                this.high_representation = eval('('+res.classfile_json_high+')');
                this.low_representation = eval('('+res.classfile_json_low+')');
                console.log(this.low_representation);

                this.decompiled_java_code = function(text){
                    // Prelude comments
                    let result =
                        '// Note that below codes are not exactly valid, you should not attempt to compile it\n' +
                        '// Compiled with jdk_'+text.version+'\n';

                    // Package declaration
                    var class_name = "";
                    var package_name = "";
                    if(text.this_class.split('.').length===2){
                        package_name = text.this_class.split(".")[0];
                        class_name = text.this_class.split(".")[1];
                        result +='package '+package_name+'\n\n';
                    }else {
                        class_name = text.this_class.split(".")[0];
                    }


                    // Class declaration
                    result += text.access_flag+' class ' + class_name + ' extends '+ text.super_class;

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
                        result += text.methods[i].method_signature.replace(/<init>/,class_name);
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
                for(let i=0;i<this.low_representation.constants.slots.length;i++){
                    let slot = this.low_representation.constants.slots[i];
                    if(slot.type==='ConstantClassInfo'){
                        this.ConstantClassInfo.push({
                            index:slot.index,
                            class_name:slot.class_name
                        })
                    }else if(slot.type==='ConstantFieldRefInfo'){
                        this.ConstantFieldRefInfo.push({
                            index:slot.index,
                            field_class:slot.field_class,
                            field_name:slot.field_name,
                            field_type:slot.field_type
                        })
                    }else if(slot.type==='ConstantMethodRefInfo'){
                        this.ConstantMethodRefInfo.push({
                            index:slot.index,
                            method_class:slot.method_class,
                            method_name:slot.method_name,
                            method_type:slot.method_type
                        })
                    }else if(slot.type==='ConstantInterfaceMethodRefInfo'){
                        this.ConstantInterfaceMethodRefInfo.push({
                            index:slot.index,
                            interface_class:slot.interface_class,
                            interface_name:slot.interface_name,
                            interface_type:slot.interface_type
                        })
                    }else if(slot.type==='ConstantStringInfo'){
                        this.ConstantStringInfo.push({
                            index:slot.index,
                            string:slot.string
                        })
                    }else if(slot.type==='ConstantIntegerInfo'){
                        this.ConstantIntegerInfo.push({
                            index:slot.index,
                            value:slot.value
                        })
                    }else if(slot.type==='ConstantFloatInfo'){
                        this.ConstantFloatInfo.push({
                            index:slot.index,
                            value:slot.value
                        })
                    }else if(slot.type==='ConstantLongInfo'){
                        this.ConstantLongInfo.push({
                            index:slot.index,
                            value:slot.value
                        })
                    }else if(slot.type==='ConstantDoubleInfo'){
                        this.ConstantDoubleInfo.push({
                            index:slot.index,
                            value:slot.value
                        })
                    }else if(slot.type==='ConstantNameAndTypeInfo'){
                        this.ConstantNameAndTypeInfo.push({
                            index:slot.index,
                            name:slot.name,
                            descriptor:slot.descriptor
                        })
                    }else if(slot.type==='ConstantUtf8Info'){
                        this.ConstantUtf8Info.push({
                            index:slot.index,
                            utf8:slot.utf8
                        })
                    }else if(slot.type==='ConstantMethodHandleInfo'){
                        this.ConstantMethodHandleInfo.push({
                            index:slot.index,
                            reference_index:slot.reference_index,
                            reference_kind:slot.reference_kind
                        })
                    }else if(slot.type==='ConstantMethodTypeInfo'){
                        this.ConstantMethodTypeInfo.push({
                            index:slot.index,
                            descriptor:slot.descriptor,
                        })
                    }else if(slot.type==='ConstantInvokeDynamicInfo'){
                        this.ConstantInvokeDynamicInfo.push({
                            index:slot.index,
                            bootstrap_method_index:slot.bootstrap_method_index,
                            name:slot.name,
                            type:slot.type
                        })
                    }else{
                        // impossible!
                    }
                }

            },
        }
    })
</script>
</html>