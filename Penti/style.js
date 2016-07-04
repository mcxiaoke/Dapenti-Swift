/*
* @Author: mcxiaoke
* @Date:   2016-07-04 17:17:43
* @Last Modified by:   mcxiaoke
* @Last Modified time: 2016-07-04 18:37:05
*/
function addCSSRule(sheet, selector, rules, index) {
    if("insertRule" in sheet) {
        sheet.insertRule(selector + "{" + rules + "}", index);
    }
    else if("addRule" in sheet) {
        sheet.addRule(selector, rules, index);
    }
}

function createStyleSheet(){
    // Create the <style> tag
    var style = document.createElement("style");

    // Add a media (and/or media query) here if you'd like!
    // style.setAttribute("media", "screen")
    // style.setAttribute("media", "only screen and (max-width : 1024px)")

    // WebKit hack :(
    style.appendChild(document.createTextNode(""));

    // Add the <style> element to the page
    document.head.appendChild(style);
    return style.sheet;
}

function loadFile(fileName, fileType){
    console.log("loadFile "+fileName);
    if (fileType=="js"){ //if filename is a external JavaScript file
        var fileRef=document.createElement('script');
        fileRef.setAttribute("type","text/javascript");
        fileRef.setAttribute("src", fileName);
    }
    else if (fileType=="css"){ //if filename is an external CSS file
        var fileRef=document.createElement("link");
        fileRef.setAttribute("rel", "stylesheet");
        fileRef.setAttribute("type", "text/css");
        fileRef.setAttribute("href", fileName);
    }
    console.log(fileRef.innerHTML);
    console.log(fileRef.innerHTML);
    if (typeof fileRef!="undefined")
        document.head.appendChild(fileRef);
}

function removeOldStyles(){
    var styles = document.body.getElementsByTagName("style");
    if (styles == null || styles == undefined) {
        console.log("style not found");
        return;
    }
    Array.prototype.forEach.call(styles, function(style, index) {
        console.log("Removing Style "+index);
        document.body.removeChild(style);
    });
}

function changeStyle(){
    var bodyStyle = " background: #f6f6f2; \ 
    "
    var paragraphStyle = " text-align:justify; \
        font-size: 12px; \
    "
    var imageStyle = " display:block; \
        max-width: 100%; \
        margin: 0 auto; \
        padding-top:4pt; \
        padding-bottom:4pt; \
    "
    var linkStyle = " text-decoration: none; \
    "
    var sheet = createStyleSheet()
    addCSSRule(sheet, "body", bodyStyle);
    addCSSRule(sheet, "p", paragraphStyle);
    addCSSRule(sheet, "img", imageStyle);
    addCSSRule(sheet, "a", linkStyle);
}

removeOldStyles();
changeStyle();
