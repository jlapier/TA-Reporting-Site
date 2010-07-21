// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe('dom:loaded', function() {
  $$('.configurable').each(function(e) {
    e.observe('mouseover', function() {
      this.select('.configurable_links')[0].show();
      this.addClassName('highlight');
    });
    e.observe('mouseout', function() {
      this.select('.configurable_links')[0].hide();
      this.removeClassName('highlight');
    });
  });
});