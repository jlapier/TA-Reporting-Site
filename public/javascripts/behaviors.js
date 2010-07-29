var TogglePod = Behavior.create({
  arrow: 'down',

  initialize: function() {
    this.arrow = this.element.down('img').src.match('down') ? 'down' : 'right'
    if( this.arrow == 'right')
      this.element.up('.homepage_box').down('.homepage_inner').hide();
  },
  onclick: function(e) {
    e.stop();
    if (this.arrow == 'down') {
      this.arrow = 'right';
      
    } else {
      this.arrow = 'down';
    }
    this.element.down('img').src = '/images/arrow_white_' + this.arrow + '.png';
    this.element.up('.homepage_box').down('.homepage_inner').toggle();
  }
});


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


var ShowHideLink = Behavior.create({
  initialize: function(options) {
    options = options || {};
    this.showEffect = options.show_effect;
    this.hideEffect = options.hide_effect;
    this.showEffectParams = options.show_effect_params;
    this.hideEffectParams = options.hide_effect_params;
    this.showClassName = this.element.href.toQueryParams()['show'];
    this.hideClassName = this.element.href.toQueryParams()['hide'];
    this.toggleClassName = this.element.href.toQueryParams()['toggle'];
    this.hideMe = options.hide_me;
  },

  onclick: function(e) {
    e.stop();
    if(this.hideClassName) {
      $$('.'+this.hideClassName).invoke(this.hideEffect || 'hide', this.hideEffectParams);
    }
    if(this.showClassName) {
      $$('.'+this.showClassName).invoke(this.showEffect || 'show', this.showEffectParams);
    }
    if(this.toggleClassName) {
      $$('.'+this.toggleClassName).each(function(el) {
        if(el.visible()) {
          el[this.hideEffect || 'hide'](this.hideEffectParams);
        } else {
          el[this.showEffect || 'show'](this.showEffectParams);
        }
      }.bind(this));
    }

    e.element().blur();
    if(this.hideMe) { e.element().hide(); }
  }
});



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


var Tabber = Behavior.create({
  tab_group_collection: null,
  body_group_collection: null,

  initialize: function(tab_group_css_selector, body_group_css_selector) {
    this.tab_group_collection = $$(tab_group_css_selector);
    this.body_group_collection = $$(body_group_css_selector);
    this.tab_body = $(this.element.readAttribute('tab_body'));
  },

  onclick: function(e) {
    this.tab_group_collection.invoke('removeClassName', 'helper_tabs_on');
    this.tab_group_collection.invoke('addClassName', 'helper_tabs_off');
    this.body_group_collection.invoke('hide');
    this.tab_body.show();
    this.element.removeClassName('helper_tabs_off').addClassName('helper_tabs_on').blur();
    e.stop();
  }
});


// for creating a drop-down select box under an input field - so you can autofill or type in your own value
var SelectPopper = Behavior.create({
  initialize: function(array_of_values) {
    this.values = array_of_values;
    this.select_box = DOM.Builder.fromHTML('<div id="' + this.element.identify() + '_select_box" ' +
      'class="select_popper_box" ' +
      'style="display:none; z-index: 9999; padding: 2px 4px; border: 1px solid #999; background: #FFF; position: absolute;"></div>');
    document.body.insert(this.select_box);
    var some_ul = $ul({ 'class': 'select_popper_list' });
    this.values.each( function(val) {
      some_ul.insert($li({ 'class': 'select_item' }, val));
    });
    this.select_box.insert(some_ul);
    Event.addBehavior({
      '.select_popper_box': SetSelector
    });
  },

  onfocus: function(e) {
    if(this.values.length > 0) {
      this.select_box.clonePosition(this.element, { setHeight: false, offsetLeft: 1, offsetTop: this.element.getHeight() });
      this.select_box.style.width = (this.element.offsetWidth - 2) + 'px'
      this.select_box.show();
    }
  },

  onblur: function(e) {
    var select_box = this.select_box
    setTimeout(function() {
      select_box.hide();
    }, 250);
  }
});

var SetSelector = Behavior.create({
  initialize: function() {
    this.select_field = $(this.element.identify().gsub('_select_box', ''));
  },

  onclick: Event.delegate({
    'li': function(e) {
      var el = e.element();
      this.select_field.value = el.innerHTML;
      this.element.hide();
    }
  })
});
