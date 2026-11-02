/* 夏日手帖 · local search over /search.xml (hexo-generator-searchdb) */
(function () {
  'use strict';

  var input = document.getElementById('search-input');
  var results = document.getElementById('search-results');
  if (!input || !results) return;

  var index = null;
  var loading = false;
  var root = document.documentElement;

  function lang() {
    return root.getAttribute('data-lang') === 'en' ? 'en' : 'zh';
  }

  var loadFail = function () {
    loading = false;
    results.innerHTML = '<p class="search-empty">' +
      (lang() === 'zh' ? '搜索索引加载失败，请刷新重试。' : 'Failed to load the search index. Try refreshing.') +
      '</p>';
  };

  function indexUrl() {
    var meta = document.querySelector('meta[name="search-index"]');
    if (meta && meta.getAttribute('content')) return meta.getAttribute('content');
    return '/search.xml';
  }

  function loadIndex(cb) {
    if (index) return cb(index);
    if (loading) return;
    loading = true;
    fetch(indexUrl())
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
      })
      .then(function (xml) {
        var doc = new DOMParser().parseFromString(xml, 'text/xml');
        if (doc.querySelector('parsererror')) throw new Error('bad xml');
        var entries = Array.prototype.slice.call(doc.getElementsByTagName('entry'));
        index = entries.map(function (e) {
          var get = function (tag) {
            var n = e.getElementsByTagName(tag)[0];
            return n ? n.textContent : '';
          };
          return {
            title: get('title'),
            url: get('url'),
            text: get('content').replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim()
          };
        });
        loading = false;
        cb(index);
      })
      .catch(loadFail);
  }

  function escapeHtml(s) {
    return s.replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function snippet(text, kw) {
    var i = text.toLowerCase().indexOf(kw.toLowerCase());
    var start = i > 40 ? i - 40 : 0;
    var s = text.slice(start, start + 130);
    if (start > 0) s = '…' + s;
    if (start + 130 < text.length) s += '…';
    var safe = escapeHtml(s);
    if (!kw) return safe;
    var re = new RegExp('(' + kw.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
    return safe.replace(re, '<mark>$1</mark>');
  }

  function render(kw) {
    kw = kw.trim();
    if (!kw) {
      results.innerHTML = '';
      return;
    }
    var lower = kw.toLowerCase();
    var hits = index
      .map(function (item) {
        var t = item.title.toLowerCase();
        var score = t.indexOf(lower) > -1 ? 3 : item.text.toLowerCase().indexOf(lower) > -1 ? 1 : 0;
        return { item: item, score: score };
      })
      .filter(function (h) { return h.score > 0; })
      .sort(function (a, b) { return b.score - a.score; })
      .slice(0, 20);

    if (!hits.length) {
      results.innerHTML = '<p class="search-empty">' +
        (lang() === 'zh' ? '没有找到相关内容。' : 'Nothing found.') + '</p>';
      return;
    }

    results.innerHTML = hits.map(function (h) {
      return '<div class="search-result">' +
        '<h3><a href="' + h.item.url + '">' + escapeHtml(h.item.title) + '</a></h3>' +
        '<p>' + snippet(h.item.text, kw) + '</p>' +
        '</div>';
    }).join('');
  }

  var timer;
  input.addEventListener('input', function () {
    var kw = input.value;
    clearTimeout(timer);
    timer = setTimeout(function () {
      loadIndex(function () { render(kw); });
    }, 180);
  });

  input.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') { input.value = ''; results.innerHTML = ''; }
  });

  var params = new URLSearchParams(location.search);
  if (params.get('q')) {
    input.value = params.get('q');
    loadIndex(function () { render(input.value); });
  }
  input.focus();
})();
