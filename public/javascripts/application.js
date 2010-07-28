/*
  Collapsing elements
*/
var Collapse = Class.create({
	initialize: function(element, trigger, handle) {
	  this.element = element;
	  this.trigger = trigger;
	  this.handle = handle;
	  
	  if( this.shouldExpand() ) {
	    Collapsible.expand(element, handle);
	  } else {
	    Collapsible.collapse(element, handle);
	  }

    if( handle ) {
      this.observeClick();
    } else {
      this.observeMouseover();
      this.observeMouseout();
    }
	},
	observeMouseover: function() {
	  this.element.observe('mouseover', function() {
	    Collapsible.expand(this);
		});
	},
	observeMouseout: function() {
	  var collapsible = this;
	  this.element.observe('mouseout', function() {
	    if( !collapsible.shouldExpand() ) {
        Collapsible.collapse(this);
	    }
		});
	},
	observeClick: function() {
	  var collapsible = this;
	  this.handle.observe('click', function(event) {
	    if( Collapsible.expanded(collapsible.element) ) {
	      Collapsible.collapse(collapsible.element, collapsible.handle);
	    } else {  
	      Collapsible.expand(collapsible.element, collapsible.handle);
	    }
            event.stop();
	  });
	},
	shouldExpand: function() {
	  if( this.trigger == 'checkbox' ) {
	    return Checkbox.detectCheckedDescendants(this.element);
	  }
	}
});
/*
  Utility to manage collapsible elements
*/
var Collapsible = {
  expanded: function(element) {
    return element.hasClassName('active');
  },
  expand: function(element, handle) {
	  element.addClassName('active');
	  element.removeClassName('inactive');
	  if( handle ) {
	    handle.update("< hide")
	  }
  },
  collapse: function(element, handle) {
    element.addClassName('inactive');
    element.removeClassName('active');
    if( handle ) {
      handle.update("states >")
    }
  }
}
/*
  Utility for checkbox trees
*/
var Checkbox = {
  syncDescendantsOf: function(current_checkbox, ancestor) {
    var selector = 'li>input[type="checkbox"]';
    
    $(ancestor).select(selector).each(function(e) {
      e.checked = current_checkbox.checked;
    });
    $(ancestor).select('.collapse').each(function(e) {
      console.log("Found " + e);
      var collapsible = new Collapse(e, 'checkbox', e.select('.collapse_handle')[0]);
    });
    if( $(ancestor).classNames().include("collapse") ) {
      if( current_checkbox.checked == true ) {
        Collapsible.expand($(ancestor), $(ancestor).select('.collapse_handle')[0]);
      } else {
        Collapsible.collapse($(ancestor), $(ancestor).select('.collapse_handle')[0]);
      }
    }
  },
  updateAncestor: function(current_checkbox, ancestor) {
    var selector = 'input[type="checkbox"]';
    var checkbox_ancestor = current_checkbox.ancestors()[2].select(selector)[0];
    
    if( !current_checkbox.checked && !Checkbox.detectCheckedSiblings(ancestor) ) {
      checkbox_ancestor.checked = false;
    } else {
      checkbox_ancestor.checked = true;
    }
  },
  detectCheckedSiblings: function(element) {
    var selector = 'input[type="checkbox"]';
    var result = false;
    
    if( element.siblings()[0] ) {
      element.siblings().each(function(sibling) {
        if( sibling.select(selector)[0] ) {
          if( sibling.select(selector)[0].checked == true ) {
            result = true;
          }
        }
      });
    }
    return result;
  },
  detectCheckedDescendants: function(element) {
    var selector = 'li>input[type="checkbox"]';
    var result = false;
    
    if( element.select(selector)[0] ) {
      element.select(selector).each(function(checkbox) {
        if( checkbox.checked == true ) {
          result = true;
        }
      });
      return result;
    } else {
      return false;
    }
  },
  isChecked: function(checkbox) {
    return checkbox.checked;
  }
}

/*
  Init
*/
// collapsible elements
document.observe('dom:loaded', function() {
	if( $$('.collapse')[0] ) {
		$$('.collapse').each(function(e) {
			var collapsible = new Collapse(e, 'checkbox', e.select('.collapse_handle')[0]);
		});
	}
});
// checkbox tree
document.observe('dom:loaded', function() {
  if( $$('.parent_checkbox')[0] ) {
    $$('.parent_checkbox').each(function(checkbox) {
      checkbox.observe('click', function() {
        Checkbox.syncDescendantsOf(checkbox, checkbox.ancestors()[0]);
      });
    });
    $$('.child_checkbox').each(function(checkbox) {
      checkbox.observe('click', function() {
        Checkbox.updateAncestor(checkbox, checkbox.ancestors()[0]);
      });
    });
  }
});
// configurable and configurable_links elements
document.observe('dom:loaded', function() {
  if( $$('.configurable')[0] ) {
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
  }
});
