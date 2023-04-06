j$ = jQuery.noConflict();
var tRec;
var tAte;

function windowResize() {
	var width= j$("[id$='panelPrincipal']").width() + 100; 
	var height= j$("[id$='panelPrincipal']").height() + 120;
	window.resizeTo(width,height); 
}

function OpenVfpage(accion){
	window.open("/apex/PopupTP2?accion="+accion,"Popup","center=yes, scrollbars=yes");
}

function OpenRecordatorioCierre(){
	window.open("/apex/PopupTP2?accion=RECORDATORIOCIERREATENCION", "RecordatorioCierre","center=yes, scrollbars=no");
}

function OpenParent(url){
	window.open(url);
	return false;
}

function checkTituloVentana() {
	if(this.document) { 
		this.document.title = "Totalpack (Salesforce)";
	} else { 
		setTimeout(checkTituloVentana, 1000);
	}
}

function cronometro(duration, display) {
	var timer = duration, minutes, seconds;
	
	if (tAte == null) {
		console.log('new cron');
		var cron10min = true;
		var cron20min = true;
		
		tAte = setInterval(function () {
			minutes = parseInt(timer / 60, 10);
			seconds = parseInt(timer % 60, 10);
			
			minutes = minutes < 10 ? "0" + minutes : minutes;
			seconds = seconds < 10 ? "0" + seconds : seconds;
			
			timer++;
			tAtencion.html(minutes + ":" + seconds);
			
			if (timer > 0 && timer < 600) {
				tiempoAtencion.style.color = "#009900";
			}
			else if (timer >= 600 && timer < 1200) {
				if (cron10min) {
					notifica('Aviso', 'Han transcurrido 10 minutos desde el inicio de la atención');
					cron10min = false;
				}
				tiempoAtencion.style.color = "#ff6600";
			}
			else if (timer >= 1200){
				if (cron20min) {
					notifica('Aviso', 'Han transcurrido 20 minutos desde el inicio de la atención');
					cron20min = false;
				}
				tiempoAtencion.style.color = "#ff0000";
				tiempoAtencion.style.fontWeight = "bold";
			}
		}, 1000);  
	}
}

function recordatorio(duration, display) {
	var timer = duration, minutes, seconds;
	timer = timer / 1000;
	
	if (tRec == null) {
		tRec = setInterval(function () {
			
			minutes = parseInt(timer / 60, 10);
			seconds = parseInt(timer % 60, 10);
			
			minutes = minutes < 10 ? "0" + minutes : minutes;
			seconds = seconds < 10 ? "0" + seconds : seconds;
			
			tRecordatorio.html(minutes + ":" + seconds);
			
			if (--timer < 0) {
				alert("Recuerde cerrar la atención en curso");
				notifica('Totalpack', 'Recuerde cerrar la atención en curso');
				clearInterval(tRec);
			}
		}, 1000);
	}
}

function alertas() {
	var estado = j$("[id$='lblEstado']").html();
	tAtencion = j$('#tiempoAtencion');
	tRecordatorio = j$('#recordatorio');
	
	if (estado == "LLAMANDO") { 
		setTimeout('self.focus()',1000);
		notifica('Totalpack', 'Llamando a cliente');
	}
	else if (estado == "ATENDIENDO") {
		var timerVal = j$("[id$='hTimerRecordatorio']").val();
		var timer = parseInt(timerVal);
		
		cronometro(parseInt(tAtencion.html().split(':')[0], 10) * 60 + parseInt(tAtencion.html().split(':')[1], 10), tAtencion);
		
		if (timer != null && timer > 0){
			console.log('timeout futuro');
			recordatorio(timer, tRecordatorio);  
		}
		else {
			tRecordatorio.html('No establecido');
		}		
	}
}

function audio(){
    var yourSound = new Audio(rutaRecursosEstaticos + '/snd/notif.mp3');
    yourSound.play();
}

function notifica(titulo, cuerpo) {
  if (!Notification) {
    return;
  }

  if (Notification.permission !== "granted")
    Notification.requestPermission();
  else {
    var notification = new Notification(titulo, {
      icon: rutaRecursosEstaticos + '/img/iconoTP.gif',
      body: cuerpo,
    });
	
	audio();

    notification.onclick = function () {
      window.focus();      
    };
  }
}

j$(document).ready(function() {
	alertas();
	checkTituloVentana(); 
	windowResize();
	
	if (Notification.permission !== "granted")
		Notification.requestPermission();
});