self.onmessage = function (e) {
  var xhr = new XMLHttpRequest();
  xhr.open("GET", e.data, false);  // synchronous request
  xhr.send(null);
  self.postMessage(xhr.responseText);
};