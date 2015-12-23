tinymce.PluginManager.add("fullpage",function(e){function t(){var t=n();e.windowManager.open({title:"Document properties",data:t,defaults:{type:"textbox",size:40},body:[{name:"title",label:"Title"},{name:"keywords",label:"Keywords"},{name:"description",label:"Description"},{name:"robots",label:"Robots"},{name:"author",label:"Author"},{name:"docencoding",label:"Encoding"}],onSubmit:function(e){r(tinymce.extend(t,e.data))}})}function n(){function t(e,t){var n=e.attr(t);return n||""}var n,r,o=i(),a={};return a.fontface=e.getParam("fullpage_default_fontface",""),a.fontsize=e.getParam("fullpage_default_fontsize",""),n=o.firstChild,7==n.type&&(a.xml_pi=!0,r=/encoding="([^"]+)"/.exec(n.value),r&&(a.docencoding=r[1])),n=o.getAll("#doctype")[0],n&&(a.doctype="<!DOCTYPE"+n.value+">"),n=o.getAll("title")[0],n&&n.firstChild&&(a.title=n.firstChild.value),u(o.getAll("meta"),function(e){var t,n=e.attr("name"),r=e.attr("http-equiv");n?a[n.toLowerCase()]=e.attr("content"):"Content-Type"==r&&(t=/charset\s*=\s*(.*)\s*/gi.exec(e.attr("content")),t&&(a.docencoding=t[1]))}),n=o.getAll("html")[0],n&&(a.langcode=t(n,"lang")||t(n,"xml:lang")),a.stylesheets=[],tinymce.each(o.getAll("link"),function(e){"stylesheet"==e.attr("rel")&&a.stylesheets.push(e.attr("href"))}),n=o.getAll("body")[0],n&&(a.langdir=t(n,"dir"),a.style=t(n,"style"),a.visited_color=t(n,"vlink"),a.link_color=t(n,"link"),a.active_color=t(n,"alink")),a}function r(t){function n(e,t,n){e.attr(t,n?n:void 0)}function r(e){a.firstChild?a.insert(e,a.firstChild):a.append(e)}var o,a,s,c,f,p=e.dom;o=i(),a=o.getAll("head")[0],a||(c=o.getAll("html")[0],a=new d("head",1),c.firstChild?c.insert(a,c.firstChild,!0):c.append(a)),c=o.firstChild,t.xml_pi?(f='version="1.0"',t.docencoding&&(f+=' encoding="'+t.docencoding+'"'),7!=c.type&&(c=new d("xml",7),o.insert(c,o.firstChild,!0)),c.value=f):c&&7==c.type&&c.remove(),c=o.getAll("#doctype")[0],t.doctype?(c||(c=new d("#doctype",10),t.xml_pi?o.insert(c,o.firstChild):r(c)),c.value=t.doctype.substring(9,t.doctype.length-1)):c&&c.remove(),c=null,u(o.getAll("meta"),function(e){"Content-Type"==e.attr("http-equiv")&&(c=e)}),t.docencoding?(c||(c=new d("meta",1),c.attr("http-equiv","Content-Type"),c.shortEnded=!0,r(c)),c.attr("content","text/html; charset="+t.docencoding)):c&&c.remove(),c=o.getAll("title")[0],t.title?(c?c.empty():(c=new d("title",1),r(c)),c.append(new d("#text",3)).value=t.title):c&&c.remove(),u("keywords,description,author,copyright,robots".split(","),function(e){var n,i,a=o.getAll("meta"),s=t[e];for(n=0;n<a.length;n++)if(i=a[n],i.attr("name")==e)return void(s?i.attr("content",s):i.remove());s&&(c=new d("meta",1),c.attr("name",e),c.attr("content",s),c.shortEnded=!0,r(c))});var m={};tinymce.each(o.getAll("link"),function(e){"stylesheet"==e.attr("rel")&&(m[e.attr("href")]=e)}),tinymce.each(t.stylesheets,function(e){m[e]||(c=new d("link",1),c.attr({rel:"stylesheet",text:"text/css",href:e}),c.shortEnded=!0,r(c)),delete m[e]}),tinymce.each(m,function(e){e.remove()}),c=o.getAll("body")[0],c&&(n(c,"dir",t.langdir),n(c,"style",t.style),n(c,"vlink",t.visited_color),n(c,"link",t.link_color),n(c,"alink",t.active_color),p.setAttribs(e.getBody(),{style:t.style,dir:t.dir,vLink:t.visited_color,link:t.link_color,aLink:t.active_color})),c=o.getAll("html")[0],c&&(n(c,"lang",t.langcode),n(c,"xml:lang",t.langcode)),a.firstChild||a.remove(),s=new tinymce.html.Serializer({validate:!1,indent:!0,apply_source_formatting:!0,indent_before:"head,html,body,meta,title,script,link,style",indent_after:"head,html,body,meta,title,script,link,style"}).serialize(o),l=s.substring(0,s.indexOf("</body>"))}function i(){return new tinymce.html.DomParser({validate:!1,root_name:"#document"}).parse(l)}function o(t){function n(e){return e.replace(/<\/?[A-Z]+/g,function(e){return e.toLowerCase()})}var r,o,s,d,f=t.content,p="",m=e.dom;if(!t.selection&&!("raw"==t.format&&l||t.source_view&&e.getParam("fullpage_hide_in_source_view"))){0!==f.length||t.source_view||(f=tinymce.trim(l)+"\n"+tinymce.trim(f)+"\n"+tinymce.trim(c)),f=f.replace(/<(\/?)BODY/gi,"<$1body"),r=f.indexOf("<body"),-1!=r?(r=f.indexOf(">",r),l=n(f.substring(0,r+1)),o=f.indexOf("</body",r),-1==o&&(o=f.length),t.content=f.substring(r+1,o),c=n(f.substring(o))):(l=a(),c="\n</body>\n</html>"),s=i(),u(s.getAll("style"),function(e){e.firstChild&&(p+=e.firstChild.value)}),d=s.getAll("body")[0],d&&m.setAttribs(e.getBody(),{style:d.attr("style")||"",dir:d.attr("dir")||"",vLink:d.attr("vlink")||"",link:d.attr("link")||"",aLink:d.attr("alink")||""}),m.remove("fullpage_styles");var h=e.getDoc().getElementsByTagName("head")[0];p&&(m.add(h,"style",{id:"fullpage_styles"},p),d=m.get("fullpage_styles"),d.styleSheet&&(d.styleSheet.cssText=p));var g={};tinymce.each(h.getElementsByTagName("link"),function(e){"stylesheet"==e.rel&&e.getAttribute("data-mce-fullpage")&&(g[e.href]=e)}),tinymce.each(s.getAll("link"),function(e){var t=e.attr("href");g[t]||"stylesheet"!=e.attr("rel")||m.add(h,"link",{rel:"stylesheet",text:"text/css",href:t,"data-mce-fullpage":"1"}),delete g[t]}),tinymce.each(g,function(e){e.parentNode.removeChild(e)})}}function a(){var t,n="",r="";return e.getParam("fullpage_default_xml_pi")&&(n+='<?xml version="1.0" encoding="'+e.getParam("fullpage_default_encoding","ISO-8859-1")+'" ?>\n'),n+=e.getParam("fullpage_default_doctype","<!DOCTYPE html>"),n+="\n<html>\n<head>\n",(t=e.getParam("fullpage_default_title"))&&(n+="<title>"+t+"</title>\n"),(t=e.getParam("fullpage_default_encoding"))&&(n+='<meta http-equiv="Content-Type" content="text/html; charset='+t+'" />\n'),(t=e.getParam("fullpage_default_font_family"))&&(r+="font-family: "+t+";"),(t=e.getParam("fullpage_default_font_size"))&&(r+="font-size: "+t+";"),(t=e.getParam("fullpage_default_text_color"))&&(r+="color: "+t+";"),n+="</head>\n<body"+(r?' style="'+r+'"':"")+">\n"}function s(t){t.selection||t.source_view&&e.getParam("fullpage_hide_in_source_view")||(t.content=tinymce.trim(l)+"\n"+tinymce.trim(t.content)+"\n"+tinymce.trim(c))}var l,c,u=tinymce.each,d=tinymce.html.Node;e.addCommand("mceFullPageProperties",t),e.addButton("fullpage",{title:"Document properties",cmd:"mceFullPageProperties"}),e.addMenuItem("fullpage",{text:"Document properties",cmd:"mceFullPageProperties",context:"file"}),e.on("BeforeSetContent",o),e.on("GetContent",s)});