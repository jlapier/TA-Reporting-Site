/*
  /activities/form
*/
var TextareaExpander = Behavior.create({
  initialize: function(linesToGrowBy, maxLines) {
    maxLines = Object.isUndefined(maxLines) ? 999 : maxLines;
    linesToGrowBy = Object.isUndefined(linesToGrowBy) ? 3 : linesToGrowBy;
    this.maxHeight = maxLines * 15;
    this.incrementBy = linesToGrowBy * 15;
    this.upsize();
    new Form.Element.Observer(this.element, 1.0, this.upsize.bind(this));
  },

  upsize: function() {
    var curr_h = this.element.getDimensions().height;
    var scroll_h = this.element.scrollHeight;
    var count = 0;
    while(curr_h < scroll_h && scroll_h < this.maxHeight && count < 50) {
      count += 1;
      this.element.setStyle( { 'height': (curr_h + this.incrementBy) + 'px' });
      curr_h = this.element.getDimensions().height;
      scroll_h = this.element.scrollHeight;
    }
  }
});

/*
  /activities/index
*/
var SortableTable = Behavior.create({
  initialize: function() {
    this.table_el = this.element;
    this.table_rows = $A(this.table_el.rows);
    this.header_row = this.table_rows.shift();
  },

  onclick: Event.delegate({
    'th' : function(e) {
      var header, sort_direction, header_index, item_and_row_sets, the_table_body;
      header = e.element();
      sort_direction = header.hasClassName('sorted_down') ? 'up' : 'down';
      header_index = $A(this.header_row.cells).indexOf(header);
      // store it all in a 2D array: [item to sort on, whole row]
      item_and_row_sets = this.table_rows.map(function(row) {
        return [row.cells[header_index].innerHTML, row]; });
      item_and_row_sets.sort(compareAnything);
      if( sort_direction == 'up' ) item_and_row_sets.reverse();

      the_table_body = this.table_el.down('tbody');
      // whenever we insert an element that already exists in the DOM, it gets plucked
      // out and placed back down - that's why we insert at the bottom, so the last thing
      // to get put in is the last item in the array
      item_and_row_sets.each(function(item_and_row) {
        the_table_body.insert( { bottom: item_and_row[1] });
      });
      $A(this.header_row.cells).invoke('removeClassName', 'sorted_down');
      $A(this.header_row.cells).invoke('removeClassName', 'sorted_up');
      header.addClassName('sorted_' + sort_direction);
    }
  })
});