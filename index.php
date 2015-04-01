<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<?php
	$targetTempFile = "targettemp.txt";
	$targetTimerFile = "timer.txt";
	if(isset($_POST["submit"])) 
	{
		if(isset($_POST["newTargetTemp"]))
		{
			$newTemp = $_POST["newTargetTemp"];
			$tempFile = fopen("targettemp.txt", "w") or die("Unable to open file!");
			fwrite($tempFile, $newTemp);
			fclose($tempFile);
		}
	}
	?>
	<script data-require="jquery@1.10.1" data-semver="1.10.1" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	<link rel="stylesheet" href="/assets/css/flipclock.css">
	<script src="/assets/js/flipclock/flipclock.min.js"></script>
	<script>
	refreshImage=function()
	{
		minute=document.getElementById("minute");
		minute.src="temp_minute.png?" + new Date().getTime();
		fifteenminutes=document.getElementById("15minutes");
		fifteenminutes.src="temp_15minute.png?"+ new Date().getTime();
		$.get('targettemp.txt').then(function(responseData) 
		{
	  		$('#targetTemp').empty().append(responseData);	
		});
	}
	</script>
</head>
<body onload="window.setInterval(refreshImage, 1000);">
<h1 id="title">Sous Vide Status</h1>
<p>This page shows the current status of the Sous Vide machine</p>
<p>Current target temperature is:<b id="targetTemp"></b></p>


<form action="index.php" method="post" enctype="multipart/form-data">
        Input new temperature:
        <input type="text" name="newTargetTemp" id="newTargetTemp">
        <br>
	Input new timer in minutes:
        <input type="text" name="newTimerOffset" id="newTimerOffset">
	<br>
	<input type="submit" value="Upload New Values" name="submit">
</form>
<div>
<p>Current actual temperatures:</p>
<img id="15minutes" src="temp_15minute.png" alt="15 minute temperature graph">
<img id="minute" src="temp_minute.png" alt="60 second temperature graph">
</div>
</body></html>
