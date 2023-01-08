<!DOCTYPE html>
<html>
<head>
	<title>Camcord Recorder</title>
	<link rel="apple-touch-icon" sizes="57x57" href="/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
	<link rel="manifest" href="/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
	<meta name="theme-color" content="#ffffff">
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="keywords" content="WebRTC getUserMedia MediaRecorder API">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<style>
		#wrapper{margin:10px auto;width:1050px;padding:10px;}
		#header{box-shadow: 0 8px 6px -6px black;font-size:20px;text-align:center;width:100%;background:#311fb3;color:#fff;padding:10px;text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;}
		#video_recorder{padding:10px;}
		#labelrecord{float:left;padding:10px 0px;}
		#webcams{float:left;width:600px;}
		#tablegallery{float:left;height:480px;overflow:scroll;display:inline-block;}
		.radiobtn{float:left;padding:10px 0px;}
		#btns{padding:10px;}
		video{width:100%;height:auto;padding:5px 0px;}
		td{text-align:center;padding:0px 10px;}
		.gallery{height:150px;}
		#gum{width:700px;}
		button, input, optgroup, select, textarea{margin:0px auto;}
		#footer{position:fixed;bottom:0px;padding:10px;background:#311fb3;color:#fff;font-weight:400;text-align:center;width:100%;font-size:12px;}
		button {
		  margin: 0 3px 10px 0;
		  padding-left: 2px;
		  padding-right: 2px;
		  width: max-content;
		}

		button:last-of-type {
		  margin: 0;
		}

		p.borderBelow {
		  margin: 0 0 20px 0;
		  padding: 0 0 20px 0;
		}

		video {
		  vertical-align: top;
		}

		video:last-of-type {
		  margin: 0 0 20px 0;
		}

		video#gumVideo {
		  margin: 0 20px 20px 0;
		}
		@media screen and (max-width:1050px){
			#wrapper{width:98%;}
			video{width:98%;}
			#gUMArea{width:100%;margin:0px auto;}
			table{width:100%;}
			#webcams{width:60%;}
			#tablegallery{width:40%;}
			#gum{width:100%;}
			.gallery{height:100%;}
		}
		@media screen and (max-width:768px){
			#webcams{width:98%;float:none;}
			#tablegallery{width:98%;float:none;}
		}
	</style>
</head>
<body>
<div id="header">Ciao!! Io sono camcorder recorder </div>
<div id="wrapper">
	<div id="video_recorder">
		<table id="webcams">
			<tr>
				<td><button id="start">Start camera</button></td>
				<td><button id="record" disabled>Start Recording</button></td>
			</tr>
			<tr>
				<td colspan="2">
					<video id="gum" playsinline autoplay muted></video>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<h4>Media Stream Constraints options</h4>
					<p>Echo cancellation: <input type="checkbox" id="echoCancellation"></p>
				</td>
			</tr>
		</table>
		<video id="recorded" playsinline loop style="display:none;"></video>
		<button id="play" disabled style="display:none;">Play</button>
		<button id="download" disabled style="display:none;">Download</button>
		<select id="codecPreferences" disabled style="display:none;"></select>
		<%
		set conn=Server.CreateObject("ADODB.Connection")
		conn.Provider="Microsoft.Jet.OLEDB.4.0"
		conn.Open "E:\database\suhit.mdb"
		Set rsDeleteComments = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM gallery order by ID desc"
		rsDeleteComments.Open strSQL, conn
		%>
		<table id="tablegallery">
		<%
		Do While not rsDeleteComments.EOF
		%>
		<tr>
			<td>
				<video src="videos/<% Response.Write (rsDeleteComments("name")) %>" controls class="gallery"></video>
			</td>
		</tr>
		<tr>
			<td><% Response.Write (rsDeleteComments("name")) %></td>
		</tr>
		<%
		rsDeleteComments.MoveNext
		Loop
		%>
		</table>
		<table style="display:none;">
			<tr>
				<td>
					<section class="main-controls">
						<div id="buttons" style="display:none;">
						  <button class="stop">Stop</button>
						</div>
					</section>
					<section class="sound-clips"></section>
				</td>
			</tr>
		</table>
	</div>
</div>
<div style="clear:both;"></div>
<div id="footer">&copy; 2023 All Rights Reserved Camcorder Recorder</div>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script>
/*
*  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
*
*  Use of this source code is governed by a BSD-style license
*  that can be found in the LICENSE file in the root of the source
*  tree.
*/

// This code is adapted from
// https://rawgit.com/Miguelao/demos/master/mediarecorder.html

'use strict';

/* globals MediaRecorder */

let mediaRecorder;
let recordedBlobs;

const codecPreferences = document.querySelector('#codecPreferences');

const errorMsgElement = document.querySelector('span#errorMsg');
const recordedVideo = document.querySelector('video#recorded');
const recordButton = document.querySelector('button#record');
recordButton.addEventListener('click', () => {
  if (recordButton.textContent === 'Start Recording') {
    startRecording();
	recordButton.disabled = true;
	setInterval(function () {
		stopRecording();
		recordButton.disabled = false;
	}, 10000);
  } else {
    stopRecording();
    recordButton.textContent = 'Start Recording';
    playButton.disabled = false;
    downloadButton.disabled = false;
    codecPreferences.disabled = false;
  }
});

const playButton = document.querySelector('button#play');
playButton.addEventListener('click', () => {
  const mimeType = codecPreferences.options[codecPreferences.selectedIndex].value.split(';', 1)[0];
  const superBuffer = new Blob(recordedBlobs, {type: mimeType});
  recordedVideo.src = null;
  recordedVideo.srcObject = null;
  recordedVideo.src = window.URL.createObjectURL(superBuffer);
  recordedVideo.controls = true;
  recordedVideo.play();
});

const downloadButton = document.querySelector('button#download');
downloadButton.addEventListener('click', () => {



  const blob = new Blob(recordedBlobs, {type: 'video/webm'});
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.style.display = 'none';
  a.href = url;
  a.download = 'test.webm';
  document.body.appendChild(a);
  a.click();
  setTimeout(() => {
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  }, 100);
  
  
  
  
});

function handleDataAvailable(event) {
  console.log('handleDataAvailable', event);
  if (event.data && event.data.size > 0) {
    recordedBlobs.push(event.data);
  }
}

function getSupportedMimeTypes() {
  const possibleTypes = [
    'video/webm;codecs=vp9,opus',
    'video/webm;codecs=vp8,opus',
    'video/webm;codecs=h264,opus',
    'video/mp4;codecs=h264,aac',
  ];
  return possibleTypes.filter(mimeType => {
    return MediaRecorder.isTypeSupported(mimeType);
  });
}

function startRecording() {
  recordedBlobs = [];
  const mimeType = codecPreferences.options[codecPreferences.selectedIndex].value;
  const options = {mimeType};

  try {
    mediaRecorder = new MediaRecorder(window.stream, options);
  } catch (e) {
    console.error('Exception while creating MediaRecorder:', e);
    errorMsgElement.innerHTML = `Exception while creating MediaRecorder: ${JSON.stringify(e)}`;
    return;
  }

  console.log('Created MediaRecorder', mediaRecorder, 'with options', options);
  //recordButton.textContent = 'Stop Recording';
  playButton.disabled = true;
  downloadButton.disabled = true;
  codecPreferences.disabled = true;
  mediaRecorder.onstop = (event) => {
    console.log('Recorder stopped: ', event);
    console.log('Recorded Blobs: ', recordedBlobs);
	
  console.log("data available after MediaRecorder.stop() called.");

      const clipName = prompt('Enter a name for your sound clip?','My unnamed clip');

      const clipContainer = document.createElement('article');
      const clipLabel = document.createElement('p');
      const video = document.createElement('video');
      const deleteButton = document.createElement('button');

      clipContainer.classList.add('clip');
      video.setAttribute('controls', '');
      deleteButton.textContent = 'Delete';
      deleteButton.className = 'delete';

      if(clipName === null) {
        clipLabel.textContent = 'My unnamed clip';
      } else {
        clipLabel.textContent = clipName;
      }

      clipContainer.appendChild(video);
      clipContainer.appendChild(clipLabel);
      clipContainer.appendChild(deleteButton);
      video.controls = true;
       const blob = new Blob(recordedBlobs, {type: 'video/webm'});
		const url = window.URL.createObjectURL(blob);
	  	
      deleteButton.onclick = function(e) {
        e.target.closest(".clip").remove();
      }

      clipLabel.onclick = function() {
        const existingName = clipLabel.textContent;
        const newClipName = prompt('Enter a new name for your sound clip?');
        if(newClipName === null) {
          clipLabel.textContent = existingName;
        } else {
          clipLabel.textContent = newClipName;
        }
      }
	  var a = document.createElement('a');
	  a.download = clipLabel.textContent+".webm";
	  a.href = url;
	  a.click();
	 
	  var xmlhttp = new XMLHttpRequest();
	  xmlhttp.open("GET", "addname.asp?q=" + a.download, true);
	  xmlhttp.send();
  };
  mediaRecorder.ondataavailable = handleDataAvailable;
  mediaRecorder.start();
  console.log('MediaRecorder started', mediaRecorder);
}

function stopRecording() {
  mediaRecorder.stop();
  }

function handleSuccess(stream) {
  recordButton.disabled = false;
  console.log('getUserMedia() got stream:', stream);
  window.stream = stream;

  const gumVideo = document.querySelector('video#gum');
  gumVideo.srcObject = stream;

  getSupportedMimeTypes().forEach(mimeType => {
    const option = document.createElement('option');
    option.value = mimeType;
    option.innerText = option.value;
    codecPreferences.appendChild(option);
  });
  codecPreferences.disabled = false;
}

async function init(constraints) {
  try {
    const stream = await navigator.mediaDevices.getUserMedia(constraints);
    handleSuccess(stream);
  } catch (e) {
    console.error('navigator.getUserMedia error:', e);
    errorMsgElement.innerHTML = `navigator.getUserMedia error:${e.toString()}`;
  }
}

document.querySelector('button#start').addEventListener('click', async () => {
  document.querySelector('button#start').disabled = true;
  const hasEchoCancellation = document.querySelector('#echoCancellation').checked;
  const constraints = {
    audio: {
      echoCancellation: {exact: hasEchoCancellation}
    },
    video: {
      width: 1280, height: 720
    }
  };
  console.log('Using media constraints:', constraints);
  await init(constraints);
});

</script>
<%
dim fs
set fs=Server.CreateObject("Scripting.FileSystemObject")
fs.CopyFile "C:\Users\london\Downloads\*.webm","C:\inetpub\wwwroot\videos\"
set fs=nothing
%> 
</body>
</html>