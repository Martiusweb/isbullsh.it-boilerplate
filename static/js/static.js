function top() {
  var page_size = window.innerHeight + window.scrollMaxY;
  var accel = 1.1;
  function up() {
    console.log(accel);
    if (window.pageYOffset < page_size / 10) {
      if (accel > 10) {
        accel *= 0.50;
      } else {
        accel *= 0.99;
      }
    } else {
      accel *= accel;
    }
    if (accel >= page_size/20) {
      accel = page_size/20;
    }

    window.scrollBy(0,-accel);

    if (window.pageYOffset >= 0.01) {
      setTimeout(up, 33);
    }
  }
  setTimeout(up, 33);
}

function init_scroll() {
  var totoc =  document.getElementById("totoc");
  if (totoc) {
    totoc.style.opacity = 0;
  }
  window.addEventListener("scroll", function() {
    var totoc =  document.getElementById("totoc");
    if(totoc) {
      totoc.style.opacity = window.pageYOffset / window.scrollMaxY;
    }
  }, false);
}
