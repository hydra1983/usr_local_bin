var fs = require('fs');
var os = require('os');

const ENCODING = "utf-8";

var data;

try{
	data = fs.readFileSync('paths',{encoding:ENCODING});
} catch(error) {
	throw error;
}

if(data == null){
	data = "";
}

data = String(data);

if(data == ""){
	process.exit(0);
}

var lines = data.split(/\r\n|\r|\n/g);
var n = lines.length;
var win_path = "";
var linux_path = "";
var trim = function(string){
	return string.replace(/(^\s+)|(\s+$)/g,"");
};
var getWinPath = function(path){
	return path;
};

var getLinuxPath = function(path){
	path = path.replace(/\\/g,"/");
	path = path.replace(/([a-zA-Z]):/,"/$1");
	path = path.replace(/\s/g,"\\ ");
	path = path.replace(/\(/g,"\\(");
	path = path.replace(/\)/g,"\\)");
	return path;
};

for(var i = 0;i < n;i++){
	var line = trim(lines[i]);
	if(line == "" || line.indexOf("#") == 0){
		continue;
	}

	if(i != n - 1){
		win_path += getWinPath(line) + ";";
		linux_path += getLinuxPath(line) + ":";
	} else {
		win_path += getWinPath(line) ;
		linux_path += getLinuxPath(line);
	}		
}
console.log("########## [WINDOWS] ##########");
console.log(win_path);
console.log("########## [LINUX] ##########");
console.log(linux_path);

fs.writeFileSync(".win_path",win_path,{encoding:ENCODING});
fs.writeFileSync(".linux_path",linux_path,{encoding:ENCODING});