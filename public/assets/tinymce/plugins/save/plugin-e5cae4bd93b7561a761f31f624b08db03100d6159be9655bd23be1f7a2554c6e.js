!function(){var n={},e=function(e){for(var t=n[e],o=t.deps,r=t.defn,i=o.length,c=new Array(i),u=0;u<i;++u)c[u]=a(o[u]);var d=r.apply(null,c);if(void 0===d)throw"module ["+e+"] returned undefined";t.instance=d},t=function(e,t,a){if("string"!=typeof e)throw"module id must be a string";if(void 0===t)throw"no dependencies for "+e;if(void 0===a)throw"no definition function for "+e;n[e]={deps:t,defn:a,instance:void 0}},a=function(t){var a=n[t];if(void 0===a)throw"module ["+t+"] was undefined";return void 0===a.instance&&e(t),a.instance},o=function(n,e){for(var t=n.length,o=new Array(t),r=0;r<t;++r)o[r]=a(n[r]);e.apply(null,o)};({}).bolt={module:{api:{define:t,require:o,demand:a}}};var r=t;(function(n,e){r(n,[],function(){return e})})("4",tinymce.util.Tools.resolve),r("1",["4"],function(n){return n("tinymce.PluginManager")}),r("7",["4"],function(n){return n("tinymce.dom.DOMUtils")}),r("8",["4"],function(n){return n("tinymce.util.Tools")}),r("6",[],function(){return{enableWhenDirty:function(n){return n.getParam("save_enablewhendirty",!0)},hasOnSaveCallback:function(n){return!!n.getParam("save_onsavecallback")},hasOnCancelCallback:function(n){return!!n.getParam("save_oncancelcallback")}}}),r("5",["7","8","6"],function(n,e,t){var a=function(n,e){n.notificationManager.open({text:n.translate(e),type:"error"})};return{save:function(e){var o;if(o=n.DOM.getParent(e.id,"form"),!t.enableWhenDirty(e)||e.isDirty())return e.save(),t.hasOnSaveCallback(e)?(e.execCallback("save_onsavecallback",e),void e.nodeChanged()):void(o?(e.setDirty(!1),o.onsubmit&&!o.onsubmit()||("function"==typeof o.submit?o.submit():a(e,"Error: Form submit field collision.")),e.nodeChanged()):a(e,"Error: No form element found."))},cancel:function(n){var a=e.trim(n.startContent);return t.hasOnCancelCallback(n)?void n.execCallback("save_oncancelcallback",n):(n.setContent(a),n.undoManager.clear(),void n.nodeChanged())}}}),r("2",["5"],function(n){return{register:function(e){e.addCommand("mceSave",function(){n.save(e)}),e.addCommand("mceCancel",function(){n.cancel(e)})}}}),r("3",["6"],function(n){var e=function(e){return function(t){var a=t.control;e.on("nodeChange dirty",function(){a.disabled(n.enableWhenDirty(e)&&!e.isDirty())})}};return{register:function(n){n.addButton("save",{icon:"save",text:"Save",cmd:"mceSave",disabled:!0,onPostRender:e(n)}),n.addButton("cancel",{text:"Cancel",icon:!1,cmd:"mceCancel",disabled:!0,onPostRender:e(n)}),n.addShortcut("Meta+S","","mceSave")}}}),r("0",["1","2","3"],function(n,e,t){return n.add("save",function(n){t.register(n),e.register(n)}),function(){}}),a("0")()}();