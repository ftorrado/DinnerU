/**
 * Javascript with multiple utilitarian functions
 * 
 * @author Filipe R. O. Torrado
 * Created at: 12-11-2014
 */

// AJAX utils
function setupFormAsync ($form, onSuccess, onFail, beforeSubmit, beforeSubmitData){
    $form.submit(function(e){
        e.preventDefault();
        var $submitter = $(this);
        var target = $(this).attr("action");
        console.log("Async form submit: " + $submitter.serialize() + " into " + target);

        if (typeof beforeSubmit !== "undefined" && !!(beforeSubmit &&
            beforeSubmit.constructor && beforeSubmit.call && beforeSubmit.apply)) {
            if(! beforeSubmit(beforeSubmitData)) {
                console.log("Pre-condition for async form has failed...");
                return;
            }
        }

        $.ajax({
            url: target,
            type: "post",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            dataType: "json",
            data: $submitter.serialize(),
            success: function(data, textStatus, jqXHR) {
                console.log("Success on submit! -> ", data);
                if (typeof data === "string")
                    data = {msg: data};
                onSuccess(data, textStatus, jqXHR);
            },
            error: function(jqXHR, textStatus, error) {
                console.log("Error on submit! -> ", jqXHR);
                if (typeof jqXHR.responseJSON !== "undefined" && typeof jqXHR.responseJSON.msg !== "undefined")
                    var data = jqXHR.responseJSON;
                else if (typeof jqXHR.responseText === "undefined")
                    var data = {msg: "Erro a submeter o formulário"};
                else {
                    try {
                        var data = JSON.parse(jqXHR.responseText);
                        if (typeof data.msg === "undefined")
                            data.msg = "Erro a submeter o formulário";
                    }
                    catch (err) {
                        var data = {msg: jqXHR.responseText};
                    }
                }
                onFail(data, textStatus, jqXHR);
            }
        });
    });
}

/**
 * Checks if given object is a DOM element
 * @see http://stackoverflow.com/a/28287642
 */
function isDomElem(obj) {
    if(obj instanceof HTMLCollection && obj.length) {
        for(var a = 0, len = obj.length; a < len; a++) {
            if(!checkInstance(obj[a])) {
                console.log(a);
                return false;
            }
        }
        return true;
    } else {
        return checkInstance(obj);
    }

    function checkInstance(elem) {
        if(isDomElemJQuery(elem) || elem instanceof HTMLElement) {
            return true;
        }
        return false;
    }
}

function isDomElemJQuery(elem) {
    return (elem instanceof jQuery && elem.length);
}

/**
 * Checks if variable is defined and not null
 */
function isset(arg) {
    return (typeof arg !== 'undefined' && arg != null);
}

/**
 * Set default value if variable has no value
 * @see: http://stackoverflow.com/questions/894860/set-a-default-parameter-value-for-a-javascript-function
 */
function defaultFor (arg, val) {
	return (!isset(arg)) ? arg : val;
}

/**
 * Gets the content of the cookie with the given name
 */
function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
}
