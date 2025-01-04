window.addEventListener('message', function(event) {
    if (event.data.type === "updateKDA") {
        document.getElementById('kills').textContent = event.data.kills;
        document.getElementById('deaths').textContent = event.data.deaths;
        
      
        const kda = parseFloat(event.data.kda).toFixed(2);
        document.getElementById('kda').textContent = kda;

        const kdaElement = document.getElementById('kda');
        if (kda >= 2.0) {
            kdaElement.style.color = '#00ff00'; // greem
        } else if (kda >= 1.0) {
            kdaElement.style.color = '#ffff00'; // yellow
        } else {
            kdaElement.style.color = '#ff0000'; // red
        }
    }
});


document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('kills').textContent = '0';
    document.getElementById('deaths').textContent = '0';
    document.getElementById('kda').textContent = '0.00';
    

    fetch(`https://${GetParentResourceName()}/loaded`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}); 