/* Hero: typed headline word and pins that lean toward the pointer */
(function () {
  var calm = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var el = document.getElementById('heroRotator');
  if (el && !calm) {
    var words = el.dataset.words.split('|'), w = 0, n = words[0].length, del = true;
    (function step() {
      el.textContent = words[w].slice(0, n);
      var wait = del ? 38 : 75;
      if (del && n === words[w].length) wait = 2400;
      if (!del && n === words[w].length) { del = true; wait = 2400; return setTimeout(step, wait); }
      if (del && n === 0) { del = false; w = (w + 1) % words.length; return setTimeout(step, 300); }
      n += del ? -1 : 1;
      setTimeout(step, wait);
    })();
  }
  var pins = document.querySelector('.hero__pins');
  var hero = document.querySelector('.hero');
  if (pins && !calm && window.matchMedia('(hover:hover)').matches) {
    pins.style.transition = 'transform .5s ease-out';
    hero.addEventListener('pointermove', function (e) {
      var x = e.clientX / innerWidth - .5, y = e.clientY / innerHeight - .5;
      pins.style.transform = 'translate(' + (x * 16).toFixed(1) + 'px,' + (y * 12).toFixed(1) + 'px)';
    });
  }
})();
