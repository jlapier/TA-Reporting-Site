/*
  Collapsing elements
*/
var Collapse = Class.create({
	initialize: function(element, trigger) {
	  this.element = element;
	  this.trigger = trigger;
	  
	  if( this.shouldExpand() ) {
	    Collapsible.expand(element);
	  } else {
	    Collapsible.collapse(element);
	  }

    this.observeMouseover();
    this.observeMouseout();
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
  expanded: function(e) {
    return e.hasClassName('active');
  },
  expand: function(e) {
	  e.addClassName('active');
	  e.removeClassName('inactive');
  },
  collapse: function(e) {
    e.addClassName('inactive');
    e.removeClassName('active');
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
      var collapsible = new Collapse(e, 'checkbox');
    });
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
      console.log("Following element has no descendants matching selector " + selector);
      console.log(element);
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
			var collapsible = new Collapse(e, 'checkbox');
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
