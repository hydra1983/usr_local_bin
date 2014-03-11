var fs = require('fs');
var os = require('os');

const ENCODING = 'utf-8';
const HOME = process.env['USERPROFILE'];

var trim = function(string){
		return string.replace(/(^\s+)|(\s+$)/g,'');
	};

var getWinPath = function(path){
	return path;
};

var getLinuxPath = function(path){
	path = path.replace(/\\/g,'/');
	path = path.replace(/([a-zA-Z]):/,'/$1');
	path = path.replace(/\s/g,'\\ ');
	path = path.replace(/\(/g,'\\(');
	path = path.replace(/\)/g,'\\)');
	return path;
};

var readLines = function(path, opts){
	if(opts == null){
		opts = {};
		opts.encoding = ENCODING;
	}

	var data;
	try{
		data = fs.readFileSync(path, opts);
	} catch(error) {
		throw error;
	}

	if(data == null){
		data = '';
	}

	data = String(data);

	var lines = [];
	var rawLines = data.split(/\r\n|\r|\n/g);
	var n = rawLines.length;
	for(var i = 0 ; i < n ; i++){
		var line = trim(rawLines[i]);
		if(line == '' || line.indexOf('#') == 0){
			continue;
		}
		lines.push(line);

	}

	return lines;
};

var setenv = function(name, value, isGlobal){
	var exec = require('child_process').exec;
	var cmd = '"' + __dirname + '\\setenv.exe" ';
	if(isGlobal){
		cmd += '-a ';
	} else {
		cmd += '-ua ';
	}
	cmd += name + ' ';
	cmd += '"' + value + '"';
	var child = exec(cmd, function(error, stdout, stderr){
		if (error != null) {
			if(!(error.toString().indexOf('The system cannot find the path specified') > -1)){
				console.log('[ERROR]: ' + error);
			}
	    } else if(stdout != null && trim(String(stdout)) != ""){
	    	console.log('[EXEC]' + stdout);
	    };
	});
};

(function(){
	var lines = readLines(__dirname + '/paths');
	var n = lines.length;

	var win_path = '';
	var linux_path = '';

	for(var i = 0;i < n;i++){
		var line = trim(lines[i]);
		if(i != n - 1){
			win_path += getWinPath(line) + ';';
			linux_path += getLinuxPath(line) + ':';
		} else {
			win_path += getWinPath(line) ;
			linux_path += getLinuxPath(line);
		}		
	}
	
	// win
	console.log('########## [Set Windows Path] ##########');
	console.log(win_path);
	fs.writeFileSync('.win_path',win_path,{encoding:ENCODING});
	setenv('Path', win_path);
	console.log();

	// linux
	/*linux_path = '.:/usr/local/bin:/mingw/bin:/bin:' + linux_path;
	console.log('########## [Set Linux Path] ##########');
	console.log(linux_path);
	fs.writeFileSync('.linux_path',linux_path,{encoding:ENCODING});
	fs.writeFileSync(HOME + '/.profile','export PATH=' + linux_path,{encoding:ENCODING});
	console.log();*/
})();

(function(){
	console.log('########## [Set Env Vars] ##########');
	var lines = readLines(__dirname + '/vars');
	var n = lines.length;
	var patt = /^([^=]+)=(.*)/;
	var vars = [
		/*{
			name : "TEMP",
			value : HOME + "\\AppData\\Local\\Temp",
			isGlobal : false
		}, {
			name : "TMP",
			value : HOME + "\\AppData\\Local\\Temp",
			isGlobal : false
		}*/
	];
	for(var i = 0;i < n;i++){
		var line = trim(lines[i]);
		if(patt.test(line)){
			var match = line.match(patt);
			var name = trim(match[1]);
			var value = trim(match[2]);
			vars.push({
				name:name,
				value:value,
				isGlobal:true
			});
		}
	}

	var n = vars.length;
	for(var i = 0;i < n;i++){
		var v = vars[i];
		console.log( (v.isGlobal ? '[Sys] ' : '[Usr] ') + v.name + '=' + '"' + v.value + '"');
		setenv(v.name,v.value,v.isGlobal);
	}
})();