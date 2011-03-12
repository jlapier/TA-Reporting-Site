/*
  /activities/form
*/
var TextareaExpander = $.klass({
  initialize: function(linesToGrowBy, maxLines) {
    maxLines = $.isPlainObject(maxLines) ? maxLines : 999;
    linesToGrowBy = $.isPlainObject(linesToGrowBy) ? linesToGrowBy : 3;
    this.maxHeight = maxLines * 15;
    this.incrementBy = linesToGrowBy * 15;
    this.upsize();
    var context = this;
    $(this.element).bind('scroll', function(e){
      context.upsize();
    });
    // scroll is triggered as newlines are added past current viewport
  },

  upsize: function() {
    var curr_h = $(this.element).height();
    var scroll_h = $(this.element).attr('scrollHeight');
    var count = 0;
    while(curr_h < scroll_h && scroll_h < this.maxHeight && count < 50) {
      count += 1;
      $(this.element).attr('style', 'height: '+(curr_h + this.incrementBy)+'px');
      curr_h = $(this.element).height();
      scroll_h = $(this.element).attr('scrollHeight');
    }
  }
});
