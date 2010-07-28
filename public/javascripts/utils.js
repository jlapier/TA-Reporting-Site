// for array.sort(compareAnything) - compares strings, dates, numbers
// if the array is multi-dimensional, we grab just the first item in each inner array
// which is nice for sorting HTML elements by something specific inside them
function compareAnything( a, b ) {
  if(Object.isArray(a)) a = a[0];
  if(Object.isArray(b)) b = b[0];
  if(a == null || a == '') return 1
  if(b == null || b == '') return -1
  if(Object.isNumber(a) && Object.isNumber(b)) return a - b;
  if(Date.parse(a) && Date.parse(b)) return (Date.parse(a) - Date.parse(b));
  a = a.stripTags().toLowerCase();
  b = b.stripTags().toLowerCase();
  if(a > b) return 1;
  if(a < b) return -1;
  return 0;
}



// for updating draggable elements
function PostPositionUpdate(id, element) {
  var l_pos, t_pos;
  l_pos = element.positionedOffset()[0];
  t_pos = element.positionedOffset()[1];
  new Ajax.Request('/draggable_elements/update_position/' +  id, {
        parameters : { left_position : l_pos, top_position : t_pos  },
        onComplete: function() { element.setStyle({ zIndex: '' + (l_pos/10).floor() + (t_pos/10).floor() }); }
      }
    );
}


var MyElementMethods = {
  divitize: function (element, html_class){
    parent = element.up();
    html = element.innerHTML;
    d = DOM.Builder.fromHTML('<div class="'+html_class+'" id="'+element.identify()+'">'+html+'<div>');
    element.remove();
    parent.insert( d );
    return d;
  },

  meOrUp: function(element, css_selector) {
    return element.match(css_selector) ? element : element.up(css_selector);
  },

  // moves the element to the mouse pointer
  // xoffset and yoffset are optional, duration option (will make slide effect)
  // chunk optional - will make movement chunky - should be an integer
  moveToPointer: function(element, event, xoffset, yoffset, duration, chunk) {
    if (element != null) {
      if (duration == null) duration = 0;
      if (xoffset === undefined) { xoffset = 12; }
      if (yoffset === undefined) { yoffset = 12; }
      total_x = event.pointerX() + xoffset;
      total_y = event.pointerY() + yoffset;
      if (chunk) {
        total_x = (total_x / chunk).round() * chunk;
        total_y = (total_y / chunk).round() * chunk;
      }
      if (duration > 0) {
        new Effect.Move(element,
          { duration: duration, x: total_x, y: total_y, mode: 'absolute' });
      } else {
        element.setStyle({left:total_x+'px', top:total_y+'px'});
      }
    }
  }
}

Element.addMethods(MyElementMethods);