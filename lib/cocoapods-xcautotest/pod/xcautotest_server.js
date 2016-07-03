function setupServer () {


    try {
        socket = new WebSocket("ws://0.0.0.0:1101")

        socket.onopen = function(event){
            var message = { "connected": true }
            window.webkit.messageHandlers.host.postMessage(message)
        }

        socket.onerror = function(msg){
            var message = { "connected": false }
            window.webkit.messageHandlers.host.postMessage(message)
        }

        socket.onclose = function (event) {
            var message = { "connected": false }
            window.webkit.messageHandlers.host.postMessage(message)
        }

    } catch (e) {
        var message = { "connected": false }
        window.webkit.messageHandlers.host.postMessage(message)
    }

}

// Moves this call to the end of the setup call-stack in JS
setTimeout(setupServer, 1);
