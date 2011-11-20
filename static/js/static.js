function top() {
  var page_size = window.innerHeight + window.scrollMaxY;
  var accel = 1.1;
  function up() {
    console.log(accel);
    // Quadratic progression
    accel *= accel;
    window.scrollBy(0,-accel);
    if (window.pageYOffset !== 0) {
      setTimeout(up, 33);
    }
  }
  setTimeout(up, 33);
}
