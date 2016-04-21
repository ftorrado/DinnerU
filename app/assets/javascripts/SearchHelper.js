/**
 * Search helper to give auto-complete to form inputs
 * <p>
 *     Available options:
 *      $destination - null - where to place selected values
 *      ajaxRequestMode - "plain" - "plain"/"json"/"default"
 *      multipleSelect - false - if selection is for one or multiple items
 * <p>
 *     Usage example:
 *     <code>
 *        userSearchHelper = new SearchHelper(
 *          $('.room-chat-input input[name="username"]'),
 *          $('.room-chat-helper'), 
 *          $('.room-chat-input input[name="message"]')
 *        );
 *     </code>
 * 
 * @author Filipe R. O. Torrado
 * Created at: 14-12-2015
 */

/**
 * Use a form input and a container box as search helper to that input
 *
 * @param $input
 * @param $searchHelperBox (need attribute "data-source", with url to get search)
 * @param $focusOnSelect (optional)
 * @param options
 * @constructor
 */
var SearchHelper = function($input, $searchHelperBox, $focusOnSelect, options) {
    this.$input = $input;
    this.$searchHelperBox = $searchHelperBox;
    this.$focusOnSelect = $focusOnSelect;
    if (typeof options.$destination != "undefined" && isDomElemJQuery(options.$destination))
        this.$destination = options.$destination;
    else
        this.$destination = $input;
    this.options = SearchHelper.getDefaultOptions($input);

    if (typeof options.$destination != "undefined" && isDomElemJQuery(options.$destination)) {
        this.options.$destination = options.$destination;
    }
    if (options.ajaxRequestMode != "undefined" && options.ajaxRequestMode != null) {
        if (options.ajaxRequestMode == "text/plain" || options.ajaxRequestMode == "plain")
            this.options.ajaxMode = "plain";
        else if (options.ajaxRequestMode == "json")
            this.options.ajaxMode = "json";
        else if (options.ajaxRequestMode == "urlencoded" || options.ajaxRequestMode == "default")
            this.options.ajaxMode = 'default'
    }
    if (options.multipleSelect instanceof bool) {
        this.options.multipleSelect = options.multipleSelect;
    }

    this.searchUrl = $searchHelperBox.attr("data-source");
    this.isOpen = false;
    this.queryShowing = null;
    this.closingTimer = null;

    this.refresh();

    var helperObj = this;
    $input.focus(function() {
        helperObj.open();
    });

    var blurFunction = function() {
        helperObj.closingTimer = setTimeout(function() {
            helperObj.close();
        }, 500);
    };
    $input.blur(blurFunction);
    $searchHelperBox.blur(blurFunction);
    var focusFunction = function() {
        if (helperObj.closingTimer == null)
            return;
        clearTimeout(helperObj.closingTimer);
        helperObj.closingTimer = null;
    };
    $input.focus(focusFunction);
    $searchHelperBox.focus(focusFunction);

    $input.keydown(function(evt) {
        if (evt.keyCode == 13) {
            evt.preventDefault();
        }
    });
    $input.keyup(function(evt) {
        if (evt.keyCode == 13 || evt.keyCode == 9) {
            // Enter/Tab - go write message
            var $selected = helperObj.$searchHelperBox.find(".element.active");
            if ($selected.length > 0)
                $(this).val($selected.find("span.helper-value").text());
            helperObj.close();
            if (helperObj.$focusOnSelect != null && typeof helperObj.$focusOnSelect !== "undefined")
                helperObj.$focusOnSelect.focus();
        }
        else if (evt.keyCode != 38 && evt.keyCode != 40) {
            helperObj.refresh();
        }
        else {
            // Up/Down
            evt.preventDefault();
            var $elements = helperObj.$searchHelperBox.find('.element');
            if ($elements.length < 1) {
                console.log("No elements on search helper");
            }
            else {
                var num = helperObj.$searchHelperBox.find('.element.active').index();
                if (num == null || num < 0) {
                    $($elements.get(0)).addClass("active");
                    helperObj.$destination.val($($elements.get(0)).find("span.helper-value").text());
                }
                else if (num >= $elements.size()) {
                    console.error("searchHelper: active index is out of bounds");
                }
                else {
                    if (evt.keyCode == 38) {
                        if (num > 0) {
                            $($elements.get(num)).removeClass('active');
                            $($elements.get(num - 1)).addClass("active");
                            helperObj.$destination.val($($elements.get(num - 1)).find("span.helper-value").text());
                        }
                    }
                    else if (evt.keyCode == 40) {
                        if (num < $elements.length - 1) {
                            $($elements.get(num)).removeClass('active');
                            $($elements.get(num + 1)).addClass("active");
                            helperObj.$destination.val($($elements.get(num + 1)).find("span.helper-value").text());
                        }
                    }
                }
            }
        }
    });
    this.$destination.on('input', function(evt) {
        if(!helperObj.$input.val() || trim(helperObj.$input.val()) == "") {
            helperObj.clearSelections();
        }
    });
};

SearchHelper.getDefaultOptions = function() {
    return {
        ajaxRequestMode: "plain",
        multipleSelect: false,
        selectOnLoad: true
    };
};

SearchHelper.prototype.refresh = function() {
    var queryToSearch = this.$input.val();
    if (this.queryShowing != null && queryToSearch === this.queryShowing)
        return;
    var helperObj = this;
    var ajaxOptions = {
        type: "post",
        url: this.searchUrl,
        dataType: "html"
    };
    if (this.options.ajaxMode == "json") {
        ajaxOptions.contentType ="application/json";
        ajaxOptions.data = JSON.stringify({ query: queryToSearch });
    }
    else if (this.options.ajaxMode == "plain") {
        ajaxOptions.contentType ="text/plain";
        ajaxOptions.data = queryToSearch;
    }
    else {
        ajaxOptions.data = {query: queryToSearch};
    }
    $.ajax(ajaxOptions)
        .done(function(data) {
            helperObj.loadWith(data);
            helperObj.queryShowing = queryToSearch;
        })
        .fail(function(error, textStatus, jqXHR) {
            toastr.error(messages.fail.request + ': ' + textStatus);
            //console.error(messages.fail.request + ': ' + textStatus+ "\n" + error);
        });
};

SearchHelper.prototype.loadWith = function(pageHtml) {
    this.$searchHelperBox.html(pageHtml);
    var $elements = this.$searchHelperBox.find('.element');
    if (this.options.selectOnLoad) {
        var $firstElement = this.$searchHelperBox.find('.element:first-child');
        $firstElement.addClass("active");
    }
    var helperObj = this;
    $elements.click(function(evt) {
        evt.preventDefault();
        $(this).addClass("active");
        helperObj.selectValue($(this).find("span.helper-value").text());
        if (! helperObj.options.multipleSelect) {
            $elements.removeClass("active");
            helperObj.close();
        }
        helperObj.$focusOnSelect.focus();
    });
};

SearchHelper.prototype.open = function() {
    this.$searchHelperBox.removeClass("hidden");
    this.isOpen = true;
};
SearchHelper.prototype.close = function() {
    this.$searchHelperBox.addClass("hidden");
    this.isOpen = false;
};
SearchHelper.prototype.toggle = function() {
    if(this.isOpen)
        this.close();
    else
        this.open();
};

SearchHelper.prototype.selectAll = function() {
    if (this.options.multipleSelect)
        return false;
    var helperObj = this;
    var $elements = helperObj.$searchHelperBox.find('.element');
    $.each($elements, function(i, element) {
        var $element = $(element);
        $element.addClass("active");
        helperObj.selectValue($element.find("span.helper-value").text());
    });
    helperObj.close();
    helperObj.$focusOnSelect.focus();
};
SearchHelper.prototype.selectValue = function(value) {
    if(this.$destination.val() == "" || !this.options.multipleSelect)
        this.$destination.val(value);
    else
        this.$destination.val(this.$destination.val() + "," + value);
};

SearchHelper.prototype.clearAll = function() {
    this.$destination.val("");
    this.clearSelections();
};
SearchHelper.prototype.clearSelections = function() {
    var $elements = this.$searchHelperBox.find('.element');
    $elements.removeClass("active");
};
