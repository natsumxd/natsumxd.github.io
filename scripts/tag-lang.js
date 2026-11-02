/**
 * Tag plugin: {% lang zh %} ... {% endlang %}
 * Renders a bilingual content block; the theme shows only the active language.
 */
hexo.extend.tag.register(
  'lang',
  function (args, content) {
    const lang = (args[0] || 'zh').toLowerCase() === 'en' ? 'en' : 'zh';
    const body = hexo.render.renderSync({ text: content, engine: 'markdown' });
    return `<div class="lang-block" data-lang="${lang}">${body}</div>`;
  },
  { ends: true }
);
