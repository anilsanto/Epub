// We're using a global variable to store the number of occurrences
var SearchResultCount = 0;

var console = "\n";
var results = "";
var temp="";
var neighSize = 20;
var idrange;
// helper function, recursively searches in elements and their child nodes
function HighlightAllOccurencesOfStringForElement(element,keyword) {
    if (element) {
        if (element.nodeType == 3) {// Text node
            while (true) {
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                var span = document.createElement("highlight");
                span.className = "MyAppHighlight";
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                
                var rightText = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                
                var next = element.nextSibling;
                element.parentNode.insertBefore(rightText, next);
                element.parentNode.insertBefore(span, rightText);
                
                var leftNeighText = element.nodeValue.substr(element.length - neighSize, neighSize);
                var rightNeighText = rightText.nodeValue.substr(0, neighSize);
                
                element = rightText;
                SearchResultCount++;	// update the counter
                
                console += "Span className: " + span.className + "\n";
                console += "Span position: (" + getPos(span).x + ", " + getPos(span).y + ")\n";
                
                results += getPos(span).x + "," + getPos(span).y + "," + escape(leftNeighText + text.nodeValue + rightNeighText) + ";";
                
                results;
            }
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
}

function getPos(el) {
    // yay readability
    for (var lx=0, ly=0; el != null; lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
    return {x: lx,y: ly};
}

// the main entry point to start the search
function HighlightAllOccurencesOfString(keyword) {
    RemoveAllHighlights();
    HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
function RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "MyAppHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}

// the main entry point to remove the highlights
function RemoveAllHighlights() {
    SearchResultCount = 0;
    RemoveAllHighlightsForElement(document.body);
}

function highlightText(keyword,pos) {
    //    console.log("asdas");
    //    window.getSelection
    //    idrange = document.getSelection().selectionStart;
    HighlightString(window.getSelection().baseNode.parentNode.childNodes[0],keyword.toLowerCase(),pos);
}
function HighlightString(element,keyword,pos) {
    if (element) {
        if (element.nodeType == 3) {// Text node
            
            var value = element.nodeValue;  // Search for keyword in text node
            // var idx = value.toLowerCase().indexOf(keyword);
            
            
            var span = document.createElement("mark");
            span.className = "MyAppHighlight";
            var text = document.createTextNode(value.substr(pos,keyword));
            span.appendChild(text);
            
            var rightText = document.createTextNode(value.substr(pos+keyword));
            element.deleteData(pos, value.length - pos);
            
            var next = element.nextSibling;
            element.parentNode.insertBefore(rightText, next);
            element.parentNode.insertBefore(span, rightText);
            
            var leftNeighText = element.nodeValue.substr(element.length - neighSize, neighSize);
            var rightNeighText = rightText.nodeValue.substr(0, neighSize);
            
            element = rightText;
            
            // }
            // 				 else
            // 				 break;
            
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    HighlightString(element.childNodes[i],keyword,pos);
                }
            }
        }
    }
}

function gettagfunction (){
	
	var parent = document.getElementsByClassName('chapter')[0];
	var children = parent.childNodes;
    var tag=window.getSelection().baseNode.parentNode;
	var count = children.length;
	var child_index;
	for (var i = 0; i < count; i++) { children[i];
        if (tag === children[i]) {
            child_index = i;
            break;
        }
	}
	var temp=children[3].childNodes[0].nodeValue;
    alert(temp.indexOf('Pan'));
    var pos=52;
    var keyword=document.getSelection().toString().length;
    HighlightString(children[3].childNodes[0],keyword,pos);
    
    
    
}
function gettagindex (){
	var child=window.getSelection().baseNode.parentNode;
	var parent = document.getElementsByClassName('chapter')[0];
	var children = parent.childNodes;
	var count = children.length;
	var child_index;
	for (var i = 0; i < count; i++) { children[i];
        if (child === children[i]) {
            child_index = i;
            break;
        }
	}
	alert( children[i]('pan'));
}