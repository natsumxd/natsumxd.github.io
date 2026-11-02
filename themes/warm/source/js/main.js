/* 夏日手帖 · main interactions */
(function () {
  'use strict';

  var root = document.documentElement;

  /* ---- language ------------------------------------------------------- */
  function applyLang(lang) {
    root.setAttribute('data-lang', lang);
    root.setAttribute('lang', lang === 'zh' ? 'zh-CN' : 'en');
    var cur = document.querySelector('.lang-cur');
    var alt = document.querySelector('.lang-alt');
    if (cur && alt) {
      // button shows the language you can switch TO
      cur.textContent = lang === 'zh' ? 'EN' : '中';
      alt.textContent = lang === 'zh' ? '中' : 'EN';
    }
    try { localStorage.setItem('nb-lang', lang); } catch (e) {}
  }

  var langBtn = document.getElementById('lang-toggle');
  if (langBtn) {
    langBtn.addEventListener('click', function () {
      var next = root.getAttribute('data-lang') === 'zh' ? 'en' : 'zh';
      applyLang(next);
    });
  }

  /* ---- theme ---------------------------------------------------------- */
  function applyTheme(theme) {
    root.setAttribute('data-theme', theme);
    try { localStorage.setItem('nb-theme', theme); } catch (e) {}
  }

  var themeBtn = document.getElementById('theme-toggle');
  if (themeBtn) {
    themeBtn.addEventListener('click', function () {
      applyTheme(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
    });
  }

  /* ---- mobile nav ----------------------------------------------------- */
  var navBtn = document.getElementById('nav-toggle');
  var nav = document.getElementById('site-nav');
  if (navBtn && nav) {
    navBtn.addEventListener('click', function (e) {
      e.stopPropagation();
      nav.classList.toggle('is-open');
    });
    document.addEventListener('click', function (e) {
      if (!nav.contains(e.target)) nav.classList.remove('is-open');
    });
  }

  /* ---- sticky header -------------------------------------------------- */
  var header = document.querySelector('.site-header');
  if (header) {
    var onScrollHeader = function () {
      header.classList.toggle('is-stuck', window.scrollY > 8);
    };
    window.addEventListener('scroll', onScrollHeader, { passive: true });
    onScrollHeader();
  }

  /* ---- reading progress ----------------------------------------------- */
  var bar = document.getElementById('progress-bar');
  var article = document.querySelector('.post-body');
  if (bar && article) {
    var onScroll = function () {
      var rect = article.getBoundingClientRect();
      var total = rect.height - window.innerHeight;
      var progress = total > 0 ? Math.min(1, Math.max(0, -rect.top / total)) : (rect.top < 0 ? 1 : 0);
      bar.style.width = (progress * 100).toFixed(2) + '%';
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll);
    onScroll();
  }

  /* ---- external links ------------------------------------------------ */
  document.querySelectorAll('.post-body a[href^="http"]').forEach(function (a) {
    if (a.hostname && a.hostname !== location.hostname) {
      a.setAttribute('target', '_blank');
      a.setAttribute('rel', 'noopener noreferrer');
    }
  });

  /* ---- image lightbox (simple) --------------------------------------- */
  var overlay;
  document.querySelectorAll('.post-body img').forEach(function (img) {
    img.style.cursor = 'zoom-in';
    img.addEventListener('click', function () {
      if (!overlay) {
        overlay = document.createElement('div');
        overlay.className = 'img-overlay';
        overlay.addEventListener('click', function () { overlay.remove(); });
        document.body.appendChild(overlay);
      }
      var clone = document.createElement('img');
      clone.src = img.currentSrc || img.src;
      overlay.innerHTML = '';
      overlay.appendChild(clone);
      overlay.style.cssText =
        'position:fixed;inset:0;z-index:200;display:flex;align-items:center;justify-content:center;' +
        'background:rgba(28,22,18,.86);padding:24px;cursor:zoom-out;backdrop-filter:blur(4px)';
      clone.style.cssText = 'max-width:100%;max-height:90vh;border-radius:10px;box-shadow:0 20px 60px rgba(0,0,0,.5)';
    });
  });

  /* keep lang button label in sync on load */
  applyLang(root.getAttribute('data-lang') || 'zh');
})();
